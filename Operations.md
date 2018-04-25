## Built-in operations ##

There are currently over 100 operations built into the framework, divided into the following categories:

### Image generators ###

- **SolidColorGenerator**: This outputs a generated image with a solid color. You need to define the image size using at initialization.
  - *color*: The color that is used to fill the image.

- **CircleGenerator**: This outputs a generated image of a circle, for use in masking. The renderCircleOfRadius() method lets you specify the radius, center, circleColor, and backgroundColor.
  
- **CrosshairGenerator**: This outputs a generated image of a circle, for use in masking. The renderCrosshairs() takes in a series of normalized coordinates and draws crosshairs at those coordinates.
  - *crosshairWidth*: Width, in pixels, of the crosshairs that are drawn.
  - *crosshairColor*: The color of the crosshairs.

### Color adjustments ###

- **BrightnessAdjustment**: Adjusts the brightness of the image
  - *brightness*: The adjusted brightness (-1.0 - 1.0, with 0.0 as the default)

- **ExposureAdjustment**: Adjusts the exposure of the image
  - *exposure*: The adjusted exposure (-10.0 - 10.0, with 0.0 as the default)

- **ContrastAdjustment**: Adjusts the contrast of the image
  - *contrast*: The adjusted contrast (0.0 - 4.0, with 1.0 as the default)

- **SaturationAdjustment**: Adjusts the saturation of an image
  - *saturation*: The degree of saturation or desaturation to apply to the image (0.0 - 2.0, with 1.0 as the default)

- **GammaAdjustment**: Adjusts the gamma of an image
  - *gamma*: The gamma adjustment to apply (0.0 - 3.0, with 1.0 as the default)

- **LevelsAdjustment**: Photoshop-like levels adjustment. The minimum, middle, maximum, minOutput and maxOutput parameters are floats in the range [0, 1]. If you have parameters from Photoshop in the range [0, 255] you must first convert them to be [0, 1]. The gamma/mid parameter is a float >= 0. This matches the value from Photoshop. If you want to apply levels to RGB as well as individual channels you need to use this filter twice - first for the individual channels and then for all channels.

- **ColorMatrixFilter**: Transforms the colors of an image by applying a matrix to them
  - *colorMatrix*: A 4x4 matrix used to transform each color in an image
  - *intensity*: The degree to which the new transformed color replaces the original color for each pixel

- **RGBAdjustment**: Adjusts the individual RGB channels of an image
  - *red*: Normalized values by which each color channel is multiplied. The range is from 0.0 up, with 1.0 as the default.
  - *green*: 
  - *blue*:

- **HueAdjustment**: Adjusts the hue of an image
  - *hue*: The hue angle, in degrees. 90 degrees by default

- **WhiteBalance**: Adjusts the white balance of an image.
  - *temperature*: The temperature to adjust the image by, in ºK. A value of 4000 is very cool and 7000 very warm. The default value is 5000. Note that the scale between 4000 and 5000 is nearly as visually significant as that between 5000 and 7000.
  - *tint*: The tint to adjust the image by. A value of -200 is *very* green and 200 is *very* pink. The default value is 0.  

- **HighlightsAndShadows**: Adjusts the shadows and highlights of an image
  - *shadows*: Increase to lighten shadows, from 0.0 to 1.0, with 0.0 as the default.
  - *highlights*: Decrease to darken highlights, from 1.0 to 0.0, with 1.0 as the default.

- **LookupFilter**: Uses an RGB color lookup image to remap the colors in an image. First, use your favourite photo editing application to apply a filter to lookup.png from framework/Operations/LookupImages. For this to work properly each pixel color must not depend on other pixels (e.g. blur will not work). If you need a more complex filter you can create as many lookup tables as required. Once ready, use your new lookup.png file as  the basis of a PictureInput that you provide for the lookupImage property.
  - *intensity*: The intensity of the applied effect, from 0.0 (stock image) to 1.0 (fully applied effect).
  - *lookupImage*: The image to use as the lookup reference, in the form of a PictureInput.

