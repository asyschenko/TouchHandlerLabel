Pod::Spec.new do |s|

  s.name          = "TouchHandlerLabel"
  s.version       = "0.2.0"
  s.homepage      = "https://github.com/asyschenko/TouchHandlerLabel"
  s.summary       = "Extended UILabel for touch handling text like URL, email e.t.c"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "Aleksandr Syschenko" => "asyschenko@gmail.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/asyschenko/TouchHandlerLabel.git", :tag => "#{s.version}" }
  s.source_files  = "TouchHandlerLabel/*.{swift}"
  s.swift_version = "5.0"
  
end
