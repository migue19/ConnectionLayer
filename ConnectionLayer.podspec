Pod::Spec.new do |spec|
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = '13.0'
  spec.name         = "ConnectionLayer"
  spec.version      = "1.0.2"
  spec.summary      = "Una capa de conexión para hacer peticiones HTTP"
  spec.requires_arc = true
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.description  = <<-DESC
                      Framework con un conjunto de operaciones para hacer peticiones HTTP
                      DESC
  spec.homepage     = "https://github.com/migue19/ConnectionLayer"
  spec.author             = { "Miguel Mexicano Herrera" => "miguelmexicano18@gmail.com" }
  spec.source       = { :git => "https://github.com/migue19/ConnectionLayer.git", :tag => "#{spec.version}" }
  spec.source_files  = "ConnectionLayer/Classes/*.{swift}"
  spec.swift_version = "5.0"
end
