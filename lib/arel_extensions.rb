module Arel
  module Nodes
    class Contains < Arel::Nodes::Binary
      def operator
        "@>"
      end
    end

    class Overlaps < Arel::Nodes::Binary
      def operator
        "&&"
      end
    end
  end

  module Predications
    def contains(other)
      Nodes::Contains.new(self, quoted_node(other))
    end

    def overlaps(other)
      Nodes::Overlaps.new(self, quoted_node(other))
    end
  end

  module Visitors
    class PostgreSQL < Arel::Visitors::ToSql
      private

      def visit_Arel_Nodes_Contains(o, collector)
        infix_value(o, collector, " @> ")
      end

      def visit_Arel_Nodes_Overlaps(o, collector)
        infix_value(o, collector, " && ")
      end
    end
  end
end
