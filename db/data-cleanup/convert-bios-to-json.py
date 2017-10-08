import csv
import json
import io

bios = list()
with open('bios.csv', 'rb') as csv_file:
    bios_reader = csv.reader(csv_file, delimiter=',', quotechar="'")
    for row in bios_reader:
        bio = {
            "id": int(row[0]),
            "title": row[1],
            "lifespan": row[2].replace("(", "").replace(")", ""),
            "body": row[3].replace("/biography/", "/biographies/"),
            "author": row[4],
            "south_georgia": int(row[5]),
            "alpha": row[6],
            "dob": int(row[7]) if int(row[7]) is not 9999 else None,
            "country_pri": int(row[8]),
            "country_sec": int(row[9]) if int(row[9]) is not int(row[8]) else None,
            "slug": row[10]
        }
        bios.append(bio)


with io.open('bios.json', 'w', encoding='utf8') as json_file:
    print bios[345]["title"]
    data = json.dumps(bios, indent=4, ensure_ascii=False, encoding='utf8')
    json_file.write(unicode(data))
