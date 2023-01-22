use DBI;

$database = "post.e";
$host = "localhost";
$port = "3306";
$user = "root";
$pw = "";

$dsn = "dbi:MariaDB:$database:$host:$port";

my $DBH=DBI->connect("DBI:MariaDB:post.e:localhost:3306","root","")
	or die "Couldn't connect to database: " . DBI->errstr;

my $sth=$DBH->prepare("SELECT User_ID, User_Name FROM USER WHERE User_ID = 1");
$sth->execute();
while (my @row=$sth->fetchrow_array)
{
  print $row[0]."\n";
}

$sth->finish;