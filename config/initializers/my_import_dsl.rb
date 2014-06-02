module ActiveAdminImport
  module MYDSL
    def include_import
      active_admin_import(:validate => false, 
        :template => 'admins/import',
        :timestamps => true,
        :template_object => ActiveAdminImport::Model.new(
          :hint => "Note: File will be imported with such header format: [#{config.resource_class::DEFAULT_HEADER.join(', ')}]. 
          If \"With Out Headers\" is choosen",
          :csv_options => {:col_sep => ",", :row_sep => nil, :quote_char => nil} 
          ),
        :before_import => proc{ |importer| 
          importer.options[:resource_class].delete_all()
          ActiveRecord::Base.connection.reset_pk_sequence!(importer.options[:resource_class].to_s
                                                            .gsub(/([a-z])([A-Z])/ , '\1_\2').downcase.pluralize) #Reset all id to 0
          header = importer.model.headers_option.empty? ? importer.options[:resource_class]::DEFAULT_HEADER : []
          importer.instance_variable_set(:@headers, header)
          },
        :batch_size => 1000
        )
    end
  end
end

::ActiveAdmin::DSL.send(:include, ActiveAdminImport::MYDSL)

