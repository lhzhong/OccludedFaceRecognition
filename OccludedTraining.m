function [ mypca,model ] = OccludedTraining(path ,n)
%% 函数说明：进行样本训练
%输入参数：
%   path：训练样本的目录
%   n:训练人脸的位置，n=1训练人脸上部分；n=2训练人脸下部分
%输出参数：
%   mypca:PCA变换后的部分参数值
%       mypca.mu — 平均人脸
%       mypca.coeff — 人脸变换矩阵
%       mypca.scores - PCA降维后的人脸矩阵
%   model:svm训练得到的模型

%% 读取训练样本并进行Gabor小波变换
fdir = dir([path '*.pgm']);%获取该目录下所有pgm文件
training_count = length(fdir);%获取该目录下pgm文件的数目
training_samples=[];%存储训练样本
energy=99;%选取前90%能量的主成分
for i=1:training_count
    img=im2double(imread([path fdir(i).name]));%读取样本
    if size(img,3)==3
         img=rgb2gray(img);
    end
    img =devided(img,n);%获取人脸上部分或下部分，1为上部分，2为下部分
    imshow(img);
    face = gab(img);%进行Gabor小波变换
    training_samples=[training_samples;face'];%存储训练样本，行表示样本，列表示特征
end
%% PCA降维
[coeff,scores,~,~,explained,mu]=pca(training_samples);
csum=cumsum(explained);%cumsum表示对向量进行累加
idx=find(csum>energy,1);%找到占总成分99%能量的前idx个主成分
coeff = coeff(:,1:idx);%选取前idx个主成分对应的特征向量，即变换矩阵
scores = scores(:,1:idx);%选取前idx对应的变换后的矩阵，即降维后的矩阵
%% SVM训练
labelnum = training_count/2;
labels = [-ones(labelnum,1);ones(labelnum,1)];%定义标签，共两类，前150个样本不存在遮挡，后150个存在遮挡
model = svmtrain(labels,scores);
mypca.mu = mu;
mypca.coeff = coeff;
mypca.scores = scores;
end

