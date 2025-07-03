% realTimeEmotionDetection.m
function realTimeEmotionDetection()
    % Load the trained model
    load('emotionNet.mat', 'net');

    % Initialize face detector and webcam
    faceDetector = vision.CascadeObjectDetector();
    cam = webcam();
    
    % Create a UI figure window
    fig = uifigure('Name', 'Real-Time Emotion Detection', 'Position', [100, 100, 800, 600]);
    ax = uiaxes(fig, 'Position', [50, 50, 700, 500]);
    
    % Create a loop to continuously capture frames from the webcam
    while isvalid(fig)
        img = snapshot(cam);
        bbox = step(faceDetector, img);
        if ~isempty(bbox)
            for i = 1:size(bbox, 1)
                face = imcrop(img, bbox(i, :));
                face = imresize(face, [48 48]);
                faceGray = rgb2gray(face);  % Convert to grayscale if necessary
                label = classify(net, faceGray);
                img = insertObjectAnnotation(img, 'rectangle', bbox(i, :), char(label));
                title(ax, ['Detected Emotion: ', char(label)]);
            end
        end
        imshow(img, 'Parent', ax);
        drawnow;
    end
end