- **AmatorkaFilter**: A photo filter based on a Photoshop action by Amatorka: http://amatorka.deviantart.com/art/Amatorka-Action-2-121069631 . If you want to use this effect you have to add lookup_amatorka.png from the GPUImage framework/Operations/LookupImages folder to your application bundle.

- **MissEtikateFilter**: A photo filter based on a Photoshop action by Miss Etikate: http://miss-etikate.deviantart.com/art/Photoshop-Action-15-120151961 . If you want to use this effect you have to add lookup_miss_etikate.png from the GPUImage framework/Operations/LookupImages folder to your application bundle.

- **SoftElegance**: Another lookup-based color remapping filter. If you want to use this effect you have to add lookup_soft_elegance_1.png and lookup_soft_elegance_2.png from the GPUImage framework/Operations/LookupImages folder to your application bundle.

- **ColorInversion**: Inverts the colors of an image

- **Luminance**: Reduces an image to just its luminance (greyscale).

- **MonochromeFilter**: Converts the image to a single-color version, based on the luminance of each pixel
  - *intensity*: The degree to which the specific color replaces the normal image color (0.0 - 1.0, with 1.0 as the default)
  - *color*: The color to use as the basis for the effect, with (0.6, 0.45, 0.3, 1.0) as the default.

- **FalseColor**: Uses the luminance of the image to mix between two user-specified colors
  - *firstColor*: The first and second colors specify what colors replace the dark and light areas of the image, respectively. The defaults are (0.0, 0.0, 0.5) amd (1.0, 0.0, 0.0).
  - *secondColor*: 

- **Haze**: Used to add or remove haze (similar to a UV filter)
  - *distance*: Strength of the color applied. Default 0. Values between -.3 and .3 are best.
  - *slope*: Amount of color change. Default 0. Values between -.3 and .3 are best.

- **SepiaToneFilter**: Simple sepia tone filter
  - *intensity*: The degree to which the sepia tone replaces the normal image color (0.0 - 1.0, with 1.0 as the default)

- **OpacityAdjustment**: Adjusts the alpha channel of the incoming image
  - *opacity*: The value to multiply the incoming alpha channel for each pixel by (0.0 - 1.0, with 1.0 as the default)

- **LuminanceThreshold**: Pixels with a luminance above the threshold will appear white, and those below will be black
  - *threshold*: The luminance threshold, from 0.0 to 1.0, with a default of 0.5

- **AdaptiveThreshold**: Determines the local luminance around a pixel, then turns the pixel black if it is below that local luminance and white if above. This can be useful for picking out text under varying lighting conditions.
  - *blurRadiusInPixels*: A multiplier for the background averaging blur radius in pixels, with a default of 4.

- **AverageLuminanceThreshold**: This applies a thresholding operation where the threshold is continually adjusted based on the average luminance of the scene.
  - *thresholdMultiplier*: This is a factor that the average luminance will be multiplied by in order to arrive at the final threshold to use. By default, this is 1.0.

- **AverageColorExtractor**: This processes an input image and determines the average color of the scene, by averaging the RGBA components for each pixel in the image. A reduction process is used to progressively downsample the source image on the GPU, followed by a short averaging calculation on the CPU. The output from this filter is meaningless, but you need to set the colorAverageProcessingFinishedBlock property to a block that takes in four color components and a frame time and does something with them.

- **AverageLuminanceExtractor**: Like the AverageColorExtractor, this reduces an image to its average luminosity. You need to set the luminosityProcessingFinishedBlock to handle the output of this filter, which just returns a luminosity value and a frame time.

- **ChromaKeying**: For a given color in the image, sets the alpha channel to 0. This is similar to the ChromaKeyBlend, only instead of blending in a second image for a matching color this doesn't take in a second image and just turns a given color transparent.
  - *thresholdSensitivity*: How close a color match needs to exist to the target color to be replaced (default of 0.4)
  - *smoothing*: How smoothly to blend for the color match (default of 0.1)

- **Vibrance**: Adjusts the vibrance of an image
  - *vibrance*: The vibrance adjustment to apply, using 0.0 as the default, and a suggested min/max of around -1.2 and 1.2, respectively.

