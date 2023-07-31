
dngPath = ['D:\Piet\Cruise\Data\10\dng']; %change to your path 
tiffSavePath = ['D:\Piet\Cruise\Data\10\uncorrectedTiff'];%change to your path
CompresedPngPath = ['D:\Piet\Cruise\Data\10\Cpng'];
stage = 4;
cd('D:\Piet\Repositories\Underwater-colorimetry\camera-pipeline-nonUI-master')%change to your path
% dng2tiff(dngPath, tiffSavePath, stage);
tiff2png(CompresedPngPath, tiffSavePath)
