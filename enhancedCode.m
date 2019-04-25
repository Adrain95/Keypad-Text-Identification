%% -- Setting Up Input Image.
addpath('C:\VSG_IPA_toolbox')

clc;
clear all;

% Original Image.
A = imread('calculator.tif');
% A = imread('ImageA1.jpg');
% A = imread('ImageB1.PNG');
% A = imread('ImageC1.PNG');
% A = imread('ImageD1.PNG');
figure(1), subplot(1,2,1), imshow(A); title("Input Image");
HA = vsg('GetHeight',A);
WA = vsg('GetWidth', A);

% Resize Image.
A = imresize(A,[800 800]);

% GreyScale.
A = vsg('GreyScaler', A);
A = uint8(A);

% Noise.
Arr = ones(3)/9;
A = vsg('Convolution', A, Arr);
A = uint8(A);

%% -- Stage 1 Reconstruction -- Uniformal Background -- Button Faces.
mask = A;
SE = strel('line', 50, 0);
SE = uint8(getnhood(SE));

marker = vsg('ErosionNxN', mask, SE);
marker = uint8(marker);
RA = imreconstruct(marker, mask);

C = vsg('Subtract', A, RA);
C = uint8(C);

figure(2), subplot(2,2,1), imshow(mask); title("Mask");
figure(2), subplot(2,2,2), imshow(marker); title("Marker");
figure(2), subplot(2,2,3), imshow(RA); title("Reconstruction");
figure(2), subplot(2,2,4), imshow(C); title("Image C");

%% -- Edge Detector - Dilation - Subtraction - Removal Of Reflections.
EdgeRA = vsg('Sobel', RA);
EdgeRA = uint8(EdgeRA);

SE0 = ones(3, 7);

DEdgeRA = vsg('DilationNxN',EdgeRA, SE0);
DEdgeRA = uint8(DEdgeRA);

RAE = vsg('Subtract', C, DEdgeRA);
RAE = uint8(RAE);
RAE1 = imreconstruct(RAE, C);

figure(3), subplot(2,2,1), imshow(EdgeRA); title("RA - Egde Detector");
figure(3), subplot(2,2,2), imshow(DEdgeRA); title("RA - Dilated Edge");
figure(3), subplot(2,2,3), imshow(RAE); title("Reconstruct - Dialated Edge");
figure(3), subplot(2,2,4), imshow(RAE1); title("Reconstruct Of Previous Image");

%% Opening by Reconstruction - Removal Of Reflections.
SE = strel('square', 3);
SE = uint8(getnhood(SE));

mask1 = RAE1;
marker1 = vsg('ErosionNxN', mask1, SE);
marker1 = uint8(marker1);

D = imreconstruct(marker1, mask1);
BA = vsg('Threshold', D, (graythresh(D) * 255));
BA = uint8(BA);

% Resize Image.
Anew = imresize(BA,[HA WA]);

figure(4), subplot(2,2,1), imshow(mask1); title("Image A");
figure(4), subplot(2,2,2), imshow(D); title("Image RA");
figure(4), subplot(2,2,3), imshow(BA); title("Image BA");
figure(4), subplot(2,2,4), imshow(Anew); title("Output A");
figure(1), subplot(1,2,2), imshow(Anew); title("Output Image");
