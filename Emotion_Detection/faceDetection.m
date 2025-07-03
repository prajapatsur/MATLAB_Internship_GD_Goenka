% faceDetection.m
function faceDetection()
    faceDetector = vision.CascadeObjectDetector();
    cam = webcam();
    while true
        img = snapshot(cam);
        bbox = step(faceDetector, img);
        if ~isempty(bbox)
            img = insertObjectAnnotation(img, 'rectangle', bbox, 'Face');
        end
        imshow(img);
        drawnow;
    end
end
