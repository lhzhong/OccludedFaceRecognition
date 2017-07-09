clc;clear all;close all
tic;

%%%%%%%%%%%%%%%%%%%%����ѵ���Ͳ���Ŀ¼%%%%%%%%%%%%%%%%%%%
%path1��path2Ϊ150+150�ڵ����ѵ������
%path3Ϊ150LBPѵ������
%path4,path5,path6Ϊ150��������
path1 = 'AR/train/training-Sunglasses010506080910/';%����ī��ѵ��Ŀ¼
path2 = 'AR/train/training-Scarf010506111213/';%����Χ��ѵ��Ŀ¼
path3 = 'AR/train/training-NonOccluded010203/';%LBPѵ��Ŀ¼
path4 = 'AR/test/test141516/';%���ڵ�����Ŀ¼
path5 = 'AR/test/test080910/';%ī������Ŀ¼
path6 = 'AR/test/test111213/';%Χ�����Ŀ¼

%%%%%%%%%%%%%%%%%%%%%%%%%����ѵ��%%%%%%%%%%%%%%%%%%%%%%%%%%
[mypca1,model1] = OccludedTraining(path1,1);%����ī��ѵ��
[mypca2,model2] = OccludedTraining(path2,2);%����Χ��ѵ��
LBP_hist = LBPTraining(path3);%LBPѵ��������ѵ����LBP��

%%%%%%%%%%%%%��ѵ���õ��Ĳ�����װ��Ϊʶ�������%%%%%%%%%%%%%%%
mypca.one = mypca1; mypca.two = mypca2;
model.one = model1; model.two = model2;

%%%%%%%%%%%%%%%%%%%%%%%%%����ʶ��%%%%%%%%%%%%%%%%%%%%%%%%%%%
acc1 = SampleTesting(path4,mypca,model,LBP_hist);%ʶ�𣬷���ʶ��׼ȷ��
acc2 = SampleTesting(path5,mypca,model,LBP_hist);%ʶ�𣬷���ʶ��׼ȷ��
acc3 = SampleTesting(path6,mypca,model,LBP_hist);%ʶ�𣬷���ʶ��׼ȷ��

%%%%%%%%%%%%%%%%%%%%%%%%%%%��ӡ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('���ڵ����ԣ�ʶ����Ϊ��%2.2f%%\n',acc1*100);
fprintf('ī���ڵ����ԣ�ʶ����Ϊ��%2.2f%%\n',acc2*100);
fprintf('Χ���ڵ����ԣ�ʶ����Ϊ��%2.2f%%\n',acc3*100);
toc;

