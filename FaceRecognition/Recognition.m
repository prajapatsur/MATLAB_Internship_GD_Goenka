
clc;
clear all;

load('trainedFaceNet2.mat');  

img = imread('D:\MATLAB\Chair_face_recognition\images\test_image2.jpg');
img = imcrop(img); 
imgGray = rgb2gray(img);
[imgH, imgW, ~] = size(img);

% Detect faces
faceDetector = vision.CascadeObjectDetector();
bboxes = step(faceDetector, imgGray);
numFaces = size(bboxes, 1);
fprintf('Number of Faces detected: %d\n', numFaces);

numRows = 3;  % number of rows
numCols = 3;  % number of columns
prob_threshold = 0.50;

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
    conf = max(prob);

    occupancy(row, col) = 1;

    % Recognition threshold logic
    if conf >= prob_threshold
        name = char(label);
        statusMatrix{row, col} = sprintf('%s(%.2f)', name, conf);
        annotationText = name;
    else
        statusMatrix{row, col} = 'Unknown';
        annotationText = 'Unknown';
    end

    % Annotate face
    imgWithFaces = insertObjectAnnotation(imgWithFaces, 'rectangle', ...
        bboxes(i,:), annotationText, 'TextBoxOpacity', 0.8, 'FontSize', 10);
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
            'FontSize', 22, 'BoxColor', color, 'TextColor', 'white');
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

