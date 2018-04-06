clc
close all;
clear all;

I= imread('');
I_gray= rgb2gray('I');

%Thresholding
I2= thresholding(I_gray);

connected_components=bwconncomp(I2,8);
no_CC=connected_components.numObjects

Area = zeros (n,1);
perimeter = zeros(n,1);
majorAxis= zeros(n,1);
minorAxis=zeros(n,1);
k= regionprops (connected_components,'Area','perimeter','MajorAxisLength', 'MinorAxisLength')
for i=1:n
	Area(i) = k(i).Area
	perimeter(i)= k(i).perimeter
	minorAxis(i)=k(i).minorAxisLength
	majorAxis(i)=k(i).majorAxisLength
end
graindata(1,1)=mean(Area);
graindata(2,1)=mean(perimeter);
graindata(3,1)=mean(majorAxis);
graindata(4,1)=mean(minorAxis);



imshow(I_gray);
