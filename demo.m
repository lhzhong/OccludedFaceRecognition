clc;clear all;close all
tic;

%%%%%%%%%%%%%%%%%%%%设置训练和测试目录%%%%%%%%%%%%%%%%%%%
%path1和path2为150+150遮挡检测训练样本
%path3为150LBP训练样本
%path4,path5,path6为150测试样本
path1 = 'AR/train/training-Sunglasses010506080910/';%有无墨镜训练目录
path2 = 'AR/train/training-Scarf010506111213/';%有无围巾训练目录
path3 = 'AR/train/training-NonOccluded010203/';%LBP训练目录
path4 = 'AR/test/test141516/';%无遮挡测试目录
path5 = 'AR/test/test080910/';%墨镜测试目录
path6 = 'AR/test/test111213/';%围巾测试目录

%%%%%%%%%%%%%%%%%%%%%%%%%人脸训练%%%%%%%%%%%%%%%%%%%%%%%%%%
[mypca1,model1] = OccludedTraining(path1,1);%有无墨镜训练
[mypca2,model2] = OccludedTraining(path2,2);%有无围巾训练
LBP_hist = LBPTraining(path3);%LBP训练，返回训练的LBP库

%%%%%%%%%%%%%将训练得到的参数封装作为识别的输入%%%%%%%%%%%%%%%
mypca.one = mypca1; mypca.two = mypca2;
model.one = model1; model.two = model2;

%%%%%%%%%%%%%%%%%%%%%%%%%人脸识别%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc1 = SampleTesting(path4,mypca,model,LBP_hist);%识别，返回识别准确率
acc2 = SampleTesting(path5,mypca,model,LBP_hist);%识别，返回识别准确率
acc3 = SampleTesting(path6,mypca,model,LBP_hist);%识别，返回识别准确率

%%%%%%%%%%%%%%%%%%%%%%%%%%%打印%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('无遮挡测试，识别率为：%2.2f%%\n',acc1*100);
fprintf('墨镜遮挡测试，识别率为：%2.2f%%\n',acc2*100);
fprintf('围巾遮挡测试，识别率为：%2.2f%%\n',acc3*100);
toc;

