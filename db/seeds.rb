# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
#
require 'rubygems'
unless defined? JRUBY_VERSION
  require 'parseexcel'
end

puts "Deleting existing roles..."
roles = Role.all
roles.each { |role| role.destroy } if roles.present?
#
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

puts "Creating a JobSeeker user....."
user1 = User.new(:name                  => "JobSeeker",
                 :email                 => "jobseeker@futurcadre.com",
                 :password              => "123456",
                 :password_confirmation => "123456"
)
user1.roles << Role.find_by_name("job_seeker")
user1.skip_confirmation!
user1.save!

user2 = User.new(:name                  => "Employer",
                 :email                 => "employer@futurcadre.com",
                 :password              => "123456",
                 :password_confirmation => "123456",
                 :package_id            => "3",
                 :avail_jobs            => "30",
                 :avail_search          => "30",
                 :used_searches         => "0",
                 :used_jobs             => "0"
)
user2.roles << Role.find_by_name("employer")
user2.skip_confirmation!
user2.save!

puts "Deleting existing categorties..."
categories = Category.all
categories.each { |category| category.destroy } if categories.present?

puts "Creating categories..."
%w(Accounting/Finance Administrative/Clerical Business/Strategic_Management Building Construction/Skilled_Trades Creative/Design
#Customer_Support/Client_Care Editorial/Writing Engineering Food_Services/Hospitality Human_Resources Installation/Maintenance/Repair
#IT/Software_Development Legal Logistics/Transportation Marketing/Product Medical/Health Production/Operations Project/Program_Management
#Quality_Assurance/Safety R_D/Science Sales/Business_Development Security/Protective_Services Training/Instruction Other).each do |name|
  Category.create!(:name => name.humanize.titleize, :category_type => 1)
end

puts "Deleting existing company sectors ..."
sectors = Sector.all
sectors.each { |sectors| sectors.destroy } if sectors.present?

puts "Creating sectors..."
%w(Banque/Assurance BTP Distribution Immobilier Industries Info/Télécom/Internet Public/Collectivités Services).each do |name|
  Sector.create!(:value => name.humanize.titleize)
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

puts "Deleting existing Jobs"
jobs = Job.all
jobs.each { |job| job.destroy } if jobs.present?
puts "creating Jobs"
(0 .. 10).each do |i|
  job = Job.create!(:name          => "testJob#{i}",
                    :description   => "As we look to expand, JPP is seeking a well-organized, extremely self-motivated individual to help with the office management and day-to-day running of the office. The successful candidate will be someone who takes initiative, identifies problems and provides solutions and is able to work well under pressure. He or she will be able to multi-task and work with a team of investigators and lawyers to drive forward JPP's challenging, but rewarding, mission.",
                    :country       => Country.find(24),
                    :region        => Region.find_by_country_id(24),
                    :city          => City.first,
                    :employer      => User.first,
                    :category      => Category.first,
                    :date_of_start => Time.now,
                    :annual_salary => 1345,
                    :skills         => "IT Management",
                    :sector         => Sector.first

  )


end


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


puts 'Creating Initial Profile......'
Profile.create!(:first_name => "Future",
                :last_name  => "Cadre",
                :country    => Country.first,
                :region     => Region.first,
                :city       => City.first,
                :user       => User.first,
                :zip_code   => "SW450",
                :phone      => "046-5673542",
                :address    => "Kungshamra 42, LGH 4"

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
groups = Group.create!([{ :name => 'Software Developers', :description => "Group for Software Developers e.g. C#, .Net, ROR and Java", :featured => true, :owner => User.first, :group_type => GroupType.first, :mean_salary => 24000 },
                        { :name => 'Electrical Engineers', :description => "Group for EE Engineers e.g. electro, power, hydro, control ", :featured => true, :owner => User.first, :group_type => GroupType.first, :mean_salary => 22000 },
                        { :name => 'Social Responsibility', :description => "Discussion place for Social responsibility ", :featured => true, :owner => User.first, :group_type => GroupType.first, :mean_salary => 32000 },
                       ])
groups.each do |group|
  group.jobs << Job.find_by_name("testJob0")
end
puts "updating photo of group"
groups.each do |group|
  group_photo              = Photo.new
  group_photo.image        = File.open(Rails.root.join('app/assets/images/logo.png'))
  group_photo.imageable    = group
  group_photo.content_type = "group_image"
  group_photo.save
end


puts "Deleting existing school categorties..."
school_categories = SchoolCategory.all
school_categories.each { |s_category| s_category.destroy } if school_categories.present?

puts "Creating school categories..."
%w(Engineering_School Business_School Technical_School Polytechnic University).each do |name|
  SchoolCategory.create!(:name => name.humanize.titleize)
end


puts "Deleting existing question categorties..."
question_categories = QuestionCategory.all
question_categories.each { |q_category| q_category.destroy } if question_categories.present?

puts "Creating question categories..."
%w(Career Salary Job_Contract University Other).each do |name|
  QuestionCategory.create!(:name => name.humanize.titleize)
end

puts "Deleting existing contracts ..."
contracts = Contract.all
contracts.each { |contract| contract.destroy } if contracts.present?

puts "Creating contracts..."
%w(CDD CDI Freelance Interim Stage VIE Job_etudiant).each do |name|
  Contract.create!(:name => name.humanize.titleize)
end

puts "Deleting existing durations ..."
durations = Period.all
durations.each { |duration| duration.destroy } if durations.present?

puts "Creating durations..."
%w(3_mois +3_mois 6_mois 12_mois +12_mois).each do |name|
  Period.create!(:name => name.humanize.titleize)
end

puts "Deleting existing languages ..."
languages = Language.all
languages.each { |languages| languages.destroy } if languages.present?

puts "Creating languages..."
%w(Anglais Arabe Basque Bengali Bulgare Danois Espagnol Estonien Finnous Français Grec Hindi Hongrois Italien
#Letton Lituanien Mandarin Néerlandais Polonais Portugais Roumain Russe Slovaque Slovène Suedois Tcheque).each do |name|
  Language.create!(:value => name.humanize.titleize)
end
#


puts "updating Job contact and Period"

jobs      = Job.all
@contract = Contract.first
@period   = Period.first
jobs.each do |job|
  job.update_attributes(:contract_id => @contract, :period_id => @period)
end


puts "Creating a subcategory"
(0 .. 2).each do |i|
  Category.create!(:name      => "Scripting/ShortHand",
                   :parent_id => 2
  )

end

puts "Creating thesis categories..."
%w(Accounting Finance Business/Strategic_Management Creative/Design Engineering Hospitality Human_Resources IT/Software_Development Marketing/Product Medical/Health Production/Operations Project/Program_Management
R_D/Science /Instruction Other).each do |name|
  Category.create!(:name => name.humanize.titleize, :category_type => 2)
end


puts 'Deleting existing Thesis......'
theses = Thesis.all

theses.each { |thesis| thesis.destroy } if theses.present?
puts "creating Thesis"
theses = Thesis.create!([{ :name => 'Software Development Life Cycle1', :description => "Group for Software Developers e.g. C#, .Net, ROR and Java", :owner => User.first, :category => Category.find_by_id(32), :no_of_pages => 150, :date_of_publish => Time.now, :category => Category.first, :no_of_pages => 123 },
                         { :name => 'Software Development Life Cycle2', :description => "Group for Software Developers e.g. C#, .Net, ROR and Java", :owner => User.first, :category => Category.find_by_id(32), :no_of_pages => 150, :date_of_publish => Time.now, :category => Category.first, :no_of_pages => 123 },
                         { :name => 'Software Development Life Cycle3', :description => "Group for Software Developers e.g. C#, .Net, ROR and Java", :owner => User.first, :category => Category.find_by_id(32), :no_of_pages => 150, :date_of_publish => Time.now, :category => Category.first, :no_of_pages => 123 },
                        ])

puts "updating document of thesis"
theses.each do |thes|
  thesis              = Photo.new
  thesis.image        = File.open(Rails.root.join('app/assets/images/test.pdf'))
  thesis.imageable    = thes
  thesis.content_type = "thesis_publication"
  thesis.save
end

puts "Delete existing education level"
education_levels = EducationLevel.all
education_levels.each { |ed| ed.destroy } if education_levels.present?
puts "Creating education level "
%w(Ecole_d_ingénieur Ecole_de_Commerce Ecoles/Universités Etrangères IEP IUT Lycée Université x-Autre).each do |name|
  EducationLevel.create!(:name => name.humanize.titleize)
end

puts "updating group ratings"
groups = Group.all
groups.each do |group|
  rating          = Rating.new
  rating.rate     = '2'
  rating.rateable = group
  rating.save!
end

puts "Deleting existing News Categories ..."
news_categories = NewsCategory.all
news_categories.each { |news_category| news_category.destroy } if news_categories.present?

puts "Creating News Categories..."
%w(Stock_exchange Economy Interviews Job Advising).each do |name|
  NewsCategory.create!(:name => name.humanize.titleize)
end


puts "deleting existing news"
news = News.all
news.each { |new| new.destroy } if news.present?
puts "creating news "
(0 .. 4).each do |i|
  News.create!(:title            => "Big Bang#{i}",
               :body             => "As we look to expand, JPP is seeking a well-organized, extremely self-motivated individual to help with the office management and day-to-day running of the office. The successful candidate will be someone who takes initiative, identifies problems and provides solutions and is able to work well under pressure. He or she will be able to multi-task and work with a team of investigators and lawyers to drive forward JPP's challenging, but rewarding, mission.",
               :is_approved      => true,
               :news_category_id => NewsCategory.first
  )
end
puts "updating news ratings"
news = News.all
news.each do |new|
  rating          = Rating.new
  rating.rate     = '2'
  rating.rateable = new
  rating.save!
end

puts "updating picture of the news"
news = News.all
news.each do |n_news|
  n_news              = Photo.new
  n_news.image        = File.open(Rails.root.join('app/assets/images/logo.png'))
  n_news.imageable    = n_news
  n_news.content_type = "news_picture"
  n_news.save
end

puts 'Deleting existing packages......'
packages = Package.all

packages.each { |package| package.destroy } if packages.present?
puts 'Creating Initial Package......'
Package.create!([{ :name           => "Basic",
                   :description    => "this is basic package",
                   :price          => "30",
                   :no_of_jobs     => "1",
                   :no_of_searches => "1",
                   :start_date     => Time.now,
                   :expiry_date    => Time.now+30.days },
                 { :name           => "Advance",
                   :description    => "this is advance package",
                   :price          => "60",
                   :no_of_jobs     => "10",
                   :no_of_searches => "10",
                   :start_date     => Time.now,
                   :expiry_date    => Time.now+60.days },
                 { :name           => "FuLL",
                   :description    => "this is Full package",
                   :price          => "90",
                   :no_of_jobs     => "30",
                   :no_of_searches => "30",
                   :start_date     => Time.now,
                   :expiry_date    => Time.now+90.days }]
)


puts 'Creating Initial Company Information......'
CompanyInformation.create!(:name        => "Future Cadre",
                           :profile     => Profile.first,
                           :email       => "webmaster@futurcadre.com",
                           :country     => Country.first,
                           :region      => Region.first,
                           :city        => City.first,
                           :phone       => "0456782144",
                           :address     => "France",
                           :web_site    => "www.futurecadre.com",
                           :sector      => Sector.first,
                           :description => "This is a test profile for a future cadre"

)






