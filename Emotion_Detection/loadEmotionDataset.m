% loadEmotionDataset.m
function [augTrain, augTest] = loadEmotionDataset()
    % Define the dataset directory
    datasetDir = 'FER2013';
    
    % Define image size
    imageSize = [48, 48];
    
    % Load training data
    trainFolder = fullfile(datasetDir, 'train');
    imdsTrain = imageDatastore(trainFolder, ...
        'IncludeSubfolders', true, ...
        'LabelSource', 'foldernames');
    
    % Load test data
    testFolder = fullfile(datasetDir, 'test');
    imdsTest = imageDatastore(testFolder, ...
        'IncludeSubfolders', true, ...
        'LabelSource', 'foldernames');
    
    % Resize images and convert to grayscale in preprocessing function
    imdsTrain.ReadFcn = @(filename) preprocessImage(filename, imageSize);
    imdsTest.ReadFcn = @(filename) preprocessImage(filename, imageSize);
    
    % Augment data
    augTrain = augmentedImageDatastore(imageSize, imdsTrain, 'ColorPreprocessing', 'none');
    augTest = augmentedImageDatastore(imageSize, imdsTest, 'ColorPreprocessing', 'none');
end

function imgOut = preprocessImage(filename, imageSize)
    img = imread(filename);
    img = imresize(img, imageSize);
    if size(img, 3) == 3
        img = rgb2gray(img); % Convert to grayscale if the image is RGB
    end
    imgOut = img;
end
