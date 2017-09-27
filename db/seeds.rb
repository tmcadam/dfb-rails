# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'

Biography.destroy_all

file = File.read('db/data-cleanup/bios.json')
bios = JSON.parse(file)

bios.each do |bio|
    Biography.create(   id: bio["id"],
                        title: bio["title"],
                        lifespan: bio["lifespan"],
                        body: bio["body"],
                        authors: bio["author"],
                        slug: bio["slug"] )
    puts bio["title"]
end
