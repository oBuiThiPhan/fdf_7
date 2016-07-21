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
Category.create(id: 1, title: "root", level: 0, left_index: 0, right_index: 9)
Category.create(id: 2, title: "food", level: 1, left_index: 1, right_index: 4)
Category.create(id: 3, title: "drink", level: 1, left_index: 5, right_index: 8)
Category.create([{id: 4, title: "soda", level: 2, left_index: 6, right_index: 7},
  {id: 5, title: "sea food", level: 2, left_index: 2, right_index: 3}])
(1..10).each do |stt|
  Product.create(
    name: "sea #{stt}",
    price: (1 + stt),
    quantity: (10 + stt),
    category_id: 5)
end
(11..20).each do |stt|
  Product.create(
    name: "water #{stt}",
    price: stt,
    quantity: (stt + 10),
    category_id: 4)
end
