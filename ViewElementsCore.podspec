Pod::Spec.new do |s|

    # 1
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "ViewElementsCore"
    s.summary = "Build view declaratively"
    s.requires_arc = true

    s.version = "0.1.0"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "Wirawit" => "aun.wirawit@gmail.com" }
    s.homepage = "https://github.com/aunnnn/ViewElements"
    s.source = { :git => "https://github.com/aunnnn/ViewElements.git", :tag => "#{s.version}"}
    s.framework = "UIKit"
    s.source_files = "ViewElementsCore/ViewElementsCore/**/*.swift"
end
