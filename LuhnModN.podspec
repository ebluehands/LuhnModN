Pod::Spec.new do |s|
  s.name             = 'LuhnModN'
  s.version          = '1.1.1'
  s.summary          = 'This is an implementation of the Luhn mod N algorithm in Swift.'
  s.description      = <<-DESC
This is an implementation of the Luhn mod N algorithm in Swift.

Features :

    * Add the check digit to a string
    * Check the validity of a string
    * Works in mod 2 to 36

                       DESC
  s.homepage         = 'https://github.com/ebluehands/LuhnModN'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'git' => 'a.bultot@gmail.com' }
  s.source           = { :git => 'https://github.com/ebluehands/LuhnModN.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ebluehands'

  s.ios.deployment_target = '9.2'

  s.source_files = 'LuhnModN/*.swift'
end
