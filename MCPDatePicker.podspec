Pod::Spec.new do |spec|
  spec.name         = 'MCPDatePicker'
  spec.homepage		= "https://bitbucket.org/Machipla/mcppods"
  spec.version      = '1.0.4'
  spec.platform 	= :ios, "6.0"
  spec.authors      = { 'Mario Chinchilla' => 'mario.chinchilla.plaza@gmail.com' }
  spec.summary      = 'Vista de selección de fecha configurable.'
  spec.source       = { :git => 'http://gitlab.planetmedia.es/Pods/MCPDatePicker.git', :tag => "#{spec.version}" }
  spec.source_files = "*.{h,m}"
end