function acc = SampleTesting( path ,mypca,model,Train_LBP_hist)
%% ����˵��������ʶ��
%���������
%   path��ѵ��������Ŀ¼
%   mypca:ѵ�����صĲ�������������ī��ѵ��������Χ��ѵ��
%         ����Ҫ������Ǻ��ڵ�����еĸò������룬�ڵ��������ĸò����Ǿ����pca�任�õ�����
%       mypca.one �� ����ī��ѵ��
%       mypca.two �� ����Χ��ѵ��
%   model:svmѵ���õ���ģ�ͣ���������ī��ѵ��������Χ��ѵ��
%       model.one �� ����ī��ѵ��
%       model.two �� ����Χ��ѵ��
%   Train_LBP_hist:����ѵ��ͼ�񷵻ص�ֱ��ͼͳ��ͼ
%���������
%   acc:����ʶ��׼ȷ��
%% �Բ���ͼ������ڵ���Ⲣ���ݼ������ȡ��Ӧ�����LBP
fdir = dir([path '*.pgm']);%��ȡ��Ŀ¼������pgm�ļ�
testing_count = length(fdir);%��ȡ��Ŀ¼��pgm�ļ�����Ŀ
right = 0;
for i=1:testing_count
    img_test=im2double(imread([path fdir(i).name]));%��ȡ����
    if ndims(img_test)==3
        img_test=rgb2gray(img_test);
    end
%     imshow(img_test,[]);%%%%
    %%%%%%%%%%%%%%%%%%%%%�ڵ����%%%%%%%%%%%%%%%%%%%%%%%
    t1 = OccludedTesting(img_test, mypca.one ,model.one,1);%����ī�����
    t2 = OccludedTesting(img_test, mypca.two ,model.two,2);%����Χ����
   
    %%%%%%%%%%%%%%%%%%%%%ʶ��%%%%%%%%%%%%%%%%%%%%%%%
    J(1:120,1:120) = img_test(31:150,1:120);
    K = imresize(J,[64 64]);
    if t1 ==0 && t2 ==0  %���ڵ����
        t = LBPTesting(K,Train_LBP_hist.all,0,i);
        right = right + t;
    elseif t1 ==1 && t2 ==0   %ī���ڵ��������ȡ�����²�����ʶ��
        t = LBPTesting(K,Train_LBP_hist.down,2,i);
        right = right + t;
    else   %Χ���ڵ��������ȡ�����ϲ�����ʶ��
        t = LBPTesting(K,Train_LBP_hist.up,1,i);
        right = right + t;
    end
end
acc = right/testing_count;%ʶ��׼ȷ��

end

