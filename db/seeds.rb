# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'json'
require 'csv'

## Cleanup First
# StaticContent.destroy_all
# Image.destroy_all
# Biography.destroy_all
# Author.destroy_all
# BiographyAuthor.destroy_all

## Load static content
# StaticContent.create(   title: "Home",
#                         slug: "home",
#                         body: "<p>Some indroduction content here.</p>")
# StaticContent.create(   title: "Contacts",
#                         slug: "contacts",
#                         body: "<p>Some contact details here.</p>")
# StaticContent.create(   title: "About",
#                         slug: "about",
#                         body: "<p>Some information .</p>")

## Load bios
# file = File.read('db/data-cleanup/bios.json')
# bios = JSON.parse(file)
# bios.each do |bio|
#     Biography.create(   id: bio["id"],
#                         title: bio["title"],
#                         lifespan: bio["lifespan"],
#                         body: bio["body"],
#                         authors: bio["author"],
#                         slug: bio["slug"] )
#     puts "Bio: #{bio["title"]}"
# end

## Load images
# file = File.read('db/data-cleanup/images-captions.json')
# imgs = JSON.parse(file)
# imgs.each do |img|
#
#     base_file_name = "#{img['id']}".rjust(4, padstr='0')
#     path = "#{Rails.root}/db/data-cleanup/images/"
#
#     if Pathname(path + base_file_name + ".jpg" ).exist?
#         f = File.new(path + base_file_name + ".jpg")
#     elsif Pathname(path + base_file_name + ".png" ).exist?
#         f = File.new(path + base_file_name + ".png")
#     end
#     Image.create(   id: img["id"],
#                     biography_id: img["biography_id"],
#                     title: img["title"],
#                     caption: img["caption"],
#                     attribution: img["attribution"],
#                     image: f )
#     puts "Image: #{img["title"]}"
# end

## Load Authors
# csv_text = File.read('db/data-cleanup/authors.csv')
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#     Author.create(
#         id: row['id'],
#         first_name: row['first-name'],
#         last_name: row['last-name'],
#         biography: row['biography']
#     )
# end
# csv_text = File.read('db/data-cleanup/biography_authors.csv')
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#     BiographyAuthor.create(
#         biography_id: row['biography_id'],
#         author_id: row['author_id'],
#         author_position: row['author_position']
#     )
# end

csv_text = File.read('db/data-cleanup/countries.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
    Country.create(
        id: row['id'],
        name: row['name']
    )
end

puts "Bios: #{Biography.count}"
puts "Imgs: #{Image.count}"
puts "Authors: #{Author.count}"
puts "BioAuthors: #{BiographyAuthor.count}"
puts "Country: #{Country.count}"
# ActiveRecord::Base.connection.reset_pk_sequence!(Biography.table_name)
# ActiveRecord::Base.connection.reset_pk_sequence!(Image.table_name)
# ActiveRecord::Base.connection.reset_pk_sequence!(StaticContent.table_name)
# ActiveRecord::Base.connection.reset_pk_sequence!(Author.table_name)
# ActiveRecord::Base.connection.reset_pk_sequence!(BiographyAuthor.table_name)
ActiveRecord::Base.connection.reset_pk_sequence!(Country.table_name)
