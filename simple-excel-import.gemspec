Gem::Specification.new do |s|
  s.name = 'simple-excel-import'
  s.version = '0.0.2'
  s.platform = Gem::Platform::RUBY
  s.date = '2013-03-25'
  s.summary = 'simple-excel-import'
  s.description = 'simple-excel-import'
  s.authors = ['arlyxiao', 'fushang318', 'ben7th']
  s.email = 'kingla_pei@163.com'
  s.homepage = 'https://github.com/mindpin/simple-excel-import'
  s.licenses = 'MIT'

  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_paths = ['lib']

  s.add_dependency('roo', '1.10.3')
  s.add_dependency('axlsx', '1.3.5')
end