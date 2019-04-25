# Keypad-Text-Identification

Matlab Program

Introduction.

The primary focus of this project is to develop a computer vision program that is capable of isolating alpha numerical characters from a specified image which displays a keypad of a calculator (calculator.tif). This program will be based in Matlab and will be using operations from both Matlab and additionally the VSG toolbox. The prime objective of this program will be carried out by means of morphological reconstruction techniques, i.e. by use of operations such as ‘dilation’, ‘erosion’, ‘opening’, ‘closing’ and ‘tophat’ as well as other functions. 

The overall developed solution must hold several key attributes, one such attribute is robustness, this means the program must can process a wide range of images correctly, even if there is a variance of background noise within the image or if the image is scaled to a different proportion. The program must be fully automated, so that there is minimal to no user interaction within the program during processing.  Furthermore, all parameters within the program must be data driven, in other words values should be based off image data as opposed to being user defined. In total, the developed solution should be computationally efficient in isolating alpha numerical characters within an image. 

Rational.
As previously stated, the main objective of this computer vision program is to isolate all alpha numerical characters present in a specified image which displays a calculator keypad. This would be a complex task for any program to undertake, therefore a large amount of research, reasoning and logical thinking is required to determine which methods should be used within the program.

A logical assumption to have for the beginning of the program, is to apply some form of erosion on the image as erosion is a process that reduces the size of objects within an image. The extent of shrinkage depends on the structuring element [SE] being applied during erosion. As this process will shrink all objects and in some cases, remove objects completely that cannot contain the SE within them. This process is effective however it has a large impact on all objects both text and reflections within the image. Therefore, a restoring technique would be required after erosion so that all remaining objects can be restored to their original state. 

Morphological opening was first investigated as it was the simplest approach in theory, this involved dilation with a similar SE after erosion was performed. This process expanded objects in the image based on the SE, however as the objects within the image had complex shapes, it was rather difficult to restore the objects to their previous form.

A better method to use was Opening by Reconstruction, this involved the input image being eroded resulting in the removal of small objects. This was then followed by reconstruction by dilation between the eroded image [marker] and the input image [mask]. This allows all remaining objects within the image to be restored to their original state. 

For Opening by Reconstruction to work efficiently, the correct SE must be used during the erosion stage. At first, small SE’s were used, the idea behind this was to create an SE that would be small enough to fit within the text but also large enough to not fit within the reflections or any other undesired objects. This type of SE worked to an extent, however due to the varying size of text objects and the closeness between the widths and heights of the text objects and the reflections. It was extremely difficult to find an SE that would fit at some point within all text objects and not fit in undesired objects such as reflections.

Instead a different approach was taken for the SE, a large square shaped SE was tested instead. The idea behind this was to create an SE large enough to remove all objects within the image both text and reflections and when the image is reconstructed, it would restore only the background of the image, i.e. the calculator keypad but without any text or reflections being present.  So now, the only difference between the input image and the reconstructed image is the missing text and reflection objects. 

To obtain an image that mainly contains the text and reflections, the reconstructed image can be subtracted from the input image, as both images have the same background, this will result in an output image that contains a uniformly black background and any differences between the images will be represented at a higher value pixels i.e. light grey/white colors representing the text and reflection objects. This method is known in image processing as Opening by Reconstruction Top Hat.

To improve the previous method even further, a line SE could be used for Opening by Reconstruction, as the horizontal length of the reflection objects within the image are greater than the horizontal length of each text objects. This would still remove the text objects during the erosion phase however the SE would fit within some of the reflections. This would cause some of the larger reflections to be reconstructed and in turn this will cause a large portion of the reflections to be removed when the images are subtracted from one another.

Concerning noise reduction methods, the primary background noise that will be focused upon for this project is gaussian noise. Gaussian noise is a form of background noise that causes pixels within an image to become normally distributed based on the probability density function. Most noise filters only work against specific types of noise, for example, applying an Open/Close method to an image will significantly reduce the level of “salt and pepper” noise present in the image, however it will have a lesser effect against gaussian noise. Therefore, a gaussian filter should be so that the levels of gaussian noise can be reduced efficiently. Ideally, this will occur at the beginning of the program, so that the main morphological methods will not affected by the gaussian noise.

Design.

Outline Approach
Firstly, load the image, apply any pre-processing techniques such as noise removal, greyscale conversion. If possible place only the text or both text and reflections on a uniform background, remove any undesired objects from the image such as reflections and shadings. Display the image result.

Pseudo Code.
1)	Load input image [A] into the program.
2)	Apply Pre-Processing techniques:
a.	Reduce/remove noise from image [A].
b.	Convert image [A] to greyscale if required. 
c.	Pre-Processing techniques outputs image [mask].
3)	Apply Opening by Construction on image [Mask].
a.	Firstly, apply Erosion on image [Mask], which outputs new image [marker].
b.	Reconstruct [marker] based on [mask], which outputs new image [B].
4)	Apply Opening by Construction Top-Hat
a.	Subtract reconstructed image [B] from [mask], which outputs new image [C].
5)	Set Image [C] equal to new mask [mask1].
6)	Apply Opening by Construction on image [Mask1].
a.	Apply Erosion on image [Mask1], which outputs new image [marker1].
b.	Reconstruct [marker1] based on [mask1], which outputs new image [D].
7)	Set Image [D] equal to new mask [mask2].
8)	Apply Opening by Construction on image [Mask2].
a.	Apply Erosion on image [Mask2], which outputs new image [marker2].
b.	Reconstruct [marker2] based on [mask2], which outputs new image [D1].
9)	Create binary version of image [D1].
a.	Apply Otsu on image [D1].
b.	Threshold image [D1] based on Otsu value, which outputs new image [Anew].
10)	Display Images [A] and [Anew] and compare differences.







