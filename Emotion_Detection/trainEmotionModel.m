% trainEmotionModel.m
function net = trainEmotionModel()
    % Load and preprocess dataset
    [augTrain, augTest] = loadEmotionDataset();

    % Define the CNN architecture
    layers = [
        imageInputLayer([48 48 1]) % Grayscale images
        convolution2dLayer(3,8,'Padding','same')
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2,'Stride',2)
        convolution2dLayer(3,16,'Padding','same')
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2,'Stride',2)
        fullyConnectedLayer(64)
        dropoutLayer(0.5)
        fullyConnectedLayer(7)  % Number of classes
        softmaxLayer
        classificationLayer];

    % Set training options
    options = trainingOptions('adam', ...
        'MaxEpochs', 10, ...
        'MiniBatchSize', 64, ...
        'Shuffle', 'every-epoch', ...
        'ValidationData', augTest, ...
        'ValidationFrequency', 30, ...
        'Verbose', false, ...
        'Plots', 'training-progress');

    % Train the network
    net = trainNetwork(augTrain, layers, options);

    % Save the trained model
    save('emotionNet.mat', 'net');
end
