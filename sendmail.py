import smtplib, time, sys, os, datetime
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email.Utils import COMMASPACE, formatdate
from email import Encoders

def SendMsg(to, subject, text, files=[]):
    from_str = "DFB Backup <webmaster@falklandsbiographies.org>"
    msg = MIMEMultipart()
    msg['From'] = from_str
    msg['To'] = COMMASPACE.join(to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject
    msg.attach( MIMEText(text) )
    for file in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(file,"rb").read() )
        Encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"'
                       % os.path.basename(file))
        msg.attach(part)
    smtp = smtplib.SMTP("smtp.webfaction.com",587)
    smtp.login(os.environ['SMTP_USER'], os.environ['SMTP_PASSWORD'])
    smtp.sendmail(from_str, to, msg.as_string() )
    smtp.close()

SendMsg([os.environ['BACKUP_EMAIL']],"DFB backup","DFB backup", [sys.argv[1]] )
