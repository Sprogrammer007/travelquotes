# It extends activeadmin to show pretty boolean values
# 
# config/initializers/active_admin.rb
 
module ActiveAdmin
  module Views
    class TableFor
      def bool_column(attribute)
        column(attribute){ |model| model[attribute] ? '&#x2714;'.html_safe : '&#x2717;'.html_safe }
      end
    end
    class AttributesTable
      def bool_row(attribute)
        row(attribute){ |model| model[attribute] ? '&#x2714;'.html_safe : '&#x2717;'.html_safe }
      end
    end
  end
end