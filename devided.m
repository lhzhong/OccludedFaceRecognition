function K = devided( I,n )
%% ����˵�������������ü�����ȡ�ϲ����������²�������
%���������
%   I:��������
%   n:�ü�λ�á���n=1����ȡ�����ϲ��֣���n=2����ȡ�����²���
%���������
%   J���ü��������

%% �����������n������������/�²��ֵĲü�
if n ==1
%     [row,col] =size(I);
% %     J(1:floor(row/2)+10-30+1,1:col) = I(30:floor(row/2)+10,1:col);
%     J(1:floor(row/2)+10-30+2,1:col) = I(30:floor(row/2)+11,1:col);
% %     J = imresize(J,[64 64]);
J(1:120,1:120) = I(31:150,1:120);
J = imresize(J,[64 64]);
[row,col] =size(J);
K(1:floor(row/2),1:col) = J(1:floor(row/2),1:col);

elseif n==2
%     [row,col] =size(I);
% %     J(1:row-10-floor(row/2)+1,1:col) = I(floor(row/2):row-10,1:col);
%     J(1:row-10-floor(row/2)+1,1:col) = I(floor(row/2):row-10,1:col);
% %     J = imresize(J,[64 64]); 

J(1:120,1:120) = I(31:150,1:120);
J = imresize(J,[64 64]);
[row,col] =size(J);
K(1:floor(row/2),1:col) = J(floor(row/2)+1:row,1:col);

end
end

