clc;

% Fs	Sampling Frequency (Hz)	
% nBits	Number of Bits per Sample	
% nChannels	Mono or Stereo (1 or 2)	
% duration	Recording length in seconds	
% audioData	Signal values (amplitude of each sample)	[Nx1] vector

Fs = 16000;
nBits = 8;
nChannels = 1;
duration = 10;

recObj = audiorecorder(Fs, nBits, nChannels);

disp('Start speaking...');
recordblocking(recObj, duration);
disp('Recording done.');

audioData = getaudiodata(recObj);
audiowrite('voiceSample2.wav', audioData, Fs);

t = linspace(0, duration, length(audioData));
plot(t, audioData);
xlabel('Time (s)');
ylabel('Amplitude');
title('Voice Sample Waveform');
