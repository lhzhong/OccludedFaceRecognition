function  t =   OccludedTesting(img_test, mypca ,model ,n)
%% ����˵����������������
%���������
%   path������������Ŀ¼
%   mypca:ѵ�������е�һЩ�任����
%       mypca.mu �� ƽ������
%       mypca.coeff �� �����任����
%       mypca.scores - PCA��ά�����������
%   model:svmѵ���õ�ģ�ͣ���ΪsvmԤ�������
%   n:ѵ��������λ�ã�n=1ѵ�������ϲ��֣�n=2ѵ�������²���
%���������
%   m:�Ƿ�����ڵ���m=1�����ڵ���m=0�������ڵ�
%% ��ȡ��������������GaborС���任
    img_test = devided(img_test,n);
%     imshow(img_test);%%%%%%
    face_test = gab(img_test);
    % ��ѵ������PCA�任�õ��Ĳ������в���������PCA��ά
    score_test=(face_test'-mypca.mu)*mypca.coeff;%���ñ任���󽫲��Ծ������ͶӰ
    % SVMѵ��
    labels_test = 1;%�����ǩ��㶨��
    [predice_label,~,~] = svmpredict(labels_test,score_test,model);
    % ����ѵ����������ڵ�������жϣ���Ϊ1��ʾ���ڵ�
    if predice_label == 1
        t = 1;
    else
        t = 0;
    end
end
