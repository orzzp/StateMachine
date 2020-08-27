#
#  Be sure to run `pod spec lint StateMachine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "SwiftStateMachine"
  spec.version      = "0.0.6"
  spec.summary      = "A short description of StateMachine."
  spec.description  = <<-DESC
                    "Swift StateMachine"
                   DESC
  spec.platform     = :ios, "10.0"
  spec.homepage     = "https://github.com/ioser-wzp/StateMachine"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "wzp" => "wzp.coder@gmail.com" }
  spec.source       = { :git => "https://github.com/ioser-wzp/StateMachine.git", :tag => "#{spec.version}" }

  spec.source_files = "StateMachineDemo/StateMachine/*"
end
