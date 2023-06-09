
% June 8, 2023
% Underwater Colorimetry Course @ IUI Eilat

% Basic Colorimetry and Image formation exercises

% Simulation Exercises

%% Exercise 1 - Simulate a Macbeth ColorChecker

% Download the data needed from the github repo
% https://github.com/COLOR-Lab-Eilat/Underwater-colorimetry

% Use the function importdata to read the csv files. The importdata function will create a struct with fields data, textdata,
% rowheaders. 

% Load the reflectances - The data will be 25 x 81, where 1st row is wavelength, and
% rows 2-25 are the patches of the color checker.
refl = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\MacbethColorCheckerReflectances.csv');
% Inspect the data — pay attention that the wavelength range is 380:5:780.
% This commend will print out the wavelength range:
refl.data(1,:)



%% Load the relevant camera's curves
% Don't forget to also load the second camera!
cam = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\Nikon_D90.csv');
% Again, inspect the wavelength ranges, this dataset is 400:10:700. This commend will print out the wavelength range:
cam.data(:,1)

%% Load the light data
% Don't forget to also load the second illuminant
light = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\illuminant-D65.csv');
% Inspect the wavelength ranges. This dataset is 300:5:830 nm.
light.data(:,1)

%% Now we saw that the three ingredients we needed to calculate radiance have different wavelength ranges. 
% This is quite common. We will have to interpolate to a common range of 400:10:700 (corresponding to the camera, as that appears to be the coarsest) as follows:

WL = 400:10:700;
refl_spectra = (interp1(refl.data(1,:)',refl.data(2:end,:)',WL))';
% Interpolate values for light
light_spectra = interp1(light.data(:,1),light.data(:,2),WL);

%% Calculate radiance for the ColorChecker for a given illuminant and a given camera

rgb = getradiance(refl_spectra, light_spectra, cam.data(:,2:end));

% Visualize the resulting colors
mcc = visualizeColorChecker(mat2gray(rgb));
figure;imshow(mcc)
% This line saves the figure
exportgraphics(gcf,'Macbeth_no_wb.png')

% Select an achromatic patch with which to white balance.
% Let's pick the 23rd gray, with 9% reflectance but experiment with
% different patches!
wbpatch = rgb(23,:); 

% perform simple white balancing 
rgb_wb = 0.09*rgb./repmat(wbpatch,[size(rgb,1),1]);

% Visualize the resulting colors
mcc_wb = visualizeColorChecker(rgb_wb);

% Display and save the resulting image
figure;imshow(mcc_wb)
% This line saves the figure
exportgraphics(gcf,'Macbeth_wb.png')


%% Exercise 2 -  Calculate the XYZ and xy values of the Macbeth ColorChecker and plot on the chromaticity diagram
% XYZ and xy require us to use the standard observer curves.
close all
reflectance = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\MacbethColorCheckerReflectances.csv');
camera1 = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\Nikon_D90.csv')
camera2 = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\Canon_1Ds-Mk-II.csv');


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

% Load standard observer curves
stdobs = importdata('C:\Users\PIET\Documents\GitHub\Underwater-colorimetry\CIEStandardObserver.csv');

% interpolate the wl to the same range
stdobs_spectra = interp1(stdobs(:,1),stdobs(:,2:4),WL);

% We can use the same radiance function to calculate XYZ values
XYZA = getradiance(refl_spectra, illuminantAInt, stdobs_spectra);
XYZD65 = getradiance(refl_spectra, illuminantD65Int, stdobs_spectra);

% Now obtain xy from XYZ
xyA = XYZA./sum(XYZA,2);
xyD65 = XYZD65./sum(XYZD65,2);

% Plot on the chromaticity diagram
plotChromaticity
hold on
% Here I used black squares for each patch, but if you are feeling
% ambitious, you can color them by the patch's own color
plot(xyA(:,1),xyA(:,2),'ks','markersize',10,'linewidth',3) 
set(gca,'fontsize',30)
set(gca,'xlim',[0 1])
set(gca,'ylim',[0 1])
hold on

plot(xyD65(:,1),xyD65(:,2),'o','markersize',10,'linewidth',3) 
set(gca,'fontsize',30)
set(gca,'xlim',[0 1])
set(gca,'ylim',[0 1])


% You can save using exportgraphics again

%% Exercise 3: White point xy of an illuminant

% In this case we assume the reflectance is a perfect white
XYZ_D65wp = getradiance(ones(1,numel(WL)), illuminantD65Int, stdobs_spectra);
XYZ_Awp = getradiance(ones(1,numel(WL)), illuminantAInt, stdobs_spectra);

xy_Awp = XYZ_Awp./sum(XYZ_Awp,2);
xy_D65wp = XYZ_D65wp./sum(XYZ_D65wp,2);

% We are plotting this on top of the previous chromaticity diagram we drew
hold on
plot(xy_Awp(:,1),xy_Awp(:,2),'kx','markersize',30,'linewidth',3,'Color','b')
hold on
plot(xy_D65wp(:,1),xy_D65wp(:,2),'kx','markersize',30,'linewidth',3,'Color', 'Green')
title('Std observer')
%% Exercise 4: Camera RGB to XYZ transformation

% Recall that we also want the XYZ to be white balanced.
XYZ_wb = XYZD65./XYZ_D65wp;

% Derive a 3x3 transform from white balanced camera RGB to white balanced
% XYZ
T1 = XYZ_wb' * pinv(rgb_wb1)';
xyz_image1 = (T1*rgb_wb1')';

T2 = XYZ_wb' * pinv(rgb_wb2)';
xyz_image2 = (T2*rgb_wb2')';

% T3 = XYZ_wb' * pinv(rgb_wb3)';
% xyz_image3 = (T3*rgb_wb3)';

T4 = XYZ_wb' * pinv(rgb_wb4)';
xyz_image4 = (T4*rgb_wb4')';


% Plot them on the chromaticity diagram 
plotChromaticity
hold on
plot(xyz_image1(:,1),xyz_image1(:,2),'o','linewidth',3)
%(remember to overlay the other camera too)

% Obtain the xy coordinates
xy_image2 = xyz_image2./sum(xyz_image2,2);
plot(xy_image2(:,1),xy_image2(:,2),'kx','linewidth',3)
title('WB Comp')
%% Exercise 5 XYZ to standard RGB transformation

% There are standard matrices for this transformation
% See here --> http://www.brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html
% Remember that if XYZ values are already white balanced, there's no need to do a CAT.

sRGB = xyz2rgb(XYZ_wb);
imshow(visualizeColorChecker(sRGB))

sRGB = xyz2rgb(XYZ_wb);
imshow(visualizeColorChecker(sRGB))

sRGB = xyz2rgb(XYZ_wb);
imshow(visualizeColorChecker(sRGB))

sRGB = xyz2rgb(XYZ_wb);
imshow(visualizeColorChecker(sRGB))





