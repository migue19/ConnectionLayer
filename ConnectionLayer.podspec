Pod::Spec.new do |spec|
  spec.platform     = :ios, "12.1"
  spec.ios.deployment_target = '12.1'
  spec.name         = "ConnectionLayer"
  spec.version      = "0.0.1"
  spec.summary      = "Una capa de conexion simple"
  spec.requires_arc = true
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.description  = <<-DESC
                      Framework con un conjunto de operaciones para hacer peticiones http   
                      DESC
  spec.homepage     = "https://github.com/migue19/ConnectionLayer"
  spec.author             = { "Miguel Mexicano Herrera" => "miguelmexicano18@gmail.com" }
  spec.source       = { :git => "https://github.com/migue19/ConnectionLayer.git", :tag => "#{spec.version}" }
  spec.source_files  = "ConnectionLayer/**/*.{swift}"
  spec.swift_version = "5.0"
end