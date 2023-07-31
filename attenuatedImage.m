%im = im2double(imread('D:\Piet\Cruise\Data\6\uncorrectedTiff\6_36.tif'));
eval(1) = R_eval;
eval(2) = G_eval;
eval(3) = B_eval;
imWB(:,:,1) = I(:,:,1)/R_eval;
imWB(:,:,2) = I(:,:,2)/G_eval;
imWB(:,:,3) = I(:,:,3)/B_eval;
imWB = imWB .* 0.362;

% imshow(imWB);
mask = im2double(imread('D:\Piet\Cruise\Data\9\uncorrectedTiff\mask\9_mask.png'));
Imask = I .* mask;
imWBMask = imWB .* mask;
% figure;
% imshow(imWBMask);
% 
% figure;
% imWBMask(imWBMask==0) = NaN;
% subplot(3, 1, 1);
% imhist(imWBMask(:,:,1));
% mR = mean(imhist(imWBMask(:,:,1)));
% vaR = var(imhist(imWBMask(:,:,1)));
% title('Red Channel')
% subplot(3, 1, 2);
% imhist(imWBMask(:,:,2));
% mG = mean(imhist(imWBMask(:,:,2)));
% vaG = var(imhist(imWBMask(:,:,2)));
% title('Green Channel')
% subplot(3, 1, 3);
% hist = imhist(imWBMask(:,:,3));
% mB = mean(imhist(imWBMask(:,:,3)));
% vaB = var(imhist(imWBMask(:,:,3)));
% title('Blue Channel')
% 
% figure;
% Imask(Imask==0) = NaN;
% subplot(3, 1, 1);
% imhist(Imask(:,:,1));
% mRo = mean(imhist(Imask(:,:,1)));
% vaBo = var(imhist(Imask(:,:,1)));
% title('Red Channel')
% subplot(3, 1, 2);
% imhist(Imask(:,:,2));
% mGo = mean(imhist(Imask(:,:,2)));
% vaGo = var(imhist(Imask(:,:,2)));
% title('Green Channel')
% subplot(3, 1, 3);
% imhist(Imask(:,:,3));
% mBo = mean(imhist(Imask(:,:,3)));
% vaBo = var(imhist(Imask(:,:,3)));
% title('Blue Channel')

for i=1:3
    channel = Imask(:,:,i);
    cannel = nonzeros(channel);
    histo = channel(:);
 
    m = mean(histo);
    v = var(histo);
    disp(m);
    disp(v);
    disp(i);
    disp('___________________________________');
end
