Class.forName( "com.mysql.jdbc.driver" );

Connection conn = DriverManager.getConnection(
 "jdbc:mysql://localhost/post.e",
 "root",
 "" );
try {
     Statement stmt = conn.createStatement();
try {
    ResultSet rs = stmt.executeQuery( "SELECT User_ID, User_Name FROM USER WHERE User_ID = 1" );
    try {
        while ( rs.next() ) {
            int numColumns = rs.getMetaData().getColumnCount();
            for ( int i = 1 ; i <= numColumns ; i++ ) {
               // Column numbers start at 1.
               // Also there are many methods on the result set to return
               //  the column as a particular type. Refer to the Sun documentation
               //  for the list of valid conversions.
               System.out.println( "COLUMN " + i + " = " + rs.getObject(i) );
            }
        }
    } finally {
        try { rs.close(); } catch (Throwable ignore) { /* Propagate the original exception
instead of this one that you may want just logged */ }
    }
} finally {
    try { stmt.close(); } catch (Throwable ignore) { /* Propagate the original exception
instead of this one that you may want just logged */ }
}
} finally {
    //It's important to close the connection when you are done with it
    try { conn.close(); } catch (Throwable ignore) { /* Propagate the original exception
instead of this one that you may want just logged */ }
}