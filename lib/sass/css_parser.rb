require 'sass'
require 'sass/css_parser/tree/visitors/to_hash'
require 'sass/css_parser/tree/node'

class Sass::CssParser
  def self.parse(css, syntax = :scss)
    Sass::Engine.new(css, :syntax => syntax).to_tree.to_h
  end
end

