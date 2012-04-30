# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new(:first_name => "Admin", :last_name => "Toast", :privilege => "admin", :email => "admin")
admin.active = true
admin.verified = true
admin.set_encrypted_password("111111")
admin.save
