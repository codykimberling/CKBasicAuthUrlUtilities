Pod::Spec.new do |s|
  s.name         =  'CKBasicAuthUrlUtilities'
  s.version      =  '0.0.1'
  s.platform 	 =  :ios
  s.license      =  {:type => 'BSD'}
  s.homepage     =  'https://github.com/codykimberling/CKBasicAuthUrlUtilities'
  s.authors      =  {'Cody Kimberling' => 'clkimberling@gmail.com'}
  s.summary      =  'NSURL BASIC auth helper utility to upddate and strip usernames/passwords and build encoded NSURLs with NSStrings.'
  s.source       =  {:git => 'https://github.com/codykimberling/CKBasicAuthUrlUtilities.git', :tag => '0.0.2'}
  s.source_files =  'CKBasicAuthUrlUtilities/*.{h,m}'
  s.requires_arc = 	true
end