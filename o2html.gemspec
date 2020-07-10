Gem::Specification.new do |s|
  s.name = 'o2html'
  s.version = '0.1.0'
  s.summary = 'Experimental gem under development. Transforms custom HTML objects to HTML elements and JavaScript objects.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/o2html.rb']
  s.add_runtime_dependency('html-to-css', '~> 0.1', '>=0.1.10')
  s.signing_key = '../privatekeys/o2html.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/o2html'
end
