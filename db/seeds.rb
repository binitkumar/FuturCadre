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
%w(webmaster employer job_seeker).each do |name|
	Role.create!(:name => name)
end

puts "Deleting existing users.."
users = User.all
users.each{ |user| user.destroy } if users.present?

puts "Creating default webmaster user...."
user = User.new(:email => "webmaster@futurcadre.com",
  :password => "123456",
  :password_confirmation => "123456"
)
user.roles << Role.find_by_name("webmaster")
user.skip_confirmation!
user.save!

puts "Deleting existing categorties..."
categories = Category.all
categories.each{ |category| category.destroy } if categories.present?

puts "Creating categories..."
%w(Accounting/Finance Administrative/Clerical Business/Strategic_Management Building Construction/Skilled_Trades Creative/Design
Customer_Support/Client_Care Editorial/Writing Engineering Food_Services/Hospitality Human_Resources Installation/Maintenance/Repair
IT/Software_Development Legal Logistics/Transportation Marketing/Product Medical/Health Production/Operations Project/Program_Management
Quality_Assurance/Safety R_D/Science Sales/Business_Development Security/Protective_Services Training/Instruction Other).each do |name|
	Category.create!(:name => name.humanize.titleize )
end

( 0 .. 10).each do |i|
	Job.create!(:name => "testJob#{i}", :description => "As we look to expand, JPP is seeking a well-organized, extremely self-motivated individual to help with the office management and day-to-day running of the office. The successful candidate will be someone who takes initiative, identifies problems and provides solutions and is able to work well under pressure. He or she will be able to multi-task and work with a team of investigators and lawyers to drive forward JPP's challenging, but rewarding, mission.")
end

