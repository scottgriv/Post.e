#!/Library/Frameworks/Python.framework/Versions/3.11/bin/python3
# print("Content-Type: text/html\n")
import pymysql.cursors

try:
    from configparser import ConfigParser
except ImportError:
    from ConfigParser import ConfigParser  # ver. < 3.0

# instantiate
config = ConfigParser()

# parse existing ini file
config.read('../../resources/config/config.ini')

# read values from ini file
db_host = config.get('database', 'db_host')
db_name = config.get('database', 'db_name')
db_user = config.get('database', 'db_user')
db_pass = config.get('database', 'db_pass')

# Connect to the database
connection = pymysql.connect(host=db_host,
                             user=db_user,
                             password=db_pass,
                             database=db_name,
                             cursorclass=pymysql.cursors.DictCursor)
               
                             
with connection:
    with connection.cursor() as cursor:
    
        # Read a single record
        sql = "SELECT User_ID, User_Name FROM USER WHERE User_ID = %s"
        cursor.execute(sql, ('1'))

# loop through each row    
for row in cursor.fetchall():

    # output row results
    print(row)
    # print("<br>")