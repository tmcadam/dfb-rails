#!/usr/bin/python
import httplib
import sys
import urlparse
import gzip
import StringIO
import json

service = 'http://html5.validator.nu/'
contentType = 'text/html; charset=utf-8'


def check_html(data):

    buf = StringIO.StringIO()
    gzipper = gzip.GzipFile(fileobj=buf, mode='wb')
    gzipper.write(data)
    gzipper.close()
    gzippeddata = buf.getvalue()
    buf.close()

    connection = None
    response = None
    status = 302
    redirectCount = 0

    url = service + '?out=text' + '&level=error'

    while (status == 302 or status == 301 or status == 307) and redirectCount < 10:
        if redirectCount > 0:
            url = response.getheader('Location')
        parsed = urlparse.urlsplit(url)
        if parsed[0] != 'http':
            sys.stderr.write('URI scheme %s not supported.\n' % parsed[0])
            sys.exit(7)
        if redirectCount > 0:
            connection.close() # previous connection
            print 'Redirecting to %s' % url
            print 'Please press enter to continue or type "stop" followed by enter to stop.'
            if raw_input() != "":
                sys.exit(0)
        connection = httplib.HTTPConnection(parsed[1])
        connection.connect()
        connection.putrequest("POST", "%s?%s" % (parsed[2], parsed[3]), skip_accept_encoding=1)
        connection.putheader("User-Agent",  "Tom88/1.0")
        connection.putheader("Accept-Encoding", 'gzip')
        connection.putheader("Content-Type", contentType)
        connection.putheader("Content-Encoding", 'gzip')
        connection.putheader("Content-Length", len(gzippeddata))
        connection.endheaders()
        connection.send(gzippeddata)
        response = connection.getresponse()
        status = response.status
        redirectCount += 1


    if status != 200:
        result = '%s %s\n' % (status, response.reason)
    else:
        result = response.read()
    connection.close()
    return result

with open("bios.json", "r") as json_file:
    bios_hash = json.load(json_file)

for bio_hash in bios_hash:
    if bio_hash["id"] > 280:
        data = '''<!DOCTYPE html><html><head><title>Page Title</title></head><body>{}</body></html>'''
        data = data.format(bio_hash['body'].encode('utf-8'))
        with open('bios-check.log', 'a') as out_file:
            lines = list()
            lines.append(str(bio_hash['id']) + ": " + bio_hash['title'].encode('utf8'))
            lines.append(check_html(data))
            lines.append("---------------------------------------------------------------------\n")
            out_file.writelines("\n".join(lines))
            print "\n".join(lines)
