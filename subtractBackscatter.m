load MacbethColorCheckerData.mat;
%[num, text, raw] = xlsread('D:\Piet\Cruise\Data\Image_catalogue.xlsx');
num = readmatrix('D:\Piet\Cruise\Data\backscatter_CamRGBdouble.csv');
originPath = 'D:\Piet\Cruise\Data\';
colorsReshaped = reshape(colors',24,[]); 
datasetTotalNo = find(num(:,5) ~= 0);
datasetsWithCC = unique(num(datasetTotalNo,1));
blackPatch = [0 0];


for i = 4%1:numel(datasetsWithCC)
    currentSet = datasetsWithCC(i);
    csvPath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff', 'csvCamRGBdoubleSurfce');
    imagePath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff');
    imageTotalNo = unique(num(find(num(:,1) == currentSet),2));
    


    for j = 30 %1:numel(imageTotalNo)
        currentImageNo = imageTotalNo(j,1);
        currentImagecsv = fullfile(csvPath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.csv']);
        currentImage = fullfile(imagePath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.tif']);


        k = find(num(:,1) == currentSet & num(:,2) == currentImageNo);
        depth = num(k,3);
        backscatter = num(k,6:8);
        
        csvData = load(currentImagecsv);

        I = im2double(imread(currentImage));

        backscatterFitR = fit([0 0.23]',[0 backscatter(1)]','poly1');
        backscatterFitG = fit([0 0.23]',[0 backscatter(2)]','poly1');
        backscatterFitB = fit([0 0.23]',[0 backscatter(3)]','poly1');

        Bc(1) = feval(backscatterFitR, 2);
        Bc(2) = feval(backscatterFitG, 2);
        Bc(3) = feval(backscatterFitB, 2);

        Dc = I-reshape(backscatter,[1 1 3]);


        imshowpair(I,Dc, "montage");
    end
end