- **HighlightShadowTint**: Allows you to tint the shadows and highlights of an image independently using a color and intensity
  - *shadowTintColor*: Shadow tint RGB color (GPUVector4). Default: `{1.0f, 0.0f, 0.0f, 1.0f}` (red).
  - *highlightTintColor*: Highlight tint RGB color (GPUVector4). Default: `{0.0f, 0.0f, 1.0f, 1.0f}` (blue).
  - *shadowTintIntensity*: Shadow tint intensity, from 0.0 to 1.0. Default: 0.0
  - *highlightTintIntensity*: Highlight tint intensity, from 0.0 to 1.0, with 0.0 as the default.

### Image processing ###

- **TransformOperation**: This applies an arbitrary 2-D or 3-D transformation to an image
  - *transform*: This takes in Matrix4x4 row-major value that specifies the transform. Matrix4x4 values can be initialized from both CATransform3D (for 3-D manipulations) and CGAffineTransform (for 2-D) structs on Mac and iOS, or the matrix can be generated by other means.

- **Crop**: This crops an image to a specific region, then passes only that region on to the next stage in the filter
  - *cropSizeInPixels*: The pixel dimensions of the area to be cropped out of the image.
  - *locationOfCropInPixels*: The upper-left corner of the crop area. If not specified, the crop will be centered in the image.

- **LanczosResampling**: This lets you up- or downsample an image using Lanczos resampling, which results in noticeably better quality than the standard linear or trilinear interpolation. Simply use the overriddenOutputSize propety to set the target output resolution for the filter, and the image will be resampled for that new size.

- **Sharpen**: Sharpens the image
  - *sharpness*: The sharpness adjustment to apply (-4.0 - 4.0, with 0.0 as the default)

- **UnsharpMask**: Applies an unsharp mask
  - *blurRadiusInPixels*: The blur radius of the underlying Gaussian blur. The default is 4.0.
  - *intensity*: The strength of the sharpening, from 0.0 on up, with a default of 1.0

- **GaussianBlur**: A hardware-optimized, variable-radius Gaussian blur
  - *blurRadiusInPixels*: A radius in pixels to use for the blur, with a default of 2.0. This adjusts the sigma variable in the Gaussian distribution function.

- **BoxBlur**: A hardware-optimized, variable-radius box blur
  - *blurRadiusInPixels*: A radius in pixels to use for the blur, with a default of 2.0. This adjusts the box radius for the blur function.

- **SingleComponentGaussianBlur**: A modification of the GaussianBlur that operates only on the red component
  - *blurRadiusInPixels*: A radius in pixels to use for the blur, with a default of 2.0. This adjusts the sigma variable in the Gaussian distribution function.

- **iOSBlur**: An attempt to replicate the background blur used on iOS 7 in places like the control center.
  - *blurRadiusInPixels*: A radius in pixels to use for the blur, with a default of 48.0. This adjusts the sigma variable in the Gaussian distribution function.
  - *saturation*: Saturation ranges from 0.0 (fully desaturated) to 2.0 (max saturation), with 0.8 as the normal level
  - *rangeReductionFactor*: The range to reduce the luminance of the image, defaulting to 0.6.

- **MedianFilter**: Takes the median value of the three color components, over a 3x3 area

- **BilateralBlur**: A bilateral blur, which tries to blur similar color values while preserving sharp edges
  - *distanceNormalizationFactor*: A normalization factor for the distance between central color and sample color, with a default of 8.0.

- **TiltShift**: A simulated tilt shift lens effect
  - *blurRadiusInPixels*: The radius of the underlying blur, in pixels. This is 7.0 by default.
  - *topFocusLevel*: The normalized location of the top of the in-focus area in the image, this value should be lower than bottomFocusLevel, default 0.4
  - *bottomFocusLevel*: The normalized location of the bottom of the in-focus area in the image, this value should be higher than topFocusLevel, default 0.6
  - *focusFallOffRate*: The rate at which the image gets blurry away from the in-focus region, default 0.2

