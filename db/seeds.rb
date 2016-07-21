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
Category.create([{id: 3, title: "soda", parent_id: 2},
  {id: 4, title: "sea food", parent_id: 1}])
(1..10).each do |stt|
  Product.create(
    name: "sea #{stt}",
    price: (1 + stt),
    quantity: (10 + stt),
    category_id: 4)
end
(11..20).each do |stt|
  Product.create(
    name: "water #{stt}",
    price: stt,
    quantity: (stt + 10),
    category_id: 3)
end
