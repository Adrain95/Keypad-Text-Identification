addpath('C:\VSG_IPA_toolbox')

clc;
clear all;

% Original Image.
A = imread('calculator.tif');

% Noise Removal.
Arr = ones(3);
Arr(5) = 3;
A = vsg('Convolution', A, Arr);
A = uint8(A);
figure(1), subplot(1,2,1), imshow(A); title("Original Image");

%% Opening By Reconstruction.
mask = A;
SE = strel('line', 80, 0);
SE = uint8(getnhood(SE));
marker = vsg('ErosionNxN', A, SE);
marker = uint8(marker);
B = imreconstruct(marker, mask);
figure(2), subplot(1,3,1), imshow(mask); title("Mask")
figure(2), subplot(1,3,2), imshow(marker); title("Marker")
figure(2), subplot(1,3,3), imshow(B); title("Reconstruction")

%% Opening By Reconstruction Top Hat - Difference.
C = vsg('Subtract', mask, B);
C = uint8(C);
figure(3), subplot(1,3,1), imshow(mask); title("A")
figure(3), subplot(1,3,2), imshow(B); title("Minus B")
figure(3), subplot(1,3,3), imshow(C); title("Equals C")

%% Opening By Reconsrtuction. (Twice)
mask1 = C;

% First Opening By Reconstruction.
SE1 = strel('line', 8, 45);
SE1 = uint8(getnhood(SE1));
marker1 = vsg('ErosionNxN', mask1, SE1);
marker1 = uint8(marker1);
D = imreconstruct(marker1, mask1);

% Second Opening By Reconstruction.
SE2 = strel('line', 8, 90);
SE2 = uint8(getnhood(SE2));
marker2 = vsg('ErosionNxN', D, SE2);
marker2 = uint8(marker2);
D1 = imreconstruct(marker2, D);

% Binary Conversion.
Ivalue = graythresh(D1) * 255;
E = vsg('Threshold', D1, Ivalue);
E = uint8(E);
figure(1), subplot(1,2,2), imshow(E); title("Output");
