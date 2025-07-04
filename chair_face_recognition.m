% ======== chair_face_recognition.m ========
clc; clear; close all;

load('trainedFaceNet2.mat');  % Load your trained GoogLeNet

% Load image
img = imread('D:\MATLAB\Chair_face_recognition\images\class_image.jpg');
img = imcrop(img);  % Optional: crop only if needed
imgGray = rgb2gray(img);
[imgH, imgW, ~] = size(img);

% Detect faces
faceDetector = vision.CascadeObjectDetector();
bboxes = step(faceDetector, imgGray);
numFaces = size(bboxes, 1);
fprintf('Number of Faces detected: %d\n', numFaces);

% Grid configuration
numRows = 3;
numCols = 3;
cellWidth = imgW / numCols;
cellHeight = imgH / numRows;

occupancy = zeros(numRows, numCols);
statusMatrix = cell(numRows, numCols);
imgWithFaces = img;

% Recognize faces and assign to grid
for i = 1:numFaces
    xCenter = bboxes(i,1) + bboxes(i,3)/2;
    yCenter = bboxes(i,2) + bboxes(i,4)/2;

    col = min(floor(xCenter / cellWidth) + 1, numCols);
    row = min(floor(yCenter / cellHeight) + 1, numRows);

    faceImg = imcrop(img, bboxes(i,:));
    faceImg = imresize(faceImg, [224 224]);
    
    [label, prob] = classify(net2, faceImg);
    name = char(label);
    conf = max(prob);
    
    statusMatrix{row, col} = sprintf('%s(%.2f)', name, conf);
    occupancy(row, col) = 1;

    % Annotate face
    imgWithFaces = insertObjectAnnotation(imgWithFaces, 'rectangle', ...
        bboxes(i,:), name, 'TextBoxOpacity', 0.8, 'FontSize', 14);
end

% Draw grid with results
for r = 1:numRows
    for c = 1:numCols
        x = (c-1)*cellWidth;
        y = (r-1)*cellHeight;
        if occupancy(r, c) == 1 && ~isempty(statusMatrix{r, c})
            label = ['🪑' statusMatrix{r, c}];
            color = 'green';
        else
            label = 'Absent';
            color = 'red';
        end
        imgWithFaces = insertShape(imgWithFaces, 'Rectangle', ...
            [x y cellWidth cellHeight], 'Color', color, 'LineWidth', 2);
        imgWithFaces = insertText(imgWithFaces, [x+5, y+5], label, ...
            'FontSize', 12, 'BoxColor', color, 'TextColor', 'white');
    end
end

% Display result
figure; imshow(imgWithFaces);
title(['Total Faces Detected: ' num2str(numFaces)]);

% Console Output
fprintf('\n--- Chair Recognition Matrix (Row x Column) ---\n');
for r = 1:numRows
    fprintf('Row [%d]: ', r);
    for c = 1:numCols
        if occupancy(r, c) == 1 && ~isempty(statusMatrix{r, c})
            fprintf('🪑%s, ', statusMatrix{r, c});
        else
            fprintf('Absent, ');
        end
    end
    fprintf('\n');
end
