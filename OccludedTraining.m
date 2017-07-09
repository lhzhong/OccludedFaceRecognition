function [ mypca,model ] = OccludedTraining(path ,n)
%% ����˵������������ѵ��
%���������
%   path��ѵ��������Ŀ¼
%   n:ѵ��������λ�ã�n=1ѵ�������ϲ��֣�n=2ѵ�������²���
%���������
%   mypca:PCA�任��Ĳ��ֲ���ֵ
%       mypca.mu �� ƽ������
%       mypca.coeff �� �����任����
%       mypca.scores - PCA��ά�����������
%   model:svmѵ���õ���ģ��

%% ��ȡѵ������������GaborС���任
fdir = dir([path '*.pgm']);%��ȡ��Ŀ¼������pgm�ļ�
training_count = length(fdir);%��ȡ��Ŀ¼��pgm�ļ�����Ŀ
training_samples=[];%�洢ѵ������
energy=99;%ѡȡǰ90%���������ɷ�
for i=1:training_count
    img=im2double(imread([path fdir(i).name]));%��ȡ����
    if size(img,3)==3
         img=rgb2gray(img);
    end
    img =devided(img,n);%��ȡ�����ϲ��ֻ��²��֣�1Ϊ�ϲ��֣�2Ϊ�²���
    imshow(img);
    face = gab(img);%����GaborС���任
    training_samples=[training_samples;face'];%�洢ѵ���������б�ʾ�������б�ʾ����
end
%% PCA��ά
[coeff,scores,~,~,explained,mu]=pca(training_samples);
csum=cumsum(explained);%cumsum��ʾ�����������ۼ�
idx=find(csum>energy,1);%�ҵ�ռ�ܳɷ�99%������ǰidx�����ɷ�
coeff = coeff(:,1:idx);%ѡȡǰidx�����ɷֶ�Ӧ���������������任����
scores = scores(:,1:idx);%ѡȡǰidx��Ӧ�ı任��ľ��󣬼���ά��ľ���
%% SVMѵ��
labelnum = training_count/2;
labels = [-ones(labelnum,1);ones(labelnum,1)];%�����ǩ�������࣬ǰ150�������������ڵ�����150�������ڵ�
model = svmtrain(labels,scores);
mypca.mu = mu;
mypca.coeff = coeff;
mypca.scores = scores;
end

