% clc;
% clear all;
% close all;

%% Exercise 1
reflectance = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\MacbethColorCheckerReflectances.csv');
camera1 = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\Nikon_D90.csv')
camera2 = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\Canon_1Ds-Mk-II.csv');

% figure
% plot(camera1.data(:,1), camera1.data(:,2),'r');
% hold on;
% plot(camera1.data(:,1), camera1.data(:,3),'g');
% hold on;
% plot(camera1.data(:,1), camera1.data(:,4),'b');
% title('Nikon D90');
% 
% figure
% plot(camera2.data(:,1), camera2.data(:,2),'r');
% hold on;
% plot(camera2.data(:,1), camera2.data(:,3),'g');
% hold on;
% plot(camera2.data(:,1), camera2.data(:,4),'b');
% title('Canon 1Ds MkII');

% figure
% plot(reflectance.data(1,:),reflectance.data(2,:));
% title('Patch 1 Reflectance')

IlluminantD65 = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\illuminant-D65.csv');
IlluminantA = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\illuminant-A.csv');

wavelengths = camera1.data(:,1);

%Interpolations
illuminantD65Int = interp1(IlluminantD65.data(:,1), IlluminantD65.data(:,2), camera2.data(:,1));
illuminantAInt = interp1(IlluminantA.data(:,1), IlluminantA.data(:,2), camera2.data(:,1));

reflectanceInt = (interp1(reflectance.data(1,:)',reflectance.data(2:end,:)',wavelengths))';

% figure
% plot(wavelengths,illuminantD65Int);
% title('Spectrum Illuminant D65')
% 
% figure
% plot(wavelengths,illuminantAInt);
% title('Spectrum Illuminant A')

illuminantD65Int = transpose(illuminantD65Int);
illuminantAInt = transpose(illuminantAInt);

observer1 = camera1.data(:,2:4);
observer2 = camera2.data(:,2:4);
s = size(reflectanceInt);

radiance1 = (reflectanceInt .* repmat(illuminantAInt,[s(1) 1])) * observer2;

% mcc = visualizeColorChecker(mat2gray(radiance1));
% figure;imshow(mcc)

radiance2 = (reflectanceInt .* repmat(illuminantD65Int,[s(1) 1])) * observer1;
 
% mcc = visualizeColorChecker(mat2gray(radiance2));
% figure;imshow(mcc)

radiance3 = (reflectanceInt .* repmat(illuminantAInt,[s(1) 1])) * observer1;

% mcc = visualizeColorChecker(mat2gray(radiance3));
% figure;imshow(mcc)

radiance4 = (reflectanceInt .* repmat(illuminantD65Int,[s(1) 1])) * observer2;

% mcc = visualizeColorChecker(mat2gray(radiance4));
% figure;imshow(mcc)



% Select an achromatic patch with which to white balance.
% Let's pick the 23rd gray, with 9% reflectance but experiment with
% different patches!
wbpatch1 = radiance1(23,:); 
wbpatch2 = radiance2(23,:); 
wbpatch3 = radiance3(23,:); 
wbpatch4 = radiance4(23,:); 

% perform simple white balancing 
rgb_wb1 = 0.09*radiance1./repmat(wbpatch1,[size(radiance1,1),1]);
rgb_wb2 = 0.09*radiance2./repmat(wbpatch2,[size(radiance2,1),1]);
rgb_wb3 = 0.09*radiance3./repmat(wbpatch3,[size(radiance3,1),1]);
rgb_wb4 = 0.09*radiance4./repmat(wbpatch4,[size(radiance4,1),1]);

% Visualize the resulting colors
mcc_wb1 = visualizeColorChecker(rgb_wb1);
mcc_wb2 = visualizeColorChecker(rgb_wb2);
mcc_wb3 = visualizeColorChecker(rgb_wb3);
mcc_wb4 = visualizeColorChecker(rgb_wb4);

% Display and save the resulting image
figure;imshow(mcc_wb1)
figure;imshow(mcc_wb2)
figure;imshow(mcc_wb3)
figure;imshow(mcc_wb4)

