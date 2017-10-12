import csv
import json
import io

imgs = list()
with open('images.csv', 'rb') as csv_file:
    imgs_reader = csv.reader(csv_file, delimiter='@', quotechar="'")
    for row in imgs_reader:
        img = {
            "id": int(row[0]),
            "biography_id": int(row[1]),
            "title": row[2],
            "attribution": row[3]
        }
        imgs.append(img)

with io.open('images.json', 'w', encoding='utf8') as json_file:
    data = json.dumps(imgs, indent=4, ensure_ascii=False, encoding='utf8')
    json_file.write(unicode(data))
