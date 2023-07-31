close all;
clear all; 
clc;

%% Load Images
load MacbethColorCheckerData.mat;

im1 = im2double(imread('C:\Users\PIET\Desktop\UW_Colorimetry\images\Cpng\PL17_117puebel-r4-s4-f4-c2-d1.png'));
im2 = im2double(imread('C:\Users\PIET\Desktop\UW_Colorimetry\images\Cpng\28366gumboc-r3-s1-f1-c2-d1.png'));
im3 = im2double(imread('C:\Users\PIET\Desktop\UW_Colorimetry\images\Cpng\PL17_157pueflo-r2-s4-f4-c2-d1.png'));

im1 = imrotate(im1,-90);
im2 = imrotate(im2,-90);
im3 = imrotate(im3,-90); 

s = size(im1);

% figure;imshow(im1)
% title('Linear image','fontsize',20)
% 
% figure;imshow(im2)
% title('Linear image','fontsize',20)
% 
% figure;imshow(im3)
% title('Linear image','fontsize',20)

%% Load Masks

% masks1 = makeChartMask(im1,chart,colors);
% save('image1_masks.mat','masks1');
% 
% masks2 = makeChartMask(im2,chart,colors);
% save('image2_masks.mat','masks2');
% 
% masks3 = makeChartMask(im3,chart,colors);
% save('image3_masks.mat','masks3');

%% WB 

load('image1_masks.mat');
load('image2_masks.mat');
load('image3_masks.mat');

Ilinearized1 = im1;
whitePatch = [4 1];
darkPatch = [4 6];
I1whitebalanced = whiteBalance(Ilinearized1,masks1.(colors{whitePatch(1),whitePatch(2)}).mask,masks1.(colors{darkPatch(1),darkPatch(2)}).mask,0.8);
figure;imshow(I1whitebalanced)
title('6 White balanced image no. 1','fontsize',20)

Ilinearized2 = im2;
whitePatch = [4 1];
darkPatch = [4 6];
I2whitebalanced = whiteBalance(Ilinearized2,masks2.(colors{whitePatch(1),whitePatch(2)}).mask,masks2.(colors{darkPatch(1),darkPatch(2)}).mask,0.8);
figure;imshow(I2whitebalanced)
title('6 White balanced image no. 2','fontsize',20)

Ilinearized3 = im3;
whitePatch = [4 1];
darkPatch = [4 6];
I3whitebalanced = whiteBalance(Ilinearized3,masks3.(colors{whitePatch(1),whitePatch(2)}).mask,masks3.(colors{darkPatch(1),darkPatch(2)}).mask,0.8);
figure;imshow(I3whitebalanced)
title('6 White balanced image no. 3','fontsize',20)

%% Derive T

RGB1 = getChartRGBvalues(I1whitebalanced,masks1,colors);
XYZ1 = getChartXYZvalues(chart,colors);
T1 = XYZ1' * pinv(RGB1)';

RGB2 = getChartRGBvalues(I2whitebalanced,masks2,colors);
XYZ2 = getChartXYZvalues(chart,colors);
T2 = XYZ2' * pinv(RGB2)';

RGB3 = getChartRGBvalues(I3whitebalanced,masks3,colors);
XYZ3 = getChartXYZvalues(chart,colors);
T3 = XYZ3' * pinv(RGB3)';

%% Apply T

