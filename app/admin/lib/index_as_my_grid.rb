module ActiveAdmin
  module Views
    class IndexAsGrid < ActiveAdmin::Component


      def build_table
        table do
          collection.in_groups_of(number_of_columns).each do |group|
            build_row(group)
          end
        end
      end
    end
  end
end