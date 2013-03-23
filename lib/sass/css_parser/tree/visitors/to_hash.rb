# A visitor for converting a Sass tree into a hash.
class Sass::Tree::Visitors::ToHash < Sass::Tree::Visitors::Base
  protected

  def visit(node)
    super
  end

  def visit_root(node)
    rules = []
    node.children.each do |child|
      rule_hash = visit(child)
      rules << rule_hash unless rule_hash.nil?
    end
    {stylesheet: {rules: rules}}
  end

  def visit_charset(node)
    {charset: "\"#{node.name}\""}
  end 

  def visit_comment(node)
  end

  def visit_directive(node)
    was_in_directive = @in_directive
    @in_directive = @in_directive || !node.is_a?(Sass::Tree::MediaNode)

    name = node.value[1]
    directive = node.name.gsub('@', '')
    result = []
    node.children.each do |child|
      result << visit(child)
    end

    {
      name: name,
      :"#{directive}" => result
    }
  ensure
    @in_directive = was_in_directive
  end

  def visit_media(node)
    str = visit_directive(node)
    str.gsub!(/\n\Z/, '') unless node.style == :compressed || node.group_end
    str
  end

  def visit_supports(node)
    visit_media(node)
  end

  def visit_cssimport(node)
    visit_directive(node)
  end

  def visit_prop(node)
    {
      property: node.name[0],
      value: node.value.to_sass
    }
  end

  def visit_rule(node)
    declarations = []
    node.children.each do |child|
      child_hash = visit(child)
      declarations << child_hash unless child_hash.nil?
    end

    {
      selectors: node.parsed_rules.to_a,
      declarations: declarations
    }
  end
end

