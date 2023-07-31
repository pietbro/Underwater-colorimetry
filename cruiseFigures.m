%% Masking
load MacbethColorCheckerData.mat;
im = imread('D:\Piet\Cruise\Data\9\uncorrectedTiff\9_01_ref.tif');
% masks = makeChartMask(im, chart, colors);
% save('masks_dataset_9.mat', "masks");


%% Batch processing color space
folderPath = 'D:\Piet\Cruise\Data\7\uncorrectedTiff\';

imageFiles = dir(fullfile(folderPath, '*.tif'));
load('masks_dataset_7.mat');

for i = 1:numel(imageFiles)
    
    imagePath = fullfile(folderPath, imageFiles(i).name);

    Ilinearized = im2double(imread(imagePath));
    [folder, baseFileNameNoExt, extension] = fileparts(imagePath);
%     s = size(Ilinearized);
%     whitePatch = [4 1];
%     darkPatch = [4 6];
%     Iwhitebalanced = whiteBalance(Ilinearized,masks.(colors{whitePatch(1),whitePatch(2)}).mask,masks.(colors{darkPatch(1),darkPatch(2)}).mask,0.8);
% 
%     RGB = getChartRGBvalues(Iwhitebalanced,masks,colors);
%     XYZ = getChartXYZvalues(chart,colors);
%     T = XYZ' * pinv(RGB)';
% 
%     Ixyz = reshape((T*reshape(Iwhitebalanced,[s(1)*s(2) 3])')',[s(1) s(2) 3]);
%     Ixyz(Ixyz < 0) = 0; % Check for negative values
% 
%     XYZvalues = getChartRGBvalues(Ixyz, masks, colors);
% 
%     xy = XYZvalues./sum(XYZvalues,2);
% 
%     IPPrgb = XYZ2ProPhoto(Ixyz);
    RGB = getChartRGBvalues(Ilinearized,masks,colors);

%     imwrite(IPPrgb,fullfile(folderPath,"whiteBalancedPPrgb", imageFiles(i).name), 'tif');

%     I1PPrgb = XYZ2ProPhoto(Ixyz);

%     writematrix(XYZvalues, fullfile(folderPath,"csvXYZ", [baseFileNameNoExt, '.csv']));

    writematrix(RGB,fullfile(folderPath,"csvCamRGBdouble", [baseFileNameNoExt, '.csv']));


end

%% get ProPhotoRGB
folderPath = fullfile('D:\Piet\Cruise\Data\8\uncorrectedTiff\whiteBalancedPPrgb');

imageFiles = dir(fullfile(folderPath, '*.tif'));
load('masks_dataset_8.mat');

for i = 1:numel(imageFiles)
    imagePath = fullfile(folderPath, imageFiles(i).name);

    IProP = imread(imagePath);
    [folder, baseFileNameNoExt, extension] = fileparts(imagePath);
    s = size(IProP);

    ProPRGB = getChartRGBvalues(IProP,masks,colors);
    writematrix(ProPRGB,fullfile(folderPath,"csvPPRGB", [baseFileNameNoExt, '.csv']));

end

folderPath = fullfile('D:\Piet\Cruise\Data\7\uncorrectedTiff\whiteBalancedPPrgb');

imageFiles = dir(fullfile(folderPath, '*.tif'));
load('masks_dataset_7.mat');

for i = 1:numel(imageFiles)
    imagePath = fullfile(folderPath, imageFiles(i).name);

    IProP = imread(imagePath);
    [folder, baseFileNameNoExt, extension] = fileparts(imagePath);
    s = size(IProP);

    ProPRGB = getChartRGBvalues(IProP,masks,colors);
    writematrix(ProPRGB,fullfile(folderPath,"csvPPRGB", [baseFileNameNoExt, '.csv']));

end

folderPath = fullfile('D:\Piet\Cruise\Data\6\uncorrectedTiff\whiteBalancedPPrgb');

imageFiles = dir(fullfile(folderPath, '*.tif'));
load('masks_dataset_6.mat');

for i = 1:numel(imageFiles)
    imagePath = fullfile(folderPath, imageFiles(i).name);

    IProP = imread(imagePath);
    [folder, baseFileNameNoExt, extension] = fileparts(imagePath);
    s = size(IProP);

    ProPRGB = getChartRGBvalues(IProP,masks,colors);
    writematrix(ProPRGB,fullfile(folderPath,"csvPPRGB", [baseFileNameNoExt, '.csv']));

end

%% get figures XYZ

folderPathcsv = 'D:\Piet\Cruise\Data\7\uncorrectedTiff\csvXYZ';
csvFiles = dir(fullfile(folderPathcsv, '*.csv'));
colorsReshaped = reshape(colors',[24,1]);
figure;

for i = 1:numel(csvFiles)
    csvPath = fullfile(folderPathcsv, csvFiles(i).name);
    csvData = load(csvPath);


    
    for j = 1:24
    subplot(4, 6, j);

    scatter(i, csvData(j,1), 'rx');
    hold on
    scatter(i, csvData(j,2), 'gx');
    hold on
    scatter(i, csvData(j,3), 'bx');
    

    
    xlabel('Image No.')
    ylabel('XYZ Color Value')
    title(colorsReshaped(j))
    
    end
end

hold off
linkaxes
% title('Scattering XYZ Values per Patch','fontsize',20)

%% get figures RGB
folderPathcsv = 'D:\Piet\Cruise\Data\7\uncorrectedTiff\csvCamRGB';
csvFiles = dir(fullfile(folderPathcsv, '*.csv'));
colorsReshaped = reshape(colors',24,[]); 
figure;

for i = 1:numel(csvFiles)
    csvPath = fullfile(folderPathcsv, csvFiles(i).name);
    csvData = load(csvPath);

    
    for j = 1:24
    subplot(4, 6, j);

    scatter(i, csvData(j,1), 'rx');
    hold on
    scatter(i, csvData(j,2), 'gx');
    hold on
    scatter(i, csvData(j,3), 'bx');
    

    
    xlabel('Image No.')
    ylabel('RGB Color Value')
    title(colorsReshaped(j))
    
    end
    
end

hold off
linkaxes
% title('Scattering XYZ Values per Patch','fontsize',20)

%% Image name and depth
load MacbethColorCheckerData.mat;
[num, text, raw] = xlsread('D:\Piet\Cruise\Data\Image_catalogue.xlsx');
originPath = 'D:\Piet\Cruise\Data\';
colorsReshaped = reshape(colors',24,[]); 
datasetTotalNo = find(num(:,5) ~= 0);
datasetsWithCC = unique(num(datasetTotalNo,1));
grayPatch = [0 0];

figure;

for i = 1:numel(datasetsWithCC)
    currentSet = datasetsWithCC(i);
    csvPath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff', 'csvCamRGBdoubleSurfce');
    imageTotalNo = unique(num(find(num(:,1) == currentSet),2));


    for j = 1:numel(imageTotalNo)
        currentImageNo = imageTotalNo(j,1);
        currentImagecsv = fullfile(csvPath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.csv']);
        k = find(num(:,1) == currentSet & num(:,2) == currentImageNo);
        depth = num(k,3);
        
        csvData = load(currentImagecsv);

%         disp(csvData(24,1));
%         disp(depth);
% 
%         grayPatch(end+1, 1) = csvData(22,1);
%         grayPatch(end, 2) = csvData(22,2);
%         grayPatch(end, 3) = csvData(22,3);
%         grayPatch(end, 4) = depth;



  
        for v = 1:24
        subplot(4, 6, v);

        scatter(depth, csvData(v,1), 'rx');
        hold on
        scatter(depth, csvData(v,2), 'gx');
        hold on
        scatter(depth, csvData(v,3), 'bx');
    
        set(gca,'Ylim', [0 1]);
        set(gca,'Xlim', [0 15]);

        xlabel('Depth')
        ylabel('RAW RGB Color Value')
        title(colorsReshaped(v))
   
        end
    end
% % linkaxes

end



%% plot black
figure;
scatter(blackPatch(:,1), blackPatch(:,2));
set(gca,'Ylim', [0 255]);
set(gca,'Xlim', [0 15]);


%% get all figures PP RGB


dataPath = 'D:\Piet\Cruise\Data\';
csvFiles = dir(fullfile(dataPath, '*.csv'));
colorsReshaped = reshape(colors',24,[]); 
figure;

for i = 1:numel(csvFiles)
    csvPath = fullfile(folderPathcsv, csvFiles(i).name);
    csvData = load(csvPath);



    
    for j = 1:24
    subplot(4, 6, j);

    scatter(i, csvData(j,1), 'rx');
    hold on
    scatter(i, csvData(j,2), 'gx');
    hold on
    scatter(i, csvData(j,3), 'bx');
    

    
    xlabel('Image No.')
    ylabel('PP RGB Color Value')
    title(colorsReshaped(j))
    
    end
end

hold off
linkaxes
% title('Scattering XYZ Values per Patch','fontsize',20)