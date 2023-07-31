hsvIm = rgb2hsv(imWBMask);
figure;
imshow(imWBMask);
hsvIm(:,:,3) = hsvIm(:,:,3).*3;
hsvIm(:,:,2) = hsvIm(:,:,2).*1.4;
hsvIm = hsv2rgb(hsvIm);
hsvIm = lin2rgb(hsvIm, 'ColorSpace','adobe-rgb-1998');
figure;
imshow(hsvIm);
%gamma