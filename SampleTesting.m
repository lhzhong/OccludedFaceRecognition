function acc = SampleTesting( path ,mypca,model,Train_LBP_hist)
%% 函数说明：进行识别
%输入参数：
%   path：训练样本的目录
%   mypca:训练返回的参数，包括有无墨镜训练和有无围巾训练
%         这里要区别的是和遮挡检测中的该参数输入，遮挡检测输入的该参数是具体的pca变换得到参数
%       mypca.one — 有无墨镜训练
%       mypca.two — 有无围巾训练
%   model:svm训练得到的模型，包括有无墨镜训练和有无围巾训练
%       model.one — 有无墨镜训练
%       model.two — 有无围巾训练
%   Train_LBP_hist:所有训练图像返回的直方图统计图
%输出参数：
%   acc:返回识别准确率
%% 对测试图像进行遮挡检测并根据检测结果获取相应区域的LBP
fdir = dir([path '*.pgm']);%获取该目录下所有pgm文件
testing_count = length(fdir);%获取该目录下pgm文件的数目
right = 0;
for i=1:testing_count
    img_test=im2double(imread([path fdir(i).name]));%读取样本
    if ndims(img_test)==3
        img_test=rgb2gray(img_test);
    end
%     imshow(img_test,[]);%%%%
    %%%%%%%%%%%%%%%%%%%%%遮挡检测%%%%%%%%%%%%%%%%%%%%%%%
    t1 = OccludedTesting(img_test, mypca.one ,model.one,1);%有无墨镜检测
    t2 = OccludedTesting(img_test, mypca.two ,model.two,2);%有无围巾检测
   
    %%%%%%%%%%%%%%%%%%%%%识别%%%%%%%%%%%%%%%%%%%%%%%
    J(1:120,1:120) = img_test(31:150,1:120);
    K = imresize(J,[64 64]);
    if t1 ==0 && t2 ==0  %无遮挡情况
        t = LBPTesting(K,Train_LBP_hist.all,0,i);
        right = right + t;
    elseif t1 ==1 && t2 ==0   %墨镜遮挡情况，获取人脸下部进行识别
        t = LBPTesting(K,Train_LBP_hist.down,2,i);
        right = right + t;
    else   %围巾遮挡情况，获取人脸上部进行识别
        t = LBPTesting(K,Train_LBP_hist.up,1,i);
        right = right + t;
    end
end
acc = right/testing_count;%识别准确率

end

