Pod::Spec.new do |s|
  s.name         =  'CKBasicAuthUrlUtilities'
  s.version      =  '2.0.1'
  s.platform 	   =  :ios
  s.license      =  {:type => 'BSD'}
  s.homepage     =  'https://github.com/codykimberling/CKBasicAuthUrlUtilities'
  s.authors      =  {'Cody Kimberling' => 'clkimberling@gmail.com'}
  s.summary      =  'NSURL BASIC Authentication utility.'
  s.description  =  'NSURL BASIC Authentication utility, includes methods to upddate and strip usernames/passwords, build encoded NSURLs, preemept NSURLRequest with Basic authentication plus more.'
  s.source       =  {:git => 'https://github.com/codykimberling/CKBasicAuthUrlUtilities.git', :tag => '2.0.1'}
  s.source_files =  'CKBasicAuthUrlUtilities/*.{h,m}'
  s.requires_arc = 	true
  s.dependency      'CKStringUtils', '2.0.1'
end