- **Convolution3x3**: Runs a 3x3 convolution kernel against the image
  - *convolutionKernel*: The convolution kernel is a 3x3 matrix of values to apply to the pixel and its 8 surrounding pixels. The matrix is specified in row-major order, with the top left pixel being m11 and the bottom right m33. If the values in the matrix don't add up to 1.0, the image could be brightened or darkened.

- **SobelEdgeDetection**: Sobel edge detection, with edges highlighted in white
  - *edgeStrength*: Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0.

- **PrewittEdgeDetection**: Prewitt edge detection, with edges highlighted in white
  - *edgeStrength*: Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0.

- **ThresholdSobelEdgeDetection**: Performs Sobel edge detection, but applies a threshold instead of giving gradual strength values
  - *edgeStrength*: Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0.
  - *threshold*: Any edge above this threshold will be black, and anything below white. Ranges from 0.0 to 1.0, with 0.8 as the default
  
- **Histogram**: This analyzes the incoming image and creates an output histogram with the frequency at which each color value occurs. The output of this filter is a 3-pixel-high, 256-pixel-wide image with the center (vertical) pixels containing pixels that correspond to the frequency at which various color values occurred. Each color value occupies one of the 256 width positions, from 0 on the left to 255 on the right. This histogram can be generated for individual color channels (.Red, .Green, .Blue), the luminance of the image (.Luminance), or for all three color channels at once (.RGB).
  - *downsamplingFactor*: Rather than sampling every pixel, this dictates what fraction of the image is sampled. By default, this is 16 with a minimum of 1. This is needed to keep from saturating the histogram, which can only record 256 pixels for each color value before it becomes overloaded.

- **HistogramDisplay**: This is a special filter, in that it's primarily intended to work with the Histogram. It generates an output representation of the color histograms generated by Histogram, but it could be repurposed to display other kinds of values. It takes in an image and looks at the center (vertical) pixels. It then plots the numerical values of the RGB components in separate colored graphs in an output texture. You may need to force a size for this filter in order to make its output visible.

- **HistogramEqualization**: This takes a image, analyzes its histogram, and equalizes the outbound image based on that.
  - *downsamplingFactor*: Rather than sampling every pixel, this dictates what fraction of the image is sampled by the histogram. By default, this is 16 with a minimum of 1. This is needed to keep from saturating the histogram, which can only record 256 pixels for each color value before it becomes overloaded.

- **CannyEdgeDetection**: This uses the full Canny process to highlight one-pixel-wide edges
  - *blurRadiusInPixels*: The underlying blur radius for the Gaussian blur. Default is 2.0.
  - *upperThreshold*: Any edge with a gradient magnitude above this threshold will pass and show up in the final result. Default is 0.4.
  - *lowerThreshold*: Any edge with a gradient magnitude below this threshold will fail and be removed from the final result. Default is 0.1.

- **HarrisCornerDetector**: Runs the Harris corner detection algorithm on an input image, and produces an image with those corner points as white pixels and everything else black. The cornersDetectedCallback can be set, and you will be provided with an array of corners (in normalized 0..1 Positions) within that callback for whatever additional operations you want to perform.
  - *blurRadiusInPixels*: The radius of the underlying Gaussian blur. The default is 2.0.
  - *sensitivity*: An internal scaling factor applied to adjust the dynamic range of the cornerness maps generated in the filter. The default is 5.0.
  - *threshold*: The threshold at which a point is detected as a corner. This can vary significantly based on the size, lighting conditions, and iOS device camera type, so it might take a little experimentation to get right for your cases. Default is 0.20.

- **NobleCornerDetector**: Runs the Noble variant on the Harris corner detector. It behaves as described above for the Harris detector.
  - *blurRadiusInPixels*: The radius of the underlying Gaussian blur. The default is 2.0.
  - *sensitivity*: An internal scaling factor applied to adjust the dynamic range of the cornerness maps generated in the filter. The default is 5.0.
  - *threshold*: The threshold at which a point is detected as a corner. This can vary significantly based on the size, lighting conditions, and iOS device camera type, so it might take a little experimentation to get right for your cases. Default is 0.2.

