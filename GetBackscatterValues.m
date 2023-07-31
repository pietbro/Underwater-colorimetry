%% remove backscatter
load MacbethColorCheckerData.mat;
[num, text, raw] = xlsread('D:\Piet\Cruise\Data\Image_catalogue.xlsx');
originPath = 'D:\Piet\Cruise\Data\';
colorsReshaped = reshape(colors',24,[]); 
datasetTotalNo = find(num(:,5) ~= 0);
datasetsWithCC = unique(num(datasetTotalNo,1));
blackPatch = [0 0];


for i = 1 %1:numel(datasetsWithCC)
    currentSet = datasetsWithCC(i);
    csvPath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff', 'csvCamRGBdoubleSurface');
    imagePath = fullfile(originPath, num2str(currentSet),'uncorrectedTiff');
    imageTotalNo = unique(num(find(num(:,1) == currentSet),2));
    


    for j = 1:numel(imageTotalNo)
        currentImageNo = imageTotalNo(j,1);
        currentImagecsv = fullfile(csvPath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.csv']);
        currentImage = fullfile(csvPath, [num2str(currentSet),'_',pad(num2str(j),2,'left', '0'),'.tif']);


        k = find(num(:,1) == currentSet & num(:,2) == currentImageNo);
        depth = num(k,3);
        
        csvData = load(currentImagecsv);

%         disp(csvData(24,1));
%         disp(depth);

%         blackPatch(end+1 ,1) = csvData(24,1);
%         blackPatch(end,2) = depth;
        
           
  
        for v = 1:6
            w = v + 18;
            
%         subplot(4, 6, v);
% 
%         scatter(depth, csvData(v,1), 'rx');
%         hold on
%         scatter(depth, csvData(v,2), 'gx');
%         hold on
%         scatter(depth, csvData(v,3), 'bx');
%     
%         set(gca,'Ylim', [0 255]);
%         set(gca,'Xlim', [0 15]);

%         xlabel('Depth')
%         ylabel('PP RGB Color Value')
%         title(colorsReshaped(v))
          greyPatches(v,1) = csvData(w,1);
          greyPatches(v,2) = csvData(w,2);
          greyPatches(v,3) = csvData(w,3);
   
        end
        y_intercepts = getIntercepts(greyPatches);
        num(k,6) = y_intercepts(1);
        num(k,7) = y_intercepts(2);
        num(k,8) = y_intercepts(3);

    end


end