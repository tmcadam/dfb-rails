# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'

## Cleanup First
StaticContent.destroy_all
Image.destroy_all
Biography.destroy_all

## Load static content
StaticContent.create(   title: "Home",
                        slug: "home",
                        body: "<p>Some indroduction content here.</p>")
StaticContent.create(   title: "Contacts",
                        slug: "contacts",
                        body: "<p>Some contact details here.</p>")
StaticContent.create(   title: "About",
                        slug: "about",
                        body: "<p>Some information .</p>")

## Load bios
file = File.read('db/data-cleanup/bios.json')
bios = JSON.parse(file)
bios.each do |bio|
    Biography.create(   id: bio["id"],
                        title: bio["title"],
                        lifespan: bio["lifespan"],
                        body: bio["body"],
                        authors: bio["author"],
                        slug: bio["slug"] )
    puts "Bio: #{bio["title"]}"
end

## Load images
file = File.read('db/data-cleanup/images.json')
imgs = JSON.parse(file)
imgs.each do |img|
    Image.create(   id: img["id"],
                    biography_id: img["biography_id"],
                    title: img["title"],
                    caption: "todo",
                    attribution: img["attribution"],
                    image: File.new("#{Rails.root}/db/data-cleanup/images/test-jpgs/#{img["id"]}.jpg") )
    puts "Image: #{img["title"]}"
end
