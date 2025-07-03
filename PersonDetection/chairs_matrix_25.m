clc;
clear;
close all;

% Step 1: Load the full 3x3 grid image
img = imread('D:\MATLAB\Chair_detection\3_3 chairs.jpeg.jpg');  % Use your image file
[H, W, ~] = size(img);

% Step 2: Define grid size
rows = 3;
cols = 3;
cellHeight = floor(H / rows);
cellWidth  = floor(W / cols);

% Step 3: Set detection threshold
threshold = 135;  % 🔧 High RGB means bright clothes (person present)

% Step 4: Prepare output and plot
figure;
imshow(img);
title('Chair Detection (Bright RGB → Person)');
hold on;

detection = strings(rows, cols);  % To store results

% Step 5: Loop through each chair block
for i = 1:rows
    for j = 1:cols
        % Get region coordinates
        y1 = (i-1)*cellHeight + 1;
        y2 = i*cellHeight;
        x1 = (j-1)*cellWidth + 1;
        x2 = j*cellWidth;

        % Crop region
        region = img(y1:y2, x1:x2, :);

        % Get average RGB
        R = region(:,:,1);
        G = region(:,:,2);
        B = region(:,:,3);
        avg_R= mean(R(:));
        avg_G= mean(G(:));
        avg_B= mean(B(:));
        avg_RGB = mean([mean(R(:)), mean(G(:)), mean(B(:))]);

        % Decide: High RGB means person present
        if avg_R > 150
            status = '👤 Person';
            color = 'g';  % Green box for person
        else
            status = '🪑 Empty';
            color = 'r';  % Red box for empty chair
        end

        % Save result
        detection(i,j) = status;

        fprintf('Chair (%d,%d): R=%.1f, G=%.1f, B=%.1f\n', ...
                i, j,avg_R ,avg_G,avg_B);

        % Draw box and label
        rectangle('Position', [x1, y1, cellWidth, cellHeight], ...
                  'EdgeColor', color, 'LineWidth', 2);
        text(x1+10, y1+20, status, 'Color', color, ...
             'FontSize', 11, 'FontWeight', 'bold');
    end
end

hold off;

% Step 6: Show detection matrix
disp("# Detection Result (High value of R → Person)");
disp(detection);

% also we count the numb. of persons are present
count = (sum(detection =="👤 Person"));
% disp(count);
 fprintf('count=%d\n',count);