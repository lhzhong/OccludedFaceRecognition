function Train_LBP_hist =LBPTraining( path )
%% ����˵��������LBPѵ��
%���������
%   path��ѵ��������Ŀ¼
%���������
%   Train_LBP_hist:����ѵ��ͼ���ֱ��ͼͳ��ͼ
%       Train_LBP_hist.all - ����������ֱ��ͼͳ��ͼ
%       Train_LBP_hist.up - �ϲ���������ֱ��ͼͳ��ͼ
%       Train_LBP_hist.down - �²���������ֱ��ͼͳ��ͼ
%% ��ȡĿ¼�µ��ļ�
fdir = dir([path '*.pgm']);%��ȡ��Ŀ¼������pgm�ļ�
training_count = length(fdir);%��ȡ��Ŀ¼��pgm�ļ�����Ŀ
histnum =256;%���õ���ͳ��ֱ��ͼ��LBPֵ
Train_LBP_hist_all=zeros(64,histnum,training_count);%�洢ѵ��ͼ�����յ�����ֱ��ͼ�飬64=8*8Ϊ������
Train_LBP_hist_up = zeros(32,histnum,training_count);%�洢ѵ��ͼ���ϲ��ֵ�ֱ��ͼ��
Train_LBP_hist_down = zeros(32,histnum,training_count);%�洢ѵ��ͼ���²��ֵ�ֱ��ͼ��
%% ��ÿ��ѵ��ͼ�����LBP��ȡ
k=1;
for i=1:training_count
    I=im2double(imread([path fdir(i).name]));%��ȡ����
    hist=zeros(64,histnum);%�б�ʾͼ��������б�ʾLBPֵ
    if ndims(I)==3
         I=rgb2gray(I);
    end
    J(1:120,1:120) = I(31:150,1:120);
    K = imresize(J,[64 64]);
    row = size(K,1);%ͼ������
    col = size(K,2);%ͼ������
    LBP_Im = zeros(row, col);%�洢һ��ͼ���LBPֵ
    %��LBP��������64*64��ѭ�������ֳ�8*8�����򣬶�ÿ��������ֱ��ͼͳ��
    for i1 = 2:row-1
        for j1 = 2:col-1
            pow = 0;
            for p =i1-1:i1+1
                for q = j1-1:j1+1
                    if p~=i1 ||q~=j1
                        if K(p,q)>K(i1,j1)
                            LBP_Im(i1,j1) = LBP_Im(i1,j1)+2^pow;%��ͼ����ĳ�����ص�LBPֵ
                        end
                        pow = pow+1;
                    end
                end
            end
            block_index=fix((i1-1)/8)*8+fix((j1-1)/8)+1;%��ǻ��������index
            bin_index=LBP_Im(i1,j1)+1;%���ĳ�����ض�ӦLBPֵ��index�����ｫ256��LBPֵ����Ϊ16�����
            hist(block_index,bin_index)=hist(block_index,bin_index)+1;%ֱ��ͼͳ�ƣ�ÿ��Ϊ��i����ÿ��Ϊ��j��LBP
        end
    end
    figure(1);imshow(LBP_Im,[]);%����ͼ��ʾ
    for c=1:64
        hist(c,:)=hist(c,:)/sum(hist(c,:));%��һ��
    end
    hist_up(1:row/2,:) = hist(1:row/2,:); %//////
    hist_down(1:row/2,:) = hist(row/2+1:row,:);%//////
    Train_LBP_hist_all(:,:,k)=hist;%��ѵ��������ÿ��ͼ��õ���LBPֱ��ͳ��ͼ���ŵ�Train_LBP_hist��
    Train_LBP_hist_up(:,:,k)=hist_up;
    Train_LBP_hist_down(:,:,k)=hist_down;
    k = k+1;
end
%% �������������ϲ����������²���������ֱ��ͼͳ��ͼ���ŵ�һ�������·���
Train_LBP_hist.all = Train_LBP_hist_all;
Train_LBP_hist.up = Train_LBP_hist_up;
Train_LBP_hist.down =Train_LBP_hist_down;
end

