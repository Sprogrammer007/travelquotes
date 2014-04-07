ActiveAdmin.register Policy do
  
  menu :parent => "Companies"

  active_admin_import(:validate => false, 
    :template => 'import' ,
    :template_object => ActiveAdminImport::Model.new(
      :hint => "file will be imported with such header format: 'body','title','author'",
      :csv_headers => ["body","title","author"],
      :csv_options => {:col_sep => ";", :row_sep => nil, :quote_char => nil} 
      ),
    :csv_options => {:col_sep => "," },
    :before_import => proc{ Company.delete_all},
    :batch_size => 1000
    )
  
end
