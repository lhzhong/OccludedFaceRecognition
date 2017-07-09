function  t =   OccludedTesting(img_test, mypca ,model ,n)
%% 函数说明：进行样本测试
%输入参数：
%   path：测试样本的目录
%   mypca:训练样本中的一些变换参数
%       mypca.mu — 平均人脸
%       mypca.coeff — 人脸变换矩阵
%       mypca.scores - PCA降维后的人脸矩阵
%   model:svm训练得到模型，作为svm预测的输入
%   n:训练人脸的位置，n=1训练人脸上部分；n=2训练人脸下部分
%输出参数：
%   m:是否存在遮挡。m=1存在遮挡；m=0不存在遮挡
%% 读取测试样本并进行Gabor小波变换
    img_test = devided(img_test,n);
%     imshow(img_test);%%%%%%
    face_test = gab(img_test);
    % 由训练样本PCA变换得到的参数进行测试样本的PCA降维
    score_test=(face_test'-mypca.mu)*mypca.coeff;%利用变换矩阵将测试矩阵进行投影
    % SVM训练
    labels_test = 1;%这个标签随便定义
    [predice_label,~,~] = svmpredict(labels_test,score_test,model);
    % 根据训练结果进行遮挡结果的判断，若为1表示有遮挡
    if predice_label == 1
        t = 1;
    else
        t = 0;
    end
end
