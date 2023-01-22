require 'mysql2'

client = Mysql2::Client.new(hostname: 'localhost', username: 'root', password: '', database: 'post.e')

list = client.query("SELECT User_ID, User_Name FROM USER WHERE User_ID = 1")
list.each do |item|
    puts item
end