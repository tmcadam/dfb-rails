require 'json'
require 'nokogiri'

elements = Nokogiri::XML(File.open("print.xml")).css "text"

count = 0
captions = {}
strings = []
elements.each_with_index do |element, index|
    if element['font'] == "11" and element['height'] == "18" and element.child.name == "i" #and elements[index].child.name == "b"
        strings.push(element.child.text)
        next_element = elements[index+1]
        if next_element['font'] == "13" and next_element['height'] == "18"
            caption = strings.join(" ")
            caption = caption.gsub("  ", " ").gsub("  ", " ")
            links = caption.scan(/\b[A-Z]+\b/)
            if next_element.child.text.to_i == 34 and caption == "Pioneer."
                captions[33] = caption
            else
                captions[next_element.child.text.to_i] = caption
            end
            strings = []
        end
    end
end

file = File.read('images.json')
imgs = JSON.parse(file)
imgs.each do |img|
      img["caption"] = captions[img["id"]]
      puts img
end

File.open("images-captions.json", "w") do |f|
   f.write(JSON.pretty_generate(imgs))
end