- **ShiTomasiCornerDetector**: Runs the Shi-Tomasi feature detector. It behaves as described above for the Harris detector.
  - *blurRadiusInPixels*: The radius of the underlying Gaussian blur. The default is 2.0.
  - *sensitivity*: An internal scaling factor applied to adjust the dynamic range of the cornerness maps generated in the filter. The default is 1.5.
  - *threshold*: The threshold at which a point is detected as a corner. This can vary significantly based on the size, lighting conditions, and iOS device camera type, so it might take a little experimentation to get right for your cases. Default is 0.2.

- **Dilation**: This performs an image dilation operation, where the maximum intensity of the color channels in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands bright regions.

- **Erosion**: This performs an image erosion operation, where the minimum intensity of the color channels in a rectangular neighborhood is used for the intensity of this pixel. The radius of the rectangular area to sample over is specified on initialization, with a range of 1-4 pixels. This is intended for use with grayscale images, and it expands dark regions.

- **OpeningFilter**: This performs an erosion on the color channels of an image, followed by a dilation of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller bright regions.

- **ClosingFilter**: This performs a dilation on the color channels of an image, followed by an erosion of the same radius. The radius is set on initialization, with a range of 1-4 pixels. This filters out smaller dark regions.

- **LocalBinaryPattern**: This performs a comparison of intensity of the red channel of the 8 surrounding pixels and that of the central one, encoding the comparison results in a bit string that becomes this pixel intensity. The least-significant bit is the top-right comparison, going counterclockwise to end at the right comparison as the most significant bit.

- **ColorLocalBinaryPattern**: This performs a comparison of intensity of all color channels of the 8 surrounding pixels and that of the central one, encoding the comparison results in a bit string that becomes each color channel's intensity. The least-significant bit is the top-right comparison, going counterclockwise to end at the right comparison as the most significant bit.

- **LowPassFilter**: This applies a low pass filter to incoming video frames. This basically accumulates a weighted rolling average of previous frames with the current ones as they come in. This can be used to denoise video, add motion blur, or be used to create a high pass filter.
  - *strength*: This controls the degree by which the previous accumulated frames are blended with the current one. This ranges from 0.0 to 1.0, with a default of 0.5.

- **HighPassFilter**: This applies a high pass filter to incoming video frames. This is the inverse of the low pass filter, showing the difference between the current frame and the weighted rolling average of previous ones. This is most useful for motion detection.
  - *strength*: This controls the degree by which the previous accumulated frames are blended and then subtracted from the current one. This ranges from 0.0 to 1.0, with a default of 0.5.

- **MotionDetector**: This is a motion detector based on a high-pass filter. You set the motionDetectedCallback and on every incoming frame it will give you the centroid of any detected movement in the scene (in normalized X,Y coordinates) as well as an intensity of motion for the scene.
  - *lowPassStrength*: This controls the strength of the low pass filter used behind the scenes to establish the baseline that incoming frames are compared with. This ranges from 0.0 to 1.0, with a default of 0.5.

- **MotionBlur**: Applies a directional motion blur to an image
  - *blurSize*: A multiplier for the blur size, ranging from 0.0 on up, with a default of 1.0
  - *blurAngle*: The angular direction of the blur, in degrees. 0 degrees by default.

- **ZoomBlur**: Applies a directional motion blur to an image
  - *blurSize*: A multiplier for the blur size, ranging from 0.0 on up, with a default of 1.0
  - *blurCenter*: The normalized center of the blur. (0.5, 0.5) by default

- **ColourFASTFeatureDetection**: Brings out the ColourFAST feature descriptors for an image
  - *blurRadiusInPixels*: The underlying blur radius for the box blur. Default is 3.0.

### Blending modes ###

- **ChromaKeyBlend**: Selectively replaces a color in the first image with the second image
  - *thresholdSensitivity*: How close a color match needs to exist to the target color to be replaced (default of 0.4)
  - *smoothing*: How smoothly to blend for the color match (default of 0.1)

