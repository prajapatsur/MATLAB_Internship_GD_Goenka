% Using this code I am giving a refernce of empty chair and then cropping
% two chairs. Then compare both chairs with the reference empty chair, if
% their differnce of mean pixels (gray-scale) croses the threshold then
% the chair is filled otherwise its empty chair. 

clear;
r_label = "None";
l_label = "None";
threshold_for_comparison = 30;

img = imread('task_image1.jpg');
empty_chair = imread('empty_chair.jpg');
imshow(img);

gray_empty_chair = rgb2gray(empty_chair);
mean_empty_chair = mean2(gray_empty_chair);

disp('Crop the LEFT chair region');
leftChair = imcrop(img);  % Select using mouse

disp('Crop the RIGHT chair region');
rightChair = imcrop(img); % Select second region

% converitng into gray images
grayLeft = rgb2gray(leftChair);
grayRight = rgb2gray(rightChair);

meanLeftGray = mean2(grayLeft);
meanRightGray = mean2(grayRight);

fprintf('\n📌 Left chair:   [%.2f %.2f %.2f]\n', mean(reshape(leftChair, [], 3)));
fprintf('📌 Right chair: [%.2f %.2f %.2f]\n', mean(reshape(rightChair, [], 3)));

difference1 = abs(meanLeftGray - mean_empty_chair);
difference2 = abs(meanRightGray - mean_empty_chair);

if difference1>threshold_for_comparison
    l_label = "filled"
    if difference2>threshold_for_comparison
        r_label = "filled";
    else
        r_label = "empty";
    end
else
    l_label = "empty";
    if difference2>threshold_for_comparison
        r_label = "filled";
    else
        r_label = "empty";
    end
end
        
    

subplot(2,2,1), imshow(leftChair), title(l_label);
subplot(2,2,2), imshow(rightChair), title(r_label);
subplot(2,2,3), imshow(empty_chair), title('Empty Reference chair');