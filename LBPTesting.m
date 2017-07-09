function  right =  LBPTesting( Input_Im ,Train_LBP_hist ,n,i)
%% 函数说明：获取单个测试图像LBP并进行识别
%输入参数：
%   Input_Im：输入的测试图像
%   Train_LBP_hist:训练图像对于区域返回的直方图统计图
%   n:根据遮挡情况进行相应区域的识别，
%       n=0,获取整个人脸LBP
%       n=1,获取人脸上部LBP
%       n=2,获取人脸下部LBP
%   i:i为测试图像的序列，为了得到最后的识别准确率用
%输出参数：
%   right:返回1表示识别正确，返回0识别错误
%% 单个测试图像获取LBP
histnum =256;%最后得到的统计直方图的LBP值
row = size(Input_Im,1);
col = size(Input_Im,2);
training_count = size(Train_LBP_hist,3);%训练样本总数
hist=zeros(64,histnum);
LBP_Im = zeros(row, col);
%求LBP特征，共140*132次循环，划分成7*6个区域，对每个区域做直方图统计
for i1 = 2:row-1
    for j1 = 2:col-1
        pow = 0;
        for p =i1-1:i1+1
            for q = j1-1:j1+1
                if p~=i1 ||q~=j1
                    if Input_Im(p,q)>Input_Im(i1,j1)
                        LBP_Im(i1,j1) = LBP_Im(i1,j1)+2^pow;%求图像中某个像素的LBP值
                    end
                    pow = pow+1;
                end
            end
        end
        block_index=fix((i1-1)/8)*8+fix((j1-1)/8)+1;%标记划分区域的index
        bin_index=LBP_Im(i1,j1)+1;%标记某个像素对应LBP值得index，这里将256个LBP值划分为16个类别
        hist(block_index,bin_index)=hist(block_index,bin_index)+1;%直方图统计，每行为第i区域，每列为第j类LBP
    end
end
for c=1:64
	hist(c,:)=hist(c,:)/sum(hist(c,:)); % 归一化
end
hist_up(1:row/2,:) = hist(1:row/2,:); %//////
hist_down(1:row/2,:) = hist(row/2+1:row,:);%//////
%% 直方图匹配 
test_sqr=zeros(1,training_count);%存储测试图像与每个训练图像的距离
right = 0;
%获取整个人脸LBP进行识别
if n==0
    for k=1:training_count
        match_hist=Train_LBP_hist(:,:,k);
        test_sqr(1,k)=sum(sum((match_hist-hist).^2));
    end
    [~,min_index]=min(test_sqr);
    if floor((min_index-1)/3)+1 == floor((i-1)/3)+1
        right=1;
    end
%获取人脸上部LBP进行识别
elseif n==1
    for k=1:training_count
        match_hist=Train_LBP_hist(:,:,k);
        test_sqr(1,k)=sum(sum((match_hist-hist_up).^2));
    end
    [~,min_index]=min(test_sqr);
    if floor((min_index-1)/3)+1 == floor((i-1)/3)+1
        right=1;
    end
%获取人脸下部LBP进行识别
else
    for k=1:training_count
        match_hist=Train_LBP_hist(:,:,k);
        test_sqr(1,k)=sum(sum((match_hist-hist_down).^2));
    end
    [~,min_index]=min(test_sqr);
    if floor((min_index-1)/3)+1 == floor((i-1)/3)+1
        right=1;
    end
end
end