- **DissolveBlend**: Applies a dissolve blend of two images
  - *mix*: The degree with which the second image overrides the first (0.0 - 1.0, with 0.5 as the default)

- **MultiplyBlend**: Applies a multiply blend of two images

- **AddBlend**: Applies an additive blend of two images

- **SubtractBlend**: Applies a subtractive blend of two images

- **DivideBlend**: Applies a division blend of two images

- **OverlayBlend**: Applies an overlay blend of two images

- **DarkenBlend**: Blends two images by taking the minimum value of each color component between the images

- **LightenBlend**: Blends two images by taking the maximum value of each color component between the images

- **ColorBurnBlend**: Applies a color burn blend of two images

- **ColorDodgeBlend**: Applies a color dodge blend of two images

- **ScreenBlend**: Applies a screen blend of two images

- **ExclusionBlend**: Applies an exclusion blend of two images

- **DifferenceBlend**: Applies a difference blend of two images

- **HardLightBlend**: Applies a hard light blend of two images

- **SoftLightBlend**: Applies a soft light blend of two images

- **AlphaBlend**: Blends the second image over the first, based on the second's alpha channel
  - *mix*: The degree with which the second image overrides the first (0.0 - 1.0, with 1.0 as the default)

- **SourceOverBlend**: Applies a source over blend of two images

- **ColorBurnBlend**: Applies a color burn blend of two images

- **ColorDodgeBlend**: Applies a color dodge blend of two images

- **NormalBlend**: Applies a normal blend of two images

- **ColorBlend**: Applies a color blend of two images

- **HueBlend**: Applies a hue blend of two images

- **SaturationBlend**: Applies a saturation blend of two images

- **LuminosityBlend**: Applies a luminosity blend of two images

- **LinearBurnBlend**: Applies a linear burn blend of two images

### Visual effects ###

- **Pixellate**: Applies a pixellation effect on an image or video
  - *fractionalWidthOfAPixel*: How large the pixels are, as a fraction of the width and height of the image (0.0 - 1.0, default 0.05)

- **PolarPixellate**: Applies a pixellation effect on an image or video, based on polar coordinates instead of Cartesian ones
  - *center*: The center about which to apply the pixellation, defaulting to (0.5, 0.5)
  - *pixelSize*: The fractional pixel size, split into width and height components. The default is (0.05, 0.05)

- **PolkaDot**: Breaks an image up into colored dots within a regular grid
  - *fractionalWidthOfAPixel*: How large the dots are, as a fraction of the width and height of the image (0.0 - 1.0, default 0.05)
  - *dotScaling*: What fraction of each grid space is taken up by a dot, from 0.0 to 1.0 with a default of 0.9.

- **Halftone**: Applies a halftone effect to an image, like news print
  - *fractionalWidthOfAPixel*: How large the halftone dots are, as a fraction of the width and height of the image (0.0 - 1.0, default 0.05)

- **Crosshatch**: This converts an image into a black-and-white crosshatch pattern
  - *crossHatchSpacing*: The fractional width of the image to use as the spacing for the crosshatch. The default is 0.03.
  - *lineWidth*: A relative width for the crosshatch lines. The default is 0.003.

- **SketchFilter**: Converts video to look like a sketch. This is just the Sobel edge detection filter with the colors inverted
  - *edgeStrength*: Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0.

- **ThresholdSketchFilter**: Same as the sketch filter, only the edges are thresholded instead of being grayscale
  - *edgeStrength*: Adjusts the dynamic range of the filter. Higher values lead to stronger edges, but can saturate the intensity colorspace. Default is 1.0.
  - *threshold*: Any edge above this threshold will be black, and anything below white. Ranges from 0.0 to 1.0, with 0.8 as the default

- **ToonFilter**: This uses Sobel edge detection to place a black border around objects, and then it quantizes the colors present in the image to give a cartoon-like quality to the image.
  - *threshold*: The sensitivity of the edge detection, with lower values being more sensitive. Ranges from 0.0 to 1.0, with 0.2 as the default
  - *quantizationLevels*: The number of color levels to represent in the final image. Default is 10.0

