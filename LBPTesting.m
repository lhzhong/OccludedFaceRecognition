function  right =  LBPTesting( Input_Im ,Train_LBP_hist ,n,i)
%% ����˵������ȡ��������ͼ��LBP������ʶ��
%���������
%   Input_Im������Ĳ���ͼ��
%   Train_LBP_hist:ѵ��ͼ��������򷵻ص�ֱ��ͼͳ��ͼ
%   n:�����ڵ����������Ӧ�����ʶ��
%       n=0,��ȡ��������LBP
%       n=1,��ȡ�����ϲ�LBP
%       n=2,��ȡ�����²�LBP
%   i:iΪ����ͼ������У�Ϊ�˵õ�����ʶ��׼ȷ����
%���������
%   right:����1��ʾʶ����ȷ������0ʶ�����
%% ��������ͼ���ȡLBP
histnum =256;%���õ���ͳ��ֱ��ͼ��LBPֵ
row = size(Input_Im,1);
col = size(Input_Im,2);
training_count = size(Train_LBP_hist,3);%ѵ����������
hist=zeros(64,histnum);
LBP_Im = zeros(row, col);
%��LBP��������140*132��ѭ�������ֳ�7*6�����򣬶�ÿ��������ֱ��ͼͳ��
for i1 = 2:row-1
    for j1 = 2:col-1
        pow = 0;
        for p =i1-1:i1+1
            for q = j1-1:j1+1
                if p~=i1 ||q~=j1
                    if Input_Im(p,q)>Input_Im(i1,j1)
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
for c=1:64
	hist(c,:)=hist(c,:)/sum(hist(c,:)); % ��һ��
end
hist_up(1:row/2,:) = hist(1:row/2,:); %//////
hist_down(1:row/2,:) = hist(row/2+1:row,:);%//////
%% ֱ��ͼƥ�� 
test_sqr=zeros(1,training_count);%�洢����ͼ����ÿ��ѵ��ͼ��ľ���
right = 0;
%��ȡ��������LBP����ʶ��
if n==0
    for k=1:training_count
        match_hist=Train_LBP_hist(:,:,k);
        test_sqr(1,k)=sum(sum((match_hist-hist).^2));
    end
    [~,min_index]=min(test_sqr);
    if floor((min_index-1)/3)+1 == floor((i-1)/3)+1
        right=1;
    end
%��ȡ�����ϲ�LBP����ʶ��
elseif n==1
    for k=1:training_count
        match_hist=Train_LBP_hist(:,:,k);
        test_sqr(1,k)=sum(sum((match_hist-hist_up).^2));
    end
    [~,min_index]=min(test_sqr);
    if floor((min_index-1)/3)+1 == floor((i-1)/3)+1
        right=1;
    end
%��ȡ�����²�LBP����ʶ��
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

