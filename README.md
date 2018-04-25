# GPUImage 2 #

<div style="float: right"><img src="http://sunsetlakesoftware.com/sites/default/files/GPUImageLogo.png" /></div>

Brad Larson

http://www.sunsetlakesoftware.com

[@bradlarson](http://twitter.com/bradlarson)

contact@sunsetlakesoftware.com

## Overview ##

GPUImage 2 is the second generation of the <a href="https://github.com/BradLarson/GPUImage">GPUImage framework</a>, an open source project for performing GPU-accelerated image and video processing on Mac, iOS, and now Linux. The original GPUImage framework was written in Objective-C and targeted Mac and iOS, but this latest version is written entirely in Swift and can also target Linux and future platforms that support Swift code.

The objective of the framework is to make it as easy as possible to set up and perform realtime video processing or machine vision against image or video sources. By relying on the GPU to run these operations, performance improvements of 100X or more over CPU-bound code can be realized. This is particularly noticeable in mobile or embedded devices. On an iPhone 4S, this framework can easily process 1080p video at over 60 FPS. On a Raspberry Pi 3, it can perform Sobel edge detection on live 720p video at over 20 FPS.

## License ##

BSD-style, with the full license available with the framework in License.txt.

## Technical requirements ##

- Swift 3
- Xcode 8.0 on Mac or iOS
- iOS: 8.0 or higher (Swift is supported on 7.0, but not Mac-style frameworks)
- OSX: 10.9 or higher
- Linux: Wherever Swift code can be compiled. Currently, that's Ubuntu 14.04 or higher, along with the many other places it has been ported to. I've gotten this running on the latest Raspbian, for example. For camera input, Video4Linux needs to be installed.

## General architecture ##

The framework relies on the concept of a processing pipeline, where image sources are targeted at image consumers, and so on down the line until images are output to the screen, to image files, to raw data, or to recorded movies. Cameras, movies, still images, and raw data can be inputs into this pipeline. Arbitrarily complex processing operations can be built from a combination of a series of smaller operations.

This is an object-oriented framework, with classes that encapsulate inputs, processing operations, and outputs. The processing operations use Open GL (ES) vertex and fragment shaders to perform their image manipulations on the GPU.

Examples for usage of the framework in common applications are shown below.

## Using GPUImage in an Mac or iOS application ##

To add the GPUImage framework to your Mac or iOS application, either drag the GPUImage.xcodeproj project into your application's project or add it via File | Add Files To...

After that, go to your project's Build Phases and add GPUImage_iOS or GPUImage_macOS as a Target Dependency. Add it to the Link Binary With Libraries phase. Add a new Copy Files build phase, set its destination to Frameworks, and add the upper GPUImage.framework (for Mac) or lower GPUImage.framework (for iOS) to that. That last step will make sure the framework is deployed in your application bundle. 

In any of your Swift files that reference GPUImage classes, simply add

```swift
import GPUImage
```

and you should be ready to go.

Note that you may need to build your project once to parse and build the GPUImage framework in order for Xcode to stop warning you about the framework and its classes being missing.

## Using GPUImage in a Linux application ##

Eventually, this project will support the Swift Package Manager, which will make it trivial to use with a Linux project. Unfortunately, that's not yet the case, so it can take a little work to get this to build for a Linux project.

Right now, there are two build scripts in the framework directory, one named compile-LinuxGL.sh and one named compile-RPi.sh. The former builds the framework for a Linux target using OpenGL and the latter builds for the Raspberry Pi. I can add other targets as I test them, but I've only gotten this operational in desktop Ubuntu, on Ubuntu running on a Jetson TK1 development board, and on Raspbian running on a Raspberry Pi 2 and Pi 3.

Before compiling the framework, you'll need to get Swift up and running on your system. For desktop Ubuntu installs, you can follow Apple's guidelines on <a href="https://swift.org/download/">their Downloads page</a>. Those instructions also worked for me on the Jetson TK1 dev board.

For ARM Linux devices like the Raspberry Pi, follow <a href="http://dev.iachieved.it/iachievedit/open-source-swift-on-raspberry-pi-2/">these steps exactly</a> to get a working Swift compiler installed. Pay close attention to the steps for getting Clang-2.6 installed and the use of update-alternatives. These are the steps I used to go from stock Raspbian to a Swift install on 

I have noticed that Swift 2.2 compiler snapshots newer than January 11 or so are missing Foundation, which I need for the framework, so maybe go with a snaphot earlier than that. 

After Swift, you'll need to install Video4Linux to get access to standard USB webcams as inputs:

```
sudo apt-get install libv4l-dev
```

On the Raspberry Pi, you'll need to make sure that the Broadcom Videocore headers and libraries are installed for GPU access:

```
sudo apt-get install libraspberrypi-dev
```

For desktop Linux and other OpenGL devices (Jetson TK1), you'll need to make sure GLUT and the OpenGL headers are installed. The framework currently uses GLUT for its output. GLUT can be used on the Raspberry Pi via the new experimental OpenGL support there, but I've found that it's significantly slower than using the OpenGL ES APIs and the Videocore interface that ships with the Pi. Also, if you enable the OpenGL support you currently lock yourself out of using the Videocore interface.

Once all of that is set up, to build the framework go to the /framework directory and run the appropriate build script. This will compile and generate a Swift module and a shared library for the framework. Copy the shared library into a system-accessible library path, like /usr/lib.

To build any of the sample applications, go to the examples/ subdirectory for that example (examples are platform-specific) and run the compile.sh build script to compile the example. The framework must be built before any example application.

As Swift becomes incorporated into more platforms, and as I add support for the Swift Package Manager, these Linux build steps will become much easier. My setup is kind of a hack at present.

## Performing common tasks ##

### Filtering live video ###

To filter live video from a Mac or iOS camera, you can write code like the following:

```swift
do {
    camera = try Camera(sessionPreset:AVCaptureSessionPreset640x480)
    filter = SaturationAdjustment()
    camera --> filter --> renderView
    camera.startCapture()
} catch {
    fatalError("Could not initialize rendering pipeline: \(error)")
}
```

where renderView is an instance of RenderView that you've placed somewhere in your view hierarchy. The above instantiates a 640x480 camera instance, creates a saturation filter, and directs camera frames to be processed through the saturation filter on their way to the screen. startCapture() initiates the camera capture process.

The --> operator chains an image source to an image consumer, and many of these can be chained in the same line.

### Capturing and filtering a still photo ###

Functionality not completed.

### Capturing an image from video ###

(Not currently available on Linux.)

To capture a still image from live video, you need to set a callback to be performed on the next frame of video that is processed. The easiest way to do this is to use the convenience extension to capture, encode, and save a file to disk:

```swift
filter.saveNextFrameToURL(url, format:.PNG)
```

Under the hood, this creates a PictureOutput instance, attaches it as a target to your filter, sets the PictureOutput's encodedImageFormat to PNG files, and sets the encodedImageAvailableCallback to a closure that takes in the data for the filtered image and saves it to a URL.

You can set this up manually to get the encoded image data (as NSData):

```swift
let pictureOutput = PictureOutput()
pictureOutput.encodedImageFormat = .JPEG
pictureOutput.encodedImageAvailableCallback = {imageData in
    // Do something with the NSData
}
filter --> pictureOutput
```

You can also get the filtered image in a platform-native format (NSImage, UIImage) by setting the imageAvailableCallback:

```swift
let pictureOutput = PictureOutput()
pictureOutput.encodedImageFormat = .JPEG
pictureOutput.imageAvailableCallback = {image in
    // Do something with the image
}
filter --> pictureOutput
```

### Processing a still image ###

(Not currently available on Linux.)

There are a few different ways to approach filtering an image. The easiest are the convenience extensions to UIImage or NSImage that let you filter that image and return a UIImage or NSImage:

```swift
let testImage = UIImage(named:"WID-small.jpg")!
let toonFilter = SmoothToonFilter()
let filteredImage = try! testImage.filterWithOperation(toonFilter)
```

for a more complex pipeline:

```swift
let testImage = UIImage(named:"WID-small.jpg")!
let toonFilter = SmoothToonFilter()
let luminanceFilter = Luminance()
let filteredImage = try! testImage.filterWithPipeline{input, output in
    input --> toonFilter --> luminanceFilter --> output
}
```

One caution: if you want to display an image to the screen or repeatedly filter an image, don't use these methods. Going to and from Core Graphics adds a lot of overhead. Instead, I recommend manually setting up a pipeline and directing it to a RenderView for display in order to keep everything on the GPU.

Both of these convenience methods wrap several operations. To feed a picture into a filter pipeline, you instantiate a PictureInput. To capture a picture from the pipeline, you use a PictureOutput. To manually set up processing of an image, you can use something like the following:

```swift
let toonFilter = SmoothToonFilter()
let testImage = UIImage(named:"WID-small.jpg")!
let pictureInput = try! PictureInput(image:testImage)
let pictureOutput = PictureOutput()
pictureOutput.imageAvailableCallback = {image in
    // Do something with image
}
pictureInput --> toonFilter --> pictureOutput
pictureInput.processImage(synchronously:true)
```

In the above, the imageAvailableCallback will be triggered right at the processImage() line. If you want the image processing to be done asynchronously, leave out the synchronously argument in the above.

### Filtering and re-encoding a movie ###

To filter and playback an existing movie file, you can write code like the following:

```swift

do {
    let bundleURL = Bundle.main.resourceURL!
    let movieURL = URL(string:"sample_iPod.m4v", relativeTo:bundleURL)!

    let audioDecodeSettings = [AVFormatIDKey:kAudioFormatLinearPCM]

    movie = try MovieInput(url:movieURL, playAtActualSpeed:true, loop:true, audioSettings:audioDecodeSettings)
    speaker = SpeakerOutput()
    movie.audioEncodingTarget = speaker

    filter = SaturationAdjustment()
    movie --> filter --> renderView

    movie.start()
    speaker.start()
} catch {
    print("Couldn't process movie with error: \(error)")
}
```

where renderView is an instance of RenderView that you've placed somewhere in your view hierarchy. The above loads a movie named "sample_iPod.m4v" from the application's bundle, creates a saturation filter, and directs movie frames to be processed through the saturation filter on their way to the screen. start() initiates the movie playback.

To filter an existing movie file and save the result to a new movie file you can write code like the following:


```swift
let bundleURL = Bundle.main.resourceURL!
// The movie you want to reencode
let movieURL = URL(string:"sample_iPod.m4v", relativeTo:bundleURL)!

let documentsDir = FileManager().urls(for:.documentDirectory, in:.userDomainMask).first!
// The location you want to save the new video
let exportedURL = URL(string:"test.mp4", relativeTo:documentsDir)!

let asset = AVURLAsset(url:movieURL, options:[AVURLAssetPreferPreciseDurationAndTimingKey:NSNumber(value:true)])

guard let videoTrack = asset.tracks(withMediaType:AVMediaType.video).first else { return }
let audioTrack = asset.tracks(withMediaType:AVMediaType.audio).first

// If you would like passthrough audio instead, set both audioDecodingSettings and audioEncodingSettings to nil
let audioDecodingSettings:[String:Any] = [AVFormatIDKey:kAudioFormatLinearPCM] // Noncompressed audio samples

do {
    movieInput = try MovieInput(asset:asset, videoComposition:nil, playAtActualSpeed:false, loop:false, audioSettings:audioDecodingSettings)
}
catch {
    print("ERROR: Unable to setup MovieInput with error: \(error)")
    return
}

try? FileManager().removeItem(at: exportedURL)

let videoEncodingSettings:[String:Any] = [
    AVVideoCompressionPropertiesKey: [
        AVVideoExpectedSourceFrameRateKey:videoTrack.nominalFrameRate,
        AVVideoAverageBitRateKey:videoTrack.estimatedDataRate,
        AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel,
        AVVideoH264EntropyModeKey:AVVideoH264EntropyModeCABAC,
        AVVideoAllowFrameReorderingKey:videoTrack.requiresFrameReordering],
    AVVideoCodecKey:AVVideoCodecH264]

var acl = AudioChannelLayout()
memset(&acl, 0, MemoryLayout<AudioChannelLayout>.size)
acl.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo
let audioEncodingSettings:[String:Any] = [
    AVFormatIDKey:kAudioFormatMPEG4AAC,
    AVNumberOfChannelsKey:2,
    AVSampleRateKey:AVAudioSession.sharedInstance().sampleRate,
    AVChannelLayoutKey:NSData(bytes:&acl, length:MemoryLayout<AudioChannelLayout>.size),
    AVEncoderBitRateKey:96000
]

do {
    movieOutput = try MovieOutput(URL:exportedURL, size:Size(width:Float(videoTrack.naturalSize.width), height:Float(videoTrack.naturalSize.height)), fileType:AVFileType.mp4.rawValue, liveVideo:false, videoSettings:videoEncodingSettings, videoNaturalTimeScale:videoTrack.naturalTimeScale, audioSettings:audioEncodingSettings)
}
catch {
    print("ERROR: Unable to setup MovieOutput with error: \(error)")
    return
}

filter = SaturationAdjustment()

if(audioTrack != nil) { movieInput.audioEncodingTarget = movieOutput }
movieInput.synchronizedMovieOutput = movieOutput
movieInput --> filter --> movieOutput

movieInput.completion = {
    self.movieOutput.finishRecording {
        self.movieInput.audioEncodingTarget = nil
        self.movieInput.synchronizedMovieOutput = nil
        print("Encoding finished")
    }
}

movieOutput.startRecording() { started, error in
    if(!started) {
        print("ERROR: MovieOutput unable to start writing with error: \(String(describing: error))")
        return
    }
    self.movieInput.start()
    print("Encoding started")
}
```

 The above loads a movie named "sample_iPod.m4v" from the application's bundle, creates a saturation filter, and directs movie frames to be processed through the saturation filter on their way to the new file. In addition it writes the audio in AAC format to the new file.

### Writing a custom image processing operation ###

The framework uses a series of protocols to define types that can output images to be processed, take in an image for processing, or do both. These are the ImageSource, ImageConsumer, and ImageProcessingOperation protocols, respectively. Any type can comply to these, but typically classes are used.

Many common filters and other image processing operations can be described as subclasses of the BasicOperation class. BasicOperation provides much of the internal code required for taking in an image frame from one or more inputs, rendering a rectangular image (quad) from those inputs using a specified shader program, and providing that image to all of its targets. Variants on BasicOperation, such as TextureSamplingOperation or TwoStageOperation, provide additional information to the shader program that may be needed for certain kinds of operations.

To build a simple, one-input filter, you may not even need to create a subclass of your own. All you need to do is supply a fragment shader and the number of inputs needed when instantiating a BasicOperation:

```swift
let myFilter = BasicOperation(fragmentShaderFile:MyFilterFragmentShaderURL, numberOfInputs:1)
```

A shader program is composed of matched vertex and fragment shaders that are compiled and linked together into one program. By default, the framework uses a series of stock vertex shaders based on the number of input images feeding into an operation. Usually, all you'll need to do is provide the custom fragment shader that is used to perform your filtering or other processing.

Fragment shaders used by GPUImage look something like this:

```
varying highp vec2 textureCoordinate;

uniform sampler2D inputImageTexture;
uniform lowp float gamma;

void main()
{
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    
    gl_FragColor = vec4(pow(textureColor.rgb, vec3(gamma)), textureColor.w);
}
```

The naming convention for texture coordinates is that textureCoordinate, textureCoordinate2, etc. are provided as varyings from the vertex shader. inputImageTexture, inputImageTexture2, etc. are the textures that represent each image being passed into the shader program. Uniforms can be defined to control the properties of whatever shader you're running. You'll need to provide two fragment shaders, one for OpenGL ES, which has precision qualifiers, and one for OpenGL, which does not.

Within the framework itself, a custom script converts these shader files into inlined string constants so that they are bundled with the compiled framework. If you add a new operation to the framework, you'll need to run

```
./ShaderConverter.sh *
```

within the Operations/Shaders directory to update these inlined constants.

### Grouping operations ###

If you wish to group a series of operations into a single unit to pass around, you can create a new instance of OperationGroup. OperationGroup provides a configureGroup property that takes a closure which specifies how the group should be configured:

```swift
let boxBlur = BoxBlur()
let contrast = ContrastAdjustment()

let myGroup = OperationGroup()

myGroup.configureGroup{input, output in
    input --> self.boxBlur --> self.contrast --> output
}
```

Frames coming in to the OperationGroup are represented by the input in the above closure, and frames going out of the entire group by the output. After setup, myGroup in the above will appear like any other operation, even though it is composed of multiple sub-operations. This group can then be passed or worked with like a single operation.

### Interacting with OpenGL / OpenGL ES ###

GPUImage can both export and import textures from OpenGL (ES) through the use of its TextureOutput and TextureInput classes, respectively. This lets you record a movie from an OpenGL scene that is rendered to a framebuffer object with a bound texture, or filter video or images and then feed them into OpenGL as a texture to be displayed in the scene.

The one caution with this approach is that the textures used in these processes must be shared between GPUImage's OpenGL (ES) context and any other context via a share group or something similar.

## Common types ##

The framework uses several platform-independent types to represent common values. Generally, floating-point inputs are taken in as Floats. Sizes are specified using Size types (constructed by initializing with width and height). Colors are handled via the Color type, where you provide the normalized-to-1.0 color values for red, green, blue, and optionally alpha components.

Positions can be provided in 2-D and 3-D coordinates. If a Position is created by only specifying X and Y values, it will be handled as a 2-D point. If an optional Z coordinate is also provided, it will be dealt with as a 3-D point.

Matrices come in Matrix3x3 and Matrix4x4 varieties. These matrices can be build using a row-major array of Floats, or (on Mac and iOS) can be initialized from CATransform3D or CGAffineTransform structs.
