Pod::Spec.new do |s|
  s.name         = 'CKBasicAuthUrlUtilities'
  s.version      = '1.0.0'
  s.platform 	 = :ios
  s.license      =  :type => 'BSD' 
  s.homepage     =  ''
  s.authors      =  'Cody Kimberling' => 'clkimberling@gmail.com' 
  s.summary      =  ''
  s.source       =  :git => 'https://github.com/', :tag => 'v1.0.0' 
  s.source_files =  'CKBasicAuthUrlUtilities/*.{h,m}'
  s.requires_arc = 	true
end