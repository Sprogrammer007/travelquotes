ActiveAdmin.register StudentSingleDetail do

  include_import

  menu :parent => "Super Admin", :if => proc{ current_admin_user.email == "stevenag006@hotmail.com" }

end