- **SmoothToonFilter**: This uses a similar process as the ToonFilter, only it precedes the toon effect with a Gaussian blur to smooth out noise.
  - *blurRadiusInPixels*: The radius of the underlying Gaussian blur. The default is 2.0.
  - *threshold*: The sensitivity of the edge detection, with lower values being more sensitive. Ranges from 0.0 to 1.0, with 0.2 as the default
  - *quantizationLevels*: The number of color levels to represent in the final image. Default is 10.0

- **EmbossFilter**: Applies an embossing effect on the image
  - *intensity*: The strength of the embossing, from  0.0 to 4.0, with 1.0 as the normal level

- **Posterize**: This reduces the color dynamic range into the number of steps specified, leading to a cartoon-like simple shading of the image.
  - *colorLevels*: The number of color levels to reduce the image space to. This ranges from 1 to 256, with a default of 10.

- **SwirlDistortion**: Creates a swirl distortion on the image
  - *radius*: The radius from the center to apply the distortion, with a default of 0.5
  - *center*: The center of the image (in normalized coordinates from 0 - 1.0) about which to twist, with a default of (0.5, 0.5)
  - *angle*: The amount of twist to apply to the image, with a default of 1.0

- **BulgeDistortion**: Creates a bulge distortion on the image
  - *radius*: The radius from the center to apply the distortion, with a default of 0.25
  - *center*: The center of the image (in normalized coordinates from 0 - 1.0) about which to distort, with a default of (0.5, 0.5)
  - *scale*: The amount of distortion to apply, from -1.0 to 1.0, with a default of 0.5

- **PinchDistortion**: Creates a pinch distortion of the image
  - *radius*: The radius from the center to apply the distortion, with a default of 1.0
  - *center*: The center of the image (in normalized coordinates from 0 - 1.0) about which to distort, with a default of (0.5, 0.5)
  - *scale*: The amount of distortion to apply, from -2.0 to 2.0, with a default of 1.0

- **StretchDistortion**: Creates a stretch distortion of the image
  - *center*: The center of the image (in normalized coordinates from 0 - 1.0) about which to distort, with a default of (0.5, 0.5)

- **SphereRefraction**: Simulates the refraction through a glass sphere
  - *center*: The center about which to apply the distortion, with a default of (0.5, 0.5)
  - *radius*: The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
  - *refractiveIndex*: The index of refraction for the sphere, with a default of 0.71

- **GlassSphereRefraction**: Same as SphereRefraction, only the image is not inverted and there's a little bit of frosting at the edges of the glass
  - *center*: The center about which to apply the distortion, with a default of (0.5, 0.5)
  - *radius*: The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
  - *refractiveIndex*: The index of refraction for the sphere, with a default of 0.71

- **Vignette**: Performs a vignetting effect, fading out the image at the edges
  - *center*: The center for the vignette in tex coords (CGPoint), with a default of 0.5, 0.5
  - *color*: The color to use for the vignette (GPUVector3), with a default of black
  - *start*: The normalized distance from the center where the vignette effect starts, with a default of 0.5
  - *end*: The normalized distance from the center where the vignette effect ends, with a default of 0.75

- **KuwaharaFilter**: Kuwahara image abstraction, drawn from the work of Kyprianidis, et. al. in their publication "Anisotropic Kuwahara Filtering on the GPU" within the GPU Pro collection. This produces an oil-painting-like image, but it is extremely computationally expensive, so it can take seconds to render a frame on an iPad 2. This might be best used for still images.
  - *radius*: In integer specifying the number of pixels out from the center pixel to test when applying the filter, with a default of 4. A higher value creates a more abstracted image, but at the cost of much greater processing time.

- **KuwaharaRadius3Filter**: A modified version of the Kuwahara filter, optimized to work over just a radius of three pixels

- **CGAColorspace**: Simulates the colorspace of a CGA monitor

- **Solarize**: Applies a solarization effect
  - *threshold*: Pixels with a luminance above the threshold will invert their color. Ranges from 0.0 to 1.0, with 0.5 as the default.

