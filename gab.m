function face_fin = gab( I )
%% Gabor�任
% u,v: ���򡢴�СΪ���㣬Ku,v��ΪK
%            ||K||^2
% G(Z) = ---------------- exp(-||K||^2 * Z^2)/(2*sigma*sigma) (exp(i*K*Z)-exp(-sigma*sigma/2))
%          sigma*sigma
% K = Kv * e^(i*faiu(u) )
% Kv = Kmax / (f^v)
% faiu(u) = pi * u/8

%% Ԥ����һЩ����
sigma = 2*pi;  %��˹�����ı�׼��
Kmax = pi/2;
f = sqrt(2);
sigma2 = sigma^2;  %sigma��ƽ����������㣬��ʡ����Ĺ�ʽ���븴�Ӷ�
GaborZ = 10;  %gaborģ��Ĵ�С
%% ��Gabor�˲�ģ��
% n=1;  
for v=0:1:4  
    for u=0:1:7  
        Kv =Kmax/(f^v);  
        faiu = pi * u/8;  
        K = [Kv *cos(faiu) Kv *sin(faiu)];  
        K2 = (norm(K')).^2;  %��||K||^2 
        Gab1 = (K2 /(sigma2));  
        for zx = -GaborZ:GaborZ  
            for zy = -GaborZ:GaborZ  
                z = [zy zx]';  
                Gab2 = exp(-K2 * (zx^2 + zy^2)/(2*sigma2));  
                Gab3 = (cos(K * z) - exp(-(sigma2)/2));%ʵ��
                Gab4 = sin(K * z); %�鲿
                GrR(zx+GaborZ+1,zy+GaborZ+1) = Gab1 * Gab2 * Gab3;%��ʵ��
                GrI(zx+GaborZ+1,zy+GaborZ+1) = Gab1 * Gab2 * Gab4;%���鲿
            end  
        end  
        GaborReal(:,:,v*8+u+1) = GrR;%��������ά�洢
        GaborImg(:,:,v*8+u+1) = GrI;%��������ά�洢
%         figure(1);
%         subplot(5,8,n),imshow(GrR,[]);%Gabor�˱�ʾ��ʵ��
%         n=n+1;   
    end  
end
%% ͼ���˲�����
% I=double(I);%����Ԥ�����ͼ
face_fin=[];%���ھ����ľ������ת��Ϊһ����
for i = 1:40
    face_real = conv2( I, GaborReal(:,:,i), 'same' );%ʵ���������
    face_img  = conv2( I, GaborImg(:,:,i), 'same' );%�鲿�������
    face_mode = sqrt(face_real.^2+face_img.^2);%ȡģ
%     figure(2);
%     subplot(5 ,8 ,i ), imshow ( face_mode ,[]);
    face_pro = face_mode(:);%�������ų�һ��
    tmean = mean( face_pro );
    tstd = std( face_pro );    
    face_pro = ( face_pro - tmean )/tstd;      %���ݱ�׼�� 
    face_fin = [face_fin;face_pro];  %��40�����������ų�һ��
end
end

