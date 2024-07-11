# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your wagon's version:
require "hitobito_svse/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "hitobito_svse"
  s.version = HitobitoSvse::VERSION
  s.authors = ["Pascal Simon"]
  s.email = ["info@hitobito.com"]
  s.homepage = "http://www.hitobito.com"
  s.summary = "SVSE organization specific features"
  s.description = "Schweizer Sportsverband öffentlicher Verkehr specific features"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile"]
end
