use ferris_says::say; // from the previous step
use std::io::{stdout, BufWriter};
use mysql::*;
use mysql::prelude::*;

#[derive(Debug, PartialEq, Eq)]
struct Post {
    id: i32,
    name: String,
}

fn main() {

    let stdout = stdout();
    let message = String::from("Post.e on Rust!!");
    let width = message.chars().count();

    let mut writer = BufWriter::new(stdout.lock());
    say(message.as_bytes(), width, &mut writer).unwrap();
    
    let url = "mysql://root:@localhost:3306/post.e";
    let pool = Pool::new(url).unwrap();
    let mut conn = pool.get_conn().unwrap();

    let select_all = conn.query_map(
        "SELECT User_ID, User_Name FROM USER WHERE User_ID = 1", |(id, name)| { Post { id, name } },
    );

    for row in select_all.iter().flatten() {
        println!("{} - {}", row.id, row.name);
    }
    
}