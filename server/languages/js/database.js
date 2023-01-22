// Go To http://127.0.0.1:1337/

// Dependencies
var mysql = require("mysql"),
    http  = require("http");

var ini = require('ini')
var fs = require('fs')

// This holds our query results
path = require('path')

var results;

let configPath = path.join(__dirname, '../../resources/config/config.ini');
var config = ini.parse(fs.readFileSync(configPath, 'utf-8'))

// Connect to database
var connection = mysql.createConnection({
  host: config.database.db_host,
  user: config.database.db_user, 
  password: config.database.db_pass, 
  database: config.database.db_name
});
connection.connect(function(err) {
    if (err) throw err;
    console.log("Connected to Database");
});

//Query
var sql = `SELECT User_ID, User_Name FROM USER WHERE User_ID = ?`;

connection.query(sql, [1], function(err, rows, fields) {
    if (err) throw err;
    results = rows;
    connection.end(); // Disconnect from database
});

// Function to handle browser's requests
function requestHandler(req, res) {
   res.end(JSON.stringify(results, null, 4)); // Respond to request with a string
}

// Create a server
var server = http.createServer(requestHandler);
// That magic number 8080 over here is the port our server listens to.
// You can access this webpage by visiting address http://localhost:8080
server.listen(1337, function() { 
    console.log("Server Online");
});
