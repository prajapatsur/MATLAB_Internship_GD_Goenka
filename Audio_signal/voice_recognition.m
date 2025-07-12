% Load test audio
[x_test, fs] = audioread('D:\MATLAB\Audio_recognition\sample2\voiceSample.wav');
test_feat = mean(mfcc(x_test, fs));

% Load known speaker features
load('speaker1.mat', 'surendra');
load('speaker2.mat', 'anita_devi');

% Compare using Euclidean distance
d1 = norm(test_feat - surendra);
d2 = norm(test_feat - anita_devi)

% Decision
[~, id] = min([d1, d2]);
disp(['Identified speaker: Speaker ', num2str(id)]);
