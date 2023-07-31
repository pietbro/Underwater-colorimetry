%% Image name and depth
load MacbethColorCheckerData.mat;
[num, text, raw] = xlsread('D:\Piet\Cruise\Data\Image_catalogue.xlsx');
originPath = 'D:\Piet\Cruise\Data\';
colorsReshaped = reshape(colors',24,[]); 
datasetTotalNo = find(num(:,5) ~= 0);
datasetsWithCC = unique(num(datasetTotalNo,1));
grayPatch21_R = [];
grayPatch21_G = [];
grayPatch21_B = [];
grayPatch21_D = [];
% surfaceReference = load('D:\Piet\Cruise\Data\8\uncorrectedTiff\csvCamRGBdouble\8_03.csv')
%surfaceReference = surfaceReference(:,22);


% figure;

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

        grayPatch21_R(end+1, 1) = csvData(21,1);
        grayPatch21_G(end+1, 1) = csvData(21,2);
        grayPatch21_B(end+1, 1) = csvData(21,3);
        grayPatch21_D(end+1, 1) = depth;

        
    end
end

% depthMeasurements = unique(grayPatch(:,4));
% 
%     for v = 1:numel(depthMeasurements)
%         uniqueDepths = find(grayPatch(:,4) == depthMeasurements(v));
%         meanR = mean(grayPatch(uniqueDepths,1));
%         meanG = mean(grayPatch(uniqueDepths,2));
%         meanB = mean(grayPatch(uniqueDepths,3));
% 
%         grayPatchmean(end+1, 1) = meanR;
%         grayPatchmean(end, 2) = meanG;
%         grayPatchmean(end, 3) = meanB;
%         grayPatchmean(end, 4) = depthMeasurements(v);
%     end
% 
% figure;
% 
% scatter(grayPatchmean(:,4), grayPatchmean(:,1),  'xr');
% hold on
% scatter(grayPatchmean(:,4), grayPatchmean(:,2), 'xg');
% hold on
% scatter(grayPatchmean(:,4), grayPatchmean(:,3), 'xb');
% 
% 
% grayPatch21_R = grayPatch21_R(2-end,:);
% grayPatch21_G = grayPatch21_G(2-end,:);
% grayPatch21_B = grayPatch21_B(2-end,:);
% grayPatch21_D = grayPatch21_D(2-end,:);