I1xyz = reshape((T1*reshape(I1whitebalanced,[s(1)*s(2) 3])')',[s(1) s(2) 3]);
I1xyz(I1xyz < 0) = 0; % Check for negative values
I1PPrgb = XYZ2ProPhoto(I1xyz); % ProPhoto is a wide gamut RGB space that won't clip most colors.
figure;imshow(I1PPrgb);title('PP Color transformed image no. 1','fontsize',20)

I2xyz = reshape((T2*reshape(I2whitebalanced,[s(1)*s(2) 3])')',[s(1) s(2) 3]);
I2xyz(I2xyz < 0) = 0; % Check for negative values
I2PPrgb = XYZ2ProPhoto(I2xyz); % ProPhoto is a wide gamut RGB space that won't clip most colors.
figure;imshow(I2PPrgb);title('PP Color transformed image no. 2','fontsize',20)

I3xyz = reshape((T3*reshape(I3whitebalanced,[s(1)*s(2) 3])')',[s(1) s(2) 3]);
I3xyz(I3xyz < 0) = 0; % Check for negative values
I3PPrgb = XYZ2ProPhoto(I3xyz); % ProPhoto is a wide gamut RGB space that won't clip most colors.
figure;imshow(I3PPrgb);title('PP Color transformed image no. 3','fontsize',20)


%% Extracting Chart values for XYZ
% 
% load('image1_masks.mat');
% load('image2_masks.mat');
% load('image3_masks.mat');

XYZ1values = getChartRGBvalues(I1xyz, masks1, colors);
XYZ2values = getChartRGBvalues(I2xyz, masks2, colors);
XYZ3values = getChartRGBvalues(I3xyz, masks3, colors);


%% Convert to xy and plot

xy1 = XYZ1values./sum(XYZ1values,2);
xy2 = XYZ2values./sum(XYZ2values,2);
xy3 = XYZ3values./sum(XYZ3values,2);

% Plot on the chromaticity diagram
plotChromaticity
hold on

plot(xy1(:,1),xy1(:,2),'ks','markersize',10,'linewidth',3,'Color','b') 
set(gca,'fontsize',30)
set(gca,'xlim',[0 1])
set(gca,'ylim',[0 1])
hold on

plot(xy2(:,1),xy2(:,2),'o','markersize',10,'linewidth',3,'Color','b')
set(gca,'fontsize',30)
set(gca,'xlim',[0 1])
set(gca,'ylim',[0 1])
hold on

plot(xy2(:,1),xy2(:,2),'kx','markersize',10,'linewidth',3,'Color','b')
set(gca,'fontsize',30)
set(gca,'xlim',[0 1])
set(gca,'ylim',[0 1])

title('6 Chromaticity diagram')
legend('','Img 1', 'Img 2', 'Img 3')
saveas(gcf,'6_chromaticity_diagram.png');
%% Write CSVs

writematrix(xy1,'6_image1_xy.csv');
writematrix(xy2,'6_image2_xy.csv');
writematrix(xy3,'6_image3_xy.csv');


%% Extracting chart values for PhotoPro RGB and write CSV

% load('image1_masks.mat');
% load('image2_masks.mat');
% load('image3_masks.mat');

PPrgb1ChartValues = getChartRGBvalues(I1PPrgb, masks1, colors);
PPrgb2ChartValues = getChartRGBvalues(I2PPrgb, masks2, colors);
PPrgb3ChartValues = getChartRGBvalues(I3PPrgb, masks3, colors);

writematrix(PPrgb1ChartValues,'6_image1_ProPhoto.csv');
writematrix(PPrgb2ChartValues,'6_image2_ProPhoto.csv');
writematrix(PPrgb3ChartValues,'6_image3_ProPhoto.csv');


%% Side by side comparison

figure
imshowpair(im1,I1PPrgb,'montage');
title('Raw RGB ProPhoto Comparison 1')
saveas(gcf,'6_Raw-RGB-ProPhoto-Comparison1.jpg');

figure
imshowpair(im2,I2PPrgb,'montage');
title('Raw RGB ProPhoto Comparison 2')
saveas(gcf,'6_Raw-RGB-ProPhoto-Comparison2.jpg');
figure

imshowpair(im3,I3PPrgb,'montage');
title('Raw RGB ProPhoto Comparison 3')
saveas(gcf,'6_Raw-RGB-ProPhoto-Comparison3.jpg');

%% Calculate angles
i = 1;

for i = 1:24
error12(i) = colorangle(PPrgb1ChartValues(i,:),PPrgb2ChartValues(i,:));
error13(i) = colorangle(PPrgb1ChartValues(i,:),PPrgb3ChartValues(i,:));
error23(i) = colorangle(PPrgb2ChartValues(i,:),PPrgb3ChartValues(i,:));
averageerror(i) = (error12(i) + error13(i) + error23(i))/3;

end

writematrix(error12,'6_error12.csv');
writematrix(error13,'6_error13.csv');
writematrix(error23,'6_error23.csv');
writematrix(averageerror,'6_averageerror.csv');

%% Plot Errors
figure;
scatter(1:24, error12, 'ks');
hold on
scatter(1:24, error13, 'o');
hold on
scatter(1:24, error23, 'kx');
hold on
plot(1:24, averageerror);
title('Errors between Color Patches','fontsize',20)
xlabel('Patch No.')
ylabel('Color angle in Degrees')
% plot(tbl,["Temperature" "PressureHg"])
legend("Error 1, 2", "Error 1, 3", "Error 2, 3", "Average Error")

%% Average average Error


