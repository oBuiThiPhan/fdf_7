# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(name: "admin",
            email: "admin@gmail.com",
            role: 2,
            password: "123456789")
Category.create(id: 1, title: "food", parent_id: nil)
Category.create(id: 2, title: "drink", parent_id: nil)
Category.create([{title: "soda", parent_id: 2},
  {title: "sea food", parent_id: 1}])
