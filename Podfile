platform :ios, "7.0"

inhibit_all_warnings!

pod 'CKStringUtils', 			'~> 2.0.1'

target :CKBasicAuthUrlUtilitiesTests, :exclusive => true do
    pod 'OCMock', 		:head
end

post_install do |installer|
    installer.project.targets.each do |target|
        puts target.name
    end
end