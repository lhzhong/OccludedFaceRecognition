function face_fin = gab( I )
%% Gabor变换
% u,v: 方向、大小为方便，Ku,v记为K
%            ||K||^2
% G(Z) = ---------------- exp(-||K||^2 * Z^2)/(2*sigma*sigma) (exp(i*K*Z)-exp(-sigma*sigma/2))
%          sigma*sigma
% K = Kv * e^(i*faiu(u) )
% Kv = Kmax / (f^v)
% faiu(u) = pi * u/8

%% 预定义一些参数
sigma = 2*pi;  %高斯函数的标准差
Kmax = pi/2;
f = sqrt(2);
sigma2 = sigma^2;  %sigma的平方，方便计算，节省后面的公式代入复杂度
GaborZ = 10;  %gabor模板的大小
%% 求Gabor滤波模板
% n=1;  
for v=0:1:4  
    for u=0:1:7  
        Kv =Kmax/(f^v);  
        faiu = pi * u/8;  
        K = [Kv *cos(faiu) Kv *sin(faiu)];  
        K2 = (norm(K')).^2;  %求||K||^2 
        Gab1 = (K2 /(sigma2));  
        for zx = -GaborZ:GaborZ  
            for zy = -GaborZ:GaborZ  
                z = [zy zx]';  
                Gab2 = exp(-K2 * (zx^2 + zy^2)/(2*sigma2));  
                Gab3 = (cos(K * z) - exp(-(sigma2)/2));%实部
                Gab4 = sin(K * z); %虚部
                GrR(zx+GaborZ+1,zy+GaborZ+1) = Gab1 * Gab2 * Gab3;%求实部
                GrI(zx+GaborZ+1,zy+GaborZ+1) = Gab1 * Gab2 * Gab4;%求虚部
            end  
        end  
        GaborReal(:,:,v*8+u+1) = GrR;%赋到第三维存储
        GaborImg(:,:,v*8+u+1) = GrI;%赋到第三维存储
%         figure(1);
%         subplot(5,8,n),imshow(GrR,[]);%Gabor核表示的实部
%         n=n+1;   
    end  
end
%% 图像滤波处理
% I=double(I);%读入预处理的图
face_fin=[];%定于卷积后的矩阵，最后转化为一向量
for i = 1:40
    face_real = conv2( I, GaborReal(:,:,i), 'same' );%实部人脸卷积
    face_img  = conv2( I, GaborImg(:,:,i), 'same' );%虚部人脸卷积
    face_mode = sqrt(face_real.^2+face_img.^2);%取模
%     figure(2);
%     subplot(5 ,8 ,i ), imshow ( face_mode ,[]);
    face_pro = face_mode(:);%将特征排成一列
    tmean = mean( face_pro );
    tstd = std( face_pro );    
    face_pro = ( face_pro - tmean )/tstd;      %数据标准化 
    face_fin = [face_fin;face_pro];  %将40个特征依次排成一列
end
end

