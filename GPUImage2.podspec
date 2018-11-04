Pod::Spec.new do |s|
s.name     = 'GPUImage2'
s.version  = '0.3.0'
s.license  = 'BSD'
s.summary  = 'An open source iOS framework for GPU-based image and video processing.'
s.homepage = 'https://github.com/premyslvlcek/GPUImage2'
s.author   = { 'Premysl Vlcek' => 'premysl.vlcek@strv.com' }

s.source   = { :git => 'https://github.com/premyslvlcek/GPUImage2' }

s.source_files = 'framework/Source/**/*.{swift}'
s.resources = 'framework/Source/Operations/Shaders/*.{fsh}'
s.requires_arc = true
s.xcconfig = { 'CLANG_MODULES_AUTOLINK' => 'YES', 'OTHER_SWIFT_FLAGS' => "$(inherited) -DGLES"}

s.ios.deployment_target = '10.0'
s.ios.exclude_files = 'framework/Source/Mac', 'framework/Source/Linux', 'framework/Source/Operations/Shaders/ConvertedShaders_GL.swift'
s.frameworks   = ['OpenGLES', 'CoreMedia', 'QuartzCore', 'AVFoundation']

s.dependency 'TPCircularBuffer'
s.dependency 'NSObjectObjCExceptionExtension'

end
