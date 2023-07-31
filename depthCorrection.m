%% Image name and depth
load MacbethColorCheckerData.mat;
[num, text, raw] = xlsread('D:\Piet\Cruise\Data\Image_catalogue.xlsx');
originPath = 'D:\Piet\Cruise\Data\';
colorsReshaped = reshape(colors',24,[]); 
datasetTotalNo = find(num(:,5) ~= 0);
datasetsWithCC = unique(num(datasetTotalNo,1));
grayPatch = [0 0 0 0];
grayPatchmean = [0 0 0 0];
surfaceReference = load('D:\Piet\Cruise\Data\8\uncorrectedTiff\csvCamRGBdouble\8_03.csv');
surfaceReference = surfaceReference(21,:);


% figure;

for i = 1:numel(datasetsWithCC)
    currentSet = datasetsWithCC(i);
    csvPath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff', 'csvCamRGBdouble');
    savePath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff', 'csvCamRGBdoubleSurfce');
    imageTotalNo = unique(num(find(num(:,1) == currentSet),2));


    for j = 1:numel(imageTotalNo)
        currentImageNo = imageTotalNo(j,1);
        currentImagecsv = fullfile(csvPath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.csv']);
        k = find(num(:,1) == currentSet & num(:,2) == currentImageNo);
        depth = num(k,3);
        
        csvData = load(currentImagecsv);

        for v = 1:24
            csvDataNew(v,1) = csvData(v,1)/surfaceReference(1);
            csvDataNew(v,2) = csvData(v,2)/surfaceReference(2);
            csvDataNew(v,3) = csvData(v,3)/surfaceReference(3);

        end
        csvDataNew = csvDataNew * 0.362;

        writematrix(csvDataNew, fullfile(savePath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.csv']));
            

    end
end
    