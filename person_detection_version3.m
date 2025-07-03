clc; clear; close all;

% Load and prepare image
img1 = imread('D:\MATLAB\Chair_detection\image (2).jpg');  % Your image
img= imcrop(img1);
imgGray = rgb2gray(img);
[imgH, imgW, ~] = size(img);

% Initialize face detector
faceDetector = vision.CascadeObjectDetector();

% Detect faces (bboxes: [x y width height])
bboxes = step(faceDetector, imgGray);
numFaces = size(bboxes, 1);
fprintf('Number of Faces detected: %d', numFaces);

% Draw rectangles and number faces
imgWithFaces = img;
for i = 1:numFaces
    % Draw rectangle and label
    imgWithFaces = insertObjectAnnotation(imgWithFaces, 'rectangle', ...
        bboxes(i,:), ['Face ' num2str(i)], 'TextBoxOpacity', 0.8, ...
        'FontSize', 14);
end

% Divide image into grid (e.g., 3 rows × 6 columns)
numRows = 3;
numCols = 6;
cellWidth = imgW / numCols;
cellHeight = imgH / numRows;

% Create occupancy matrix (rows × cols)
occupancy = zeros(numRows, numCols);

% Assign detected faces to grid cells
for i = 1:numFaces
    xCenter = bboxes(i,1) + bboxes(i,3)/2;
    yCenter = bboxes(i,2) + bboxes(i,4)/2;

    col = min(floor(xCenter / cellWidth) + 1, numCols);
    row = min(floor(yCenter / cellHeight) + 1, numRows);

    occupancy(row, col) = 1;  % Mark chair as present
end

% Draw the chair grid and show status (Present / Absent)
for r = 1:numRows
    for c = 1:numCols
        x = (c-1)*cellWidth;
        y = (r-1)*cellHeight;
        status = 'Absent';
        color = 'red';
        if occupancy(r, c) == 1
            status = 'Present';
            color = 'green';
        end
        imgWithFaces = insertShape(imgWithFaces, 'Rectangle', ...
            [x y cellWidth cellHeight], 'Color', color, 'LineWidth', 2);
        imgWithFaces = insertText(imgWithFaces, [x+5, y+5], ...
            sprintf('%s\n[%d,%d]', status, r, c), 'FontSize', 12, ...
            'BoxColor', color, 'TextColor', 'white');
    end
end

% Display final image
imshow(imgWithFaces);
title(['Total Faces Detected: ' num2str(numFaces)]);

% Console summary
fprintf('\n--- Chair Occupancy Matrix (Row x Column) ---\n');
for r = 1:numRows
    fprintf('Row [%d]: ',r)
    for c = 1:numCols
        fprintf(ternary(occupancy(r,c), '🪑Present, ', 'Absent, '));
    end
    fprintf("\n")
end

% Helper ternary function
function out = ternary(cond, a, b)
    if cond
        out = a;
    else
        out = b;
    end
end
