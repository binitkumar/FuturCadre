# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
puts "Deleting existing roles..."
roles = Role.all
roles.each { |role| role.destroy } if roles.present?

puts "Creating roles..."
%w(webmaster employer job_seeker group_manager).each do |name|
  Role.create!(:name => name)
end

puts "Deleting existing users.."
users = User.all
users.each { |user| user.destroy } if users.present?

puts "Creating default webmaster user...."
user = User.new(:name                  => "WebMaster",
                :email                 => "webmaster@futurcadre.com",
                :password              => "123456",
                :password_confirmation => "123456"
)
user.roles << Role.find_by_name("webmaster")
user.skip_confirmation!
user.save!

puts "Deleting existing categorties..."
categories = Category.all
categories.each { |category| category.destroy } if categories.present?

puts "Creating categories..."
%w(Accounting/Finance Administrative/Clerical Business/Strategic_Management Building Construction/Skilled_Trades Creative/Design
Customer_Support/Client_Care Editorial/Writing Engineering Food_Services/Hospitality Human_Resources Installation/Maintenance/Repair
IT/Software_Development Legal Logistics/Transportation Marketing/Product Medical/Health Production/Operations Project/Program_Management
Quality_Assurance/Safety R_D/Science Sales/Business_Development Security/Protective_Services Training/Instruction Other).each do |name|
  Category.create!(:name => name.humanize.titleize)
end


(0 .. 10).each do |i|
  Job.create!(:name        => "testJob#{i}",
              :description => "As we look to expand, JPP is seeking a well-organized, extremely self-motivated individual to help with the office management and day-to-day running of the office. The successful candidate will be someone who takes initiative, identifies problems and provides solutions and is able to work well under pressure. He or she will be able to multi-task and work with a team of investigators and lawyers to drive forward JPP's challenging, but rewarding, mission.",
              :country     => Country.first,
              :region      => Region.first,
              :city        => City.first,
              :employer    => User.first,
              :category    => Category.first
  )
end

puts "Deleting existing skills..."
skills = Skill.all
skills.each { |skill| skill.destroy } if skills.present?
puts "creating Skills"
skills = Skill.create!([{ :name => 'Self Motivated' },
                        { :name => 'Well Organized' },
                        { :name => 'Social' },
                        { :name => 'Excellent Communication Skills' },
                        { :name => 'Self Driven' },
                        { :name => 'Leadership' }])


puts "Deleting existing responsibilities..."
resps = Responsibility.all
resps.each { |resps| resps.destroy } if resps.present?
puts "creating responsibilities"
resps = Responsibility.create!([{ :name => 'Manage' },
                                { :name => 'Reception' },
                                { :name => 'Social' },
                                { :name => 'Software Development' },
                                { :name => 'Team Management' },
                                { :name => 'Leadership' }])

#puts "Deleting existing schools..."
#schools = School.all
#schools.each { |sch| sch.destroy } if schools.present?
#puts "creating schools"
#schools = School.create!([{ :name => 'KTH' },
#                        { :name => 'Lund'},
#                        { :name => 'Chalmers' },
#                        { :name => 'PUCIT'},
#                        { :name => 'ILM'},
#                        { :name => 'UMTS' }])

puts 'Creating Initial Profile......'
Profile.create!(:first_name => "Future",
                :last_name  => "Cadre",
                :country    => Country.first,
                :region     => Region.first,
                :city       => City.first,
                :user       => User.first,
                :zip_code   => "SW450",
                :phone      => "0046787343",
                :address    => "Kungshamra 42, LGH 4"

)
puts 'Creating Initial Company Information......'
CompanyInformation.create!(:name     => "Future Cadre",
                           :profile  => Profile.first,
                           :email    => "webmaster@futurcadre.com",
                           :country  => Country.first,
                           :region   => Region.first,
                           :city     => City.first,
                           :phone    => "000000000",
                           :address  => "France",
                           :web_site => "www.futurecadre.com"

)


puts 'Deleting existing groups_type......'
group_types = GroupType.all

group_types.each { |groupt| groupt.destroy } if group_types.present?
puts "creating Group_Types"
group_types = GroupType.create!([{ :name => 'Job', :description => "Group for Job Discussion" },
                                 { :name => 'School', :description => "Group for School Discussion " }

                                ])


puts 'Deleting existing groups......'
groups = Group.all

groups.each { |group| group.destroy } if groups.present?
puts "creating Groups"
groups = Group.create!([{ :name => 'Software Developers', :description => "Group for Software Developers e.g. C#, .Net, ROR and Java", :featured => true, :owner => User.first, :group_type => GroupType.first },
                        { :name => 'Electrical Engineers', :description => "Group for EE Engineers e.g. electro, power, hydro, control ", :featured => true, :owner => User.first, :group_type => GroupType.first },
                        { :name => 'Social Responsibility', :description => "Discussion place for Social responsibility ", :featured => true, :owner => User.first, :group_type => GroupType.first },
                       ])
groups.each do |group|
  group.jobs << Job.find_by_name("testJob0")
end

