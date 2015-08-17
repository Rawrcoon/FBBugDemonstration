
Pod::Spec.new do |s|
  s.name         = "TestPod"
  s.version      = "0.0.1"
  s.summary      = "A short description of TestPod."
  s.description  = <<-DESC
                   A longer description of TestPod in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/TestPod"
  s.license      = "MIT"
  s.author             = { "Sören Busch" => "sbusch@mobivention.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/fleshgolem/TestPod.git", :tag => "0.0.1" }
  s.source_files  = "TestClass.swift"

  s.dependency "Bolts"
  s.dependency "FBSDKCoreKit"
  s.dependency "FBSDKLoginKit"
  s.dependency "FBSDKShareKit"

end
