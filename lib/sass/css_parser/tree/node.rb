module Sass
  module Tree
    class Node
      def to_h
        Sass::Tree::Visitors::ToHash.visit(self)
      end
    end
  end
end
