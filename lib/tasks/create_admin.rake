namespace :db do
	desc "Create default admin account"
  task createadmin: :environment do
  	AdminUser.create!(email: "stevenag006@hotmail.com",
                    password: "qwerty007",
                    password_confirmation: "qwerty007")
  end
end