# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Deleting existing roles..."
roles = Role.all
roles.each{ |role| role.destroy } if roles.present?

puts "Creating roles..."
%w(admin webmaster emploer job_seeker).each do |name|
	Role.create!(:name => name)
end

puts "Deleting existing categorties..."
categories = Category.all
categories.each{ |category| category.destroy } if categories.present?

puts "Creating categories..."
%w(Accounting/Finance Administrative/Clerical Business/Strategic_Management Building Construction/Skilled_Trades Creative/Design
Customer_Support/Client_Care Editorial/Writing Engineering Food_Services/Hospitality Human_Resources Installation/Maintenance/Repair
IT/Software_Development Legal Logistics/Transportation Marketing/Product Medical/Health Production/Operations Project/Program_Management
Quality_Assurance/Safety R_D/Science Sales/Business_Development Security/Protective_Services Training/Instruction Other).each do |name|
	Category.create!(:name => name)
end

