Gem::Specification.new do |s|
  s.name    = "ysd_md_comparison"
  s.version = "0.2.13"
  s.authors = ["Yurak Sisa Dream"]
  s.date    = "2012-06-19"
  s.email   = ["yurak.sisa.dream@gmail.com"]
  s.files   = Dir['lib/**/*.rb']
  s.summary = "Comparison system"
  s.homepage = "http://github.com/yuraksisa/ysd_core_plugins"
  
  s.add_dependency "do_postgres"
  s.add_dependency "dm-postgres-adapter"

end