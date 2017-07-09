function K = devided( I,n )
%% 函数说明：进行人脸裁剪，获取上部分人脸或下部分人脸
%输入参数：
%   I:输入人脸
%   n:裁剪位置。若n=1，获取人脸上部分；若n=2，获取人脸下部分
%输出参数：
%   J：裁剪后的人脸

%% 根据输入参数n来进行人脸上/下部分的裁剪
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

