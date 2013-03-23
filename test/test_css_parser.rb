require File.expand_path(File.dirname(__FILE__) + '/test_helper')

module Sass
  class CssParserTests < MiniTest::Unit::TestCase
    def test_parser
      Dir.foreach(File.join(File.dirname(__FILE__), 'cases')) do |file|
        next if file.index('json').nil?

        file = File.basename(file, '.json')

        css = File.read(File.join(File.dirname(__FILE__), 'cases', file + '.css'))
        json = File.read(File.join(File.dirname(__FILE__), 'cases', file + '.json'))

        assert_equal(JSON.parse(json, symbolize_names: true), Sass::CssParser.parse(css))
      end
    end
  end
end
