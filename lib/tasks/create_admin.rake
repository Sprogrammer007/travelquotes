namespace :db do
	desc "Create default admin account"
  task createadmin: :environment do
  	AdminUser.create!(email: "stevenag006@hotmail.com",
                    password: "qwerty007",
                    password_confirmation: "qwerty007")

  	c = Company.create!(name: 'Chartis Guard Chartis',
  									short_hand: 'Chartis',
  									logo: 'tic.png',
  									status: true)

  	p = c.products.create!(name: "Chartis Gold Plan", product_number: "444070P1-P604/12",
  	description: "Chartis Gold (Age 0-59, Ins Sum 150,000)
No Coverage for Pre-Existing Conditions for ages 50+
Family Rates (max 5 children)", status: true, company_id: 1 )

  	p.plans.create!(:product_id => 1, unique_id: "309-523-4", type: "Visitor", can_buy_after_30_days: true )
	end
end