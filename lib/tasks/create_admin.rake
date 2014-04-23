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

  	provinces = %w{Ontario Quebec Nova\ Scotia Alberta British\ Columbia}
  	provinces.each do |p|
  		c.provinces.create!(name: p, short_hand: 'ON')
  	end

  	p = c.products.create!(name: "Chartis Gold Plan", product_number: "444070P1-P604/12",
  	description: "Chartis Gold (Age 0-59, Ins Sum 150,000)
No Coverage for Pre-Existing Conditions for ages 50+
Family Rates (max 5 children)", can_buy_after_30_days: true, status: true, company_id: 1 )

  	p.plans.create!(:product_id => 1, unique_id: "random", type: "Visitor" )
	end
end