Enhanced Matlab Program.

Introduction

The objective of this enhanced Matlab program is to isolate alpha numerical characters from multiple sets of images. As with its predecessor, the solution developed must be fully automated, data driven, robust as well as being computationally efficient. The robustness and accuracy of this program will be determined by its capabilities against not only scaling and background noise but also against the variations of the different calculators presented within the input images. 

Rational
The developed solution involves the use of a variety of unique functions to carry out its task successfully. The primary techniques used within the developed solution are “Open by Reconstruction”, “Erosion”, “Dilation”, “Subtract” and also the use of the Sobel edge detector. The reasoning as to why these methods were used for this program will be discussed in this section. Each method will be discussed in order of their implementation in the program, i.e. from beginning to end.

The first step within the program is to load the input image, once this is done any pre-processing functions were implemented. These functions include noise filters and converting to grayscale. Background noise can have dire effects on any image that is being processed, therefore it is advisable to removed background noise from an image early in the program. For the sake of this project, the main noise that will be focused upon is gaussian noise, therefore a filter that is effective against this type of noise should be used, such as a gaussian filter. The image can also be set to greyscale, this will reduce the size of the image by 3, as each pixel is being converted from a [r g b] value to a single value (0 - 255), therefore the program will be more computationally efficient.

Furthermore, each image that is inputted into the program will be set to a default size before any morphological processes take place. Additionally, the images original width and height are recorded and once the program has finished processing, the output image it is resized back to its original dimensions. The idea behind this approach is primarily in concern for the programs robustness against scaling, as the structuring elements used within this program are not adaptive to changes in scale. Since each image displays a calculator keypad, there are some universal similarities between each of the images, such as buttons. Therefore, if these images are set to a default size, any structuring elements used will have a higher change of adjusting to the current image being processed.

At this point, the image contains both wanted objects (characters) and unwanted objects (reflections). Opening by Reconstruction can be applied to the image, this process is highly dependent on the structuring element it uses, as during the erosion phase of this process, all objects are shrunk in accordance to the element and some objects are removed if they cannot contain the element. Any objects remaining are restored based on the input image in the reconstructed phase. As both the wanted and unwanted objects in most images are similar in terms of widths and lengths, it is very difficult to find a small structuring element that will remove the reflections and keep the text. Instead, a large structuring element was used, this element would not fit in any character text and results in the objects removal during the erosion phase, however it would fit in the larger reflections. Once the reconstruction occurred, the resultant image will display only the background of the calculator along with some reflections. If this reconstructed image was subtracted from the input image, only the differences between both images would be displayed, in this case the resultant image would contain only the text and some of the reflections, on a uniform black background.

Regarding the removal of the remainder of reflections, a different technique was considered, a Sobels edge detector was applied to the reconstructed image. This image only contained the background of the calculator as well as some reflections, hence only the edges of each calculator button was picked up by the edge detector. The reflections within the calculator images mainly occur on the outer portions of the calculator buttons, therefore, if the edge detector image was dilated with a square/rectangular structuring element, the edges it contained would expand. These edges would then occupy the same space as the remaining reflections in the resultant image. If the dilated image is subtracted from the resultant image which contains both the text and remaining reflections. The remaining reflections in the image will be cancelled out or reduced significantly by the subtraction. There are great benefits to this process, as it can be applied to potentially any image and is not overly dependent on the size of the structuring element.  

At this stage, most of the reflections have been dealt with successfully by the previous processes, therefore a basic “Opening by Reconstruction” process with a small structuring element can be applied. This method was chosen, as only small objects are required to be removed at this point, additionally the small structuring element will fit at some point in the text objects and these objects are then restored during the reconstruction phase.

Furthermore, throughout the developing phase, the program was set up to process three separate images in the one run. This was done in order to gain a clearer understanding of the effects each new method had whilst being implemented and tested within the program and to determine which methods where more robust than others.

Design

Outline Approach
Load the image, apply pre-processing techniques such as noise removal and greyscale conversion. Create a uniform background to place the characters and/or reflections on. Remove the unwanted objects (reflections) Display the image result.

Pseudo Code.
1.	Load input image [A] into the program.
2.	Apply Pre-Processing techniques:
a.	Reduce/remove noise from image [A].
b.	Convert image [A] to greyscale if required. 
c.	Set image [A] to a default size and record original height [HA] and width [WA].
d.	Pre-Processing techniques outputs image [mask].
3.	Apply Opening by Construction on image [Mask].
a.	Firstly, apply Erosion on image [Mask], which outputs new image [marker].
b.	Reconstruct [marker] based on [mask], which outputs new image [RA].
4.	Apply Opening by Construction Top-Hat
a.	Subtract reconstructed image [RA] from [mask], which outputs new image [C].
5.	Apply Sobel edge detector on reconstructed image [RA], outputs new image [EdgeRA].
a.	Dilate image [EdgeRA], outputs new image [DEdgeRA].
b.	Subtract reconstructed image [DEdgeRA] from [C], which outputs new image [RAE].
c.	Reconstruct [RAE] based on [C], which outputs new image [RAE1].
d.	Set Image [RAE1] equal to new mask [mask1].	
6.	Apply Opening by Construction on image [Mask1].
a.	Apply Erosion on image [Mask1], which outputs new image [marker1].
b.	Reconstruct [marker1] based on [mask1], which outputs new image [D].
7.	Create binary version of image [D].
a.	Apply Otsu on image [D].
b.	Threshold image [D] based on Otsu value, which outputs new image [BA].
8.	Resize image BA to its original size of [HA]x[WA], which outputs a new image [Anew]
9.	Display Images [A] and [Anew] and compare differences.





