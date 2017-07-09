function Train_LBP_hist =LBPTraining( path )
%% 函数说明：进行LBP训练
%输入参数：
%   path：训练样本的目录
%输出参数：
%   Train_LBP_hist:所有训练图像的直方图统计图
%       Train_LBP_hist.all - 整个人脸的直方图统计图
%       Train_LBP_hist.up - 上部分人脸的直方图统计图
%       Train_LBP_hist.down - 下部分人脸的直方图统计图
%% 获取目录下的文件
fdir = dir([path '*.pgm']);%获取该目录下所有pgm文件
training_count = length(fdir);%获取该目录下pgm文件的数目
histnum =256;%最后得到的统计直方图的LBP值
Train_LBP_hist_all=zeros(64,histnum,training_count);%存储训练图像最终的所有直方图块，64=8*8为区域数
Train_LBP_hist_up = zeros(32,histnum,training_count);%存储训练图像上部分的直方图块
Train_LBP_hist_down = zeros(32,histnum,training_count);%存储训练图像下部分的直方图块
%% 对每张训练图像进行LBP提取
k=1;
for i=1:training_count
    I=im2double(imread([path fdir(i).name]));%读取样本
    hist=zeros(64,histnum);%行表示图像的区域，列表示LBP值
    if ndims(I)==3
         I=rgb2gray(I);
    end
    J(1:120,1:120) = I(31:150,1:120);
    K = imresize(J,[64 64]);
    row = size(K,1);%图像行数
    col = size(K,2);%图像列数
    LBP_Im = zeros(row, col);%存储一幅图像的LBP值
    %求LBP特征，共64*64次循环，划分成8*8个区域，对每个区域做直方图统计
    for i1 = 2:row-1
        for j1 = 2:col-1
            pow = 0;
            for p =i1-1:i1+1
                for q = j1-1:j1+1
                    if p~=i1 ||q~=j1
                        if K(p,q)>K(i1,j1)
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
    figure(1);imshow(LBP_Im,[]);%纹理图显示
    for c=1:64
        hist(c,:)=hist(c,:)/sum(hist(c,:));%归一化
    end
    hist_up(1:row/2,:) = hist(1:row/2,:); %//////
    hist_down(1:row/2,:) = hist(row/2+1:row,:);%//////
    Train_LBP_hist_all(:,:,k)=hist;%将训练样本的每幅图像得到的LBP直方统计图都放到Train_LBP_hist中
    Train_LBP_hist_up(:,:,k)=hist_up;
    Train_LBP_hist_down(:,:,k)=hist_down;
    k = k+1;
end
%% 将整个人脸、上部分人脸、下部分人脸的直方图统计图都放到一个变量下返回
Train_LBP_hist.all = Train_LBP_hist_all;
Train_LBP_hist.up = Train_LBP_hist_up;
Train_LBP_hist.down =Train_LBP_hist_down;
end

