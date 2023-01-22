<?php
header('Content-type: application/json');

include("session.php"); //Include Session Handler

error_reporting(0); //Turn OFF error exceptions.

new MySessionHandler();

session_start();
$sesID = $_SESSION['UserSes'];

function Post_Query($sesID, $profID, $order, $limit, $offset) {

		$db = $GLOBALS['db'];

		$records = array();
		
		$query = $db->prepare("SELECT *,
							 				f_post_pin_flag(Post_ID, ?) AS Post_Pin_Flag,
							 				f_post_reply_flag(Post_ID, ?) AS Post_Reply_Flag,
							 				f_post_love_flag(Post_ID, ?) AS Post_Love_Flag
							 				FROM V_FEED 
							 				WHERE (Fol_Follower = ?)
							 				ORDER BY $order 
							 				LIMIT $limit 
							 				OFFSET $offset"
		);
		

		$query->execute([$sesID, $sesID, $sesID, $profID]);


		$rownum = $query->rowCount();

		if($rownum > 0) {
			
		while ($row2 = $query->fetch(PDO::FETCH_ASSOC)) {
			$records['post'][$row2['Post_ID']] = array(
				'post_ID' => intval($row2['Post_ID']),
				'post_key' => $row2['Post_Key'],
				'post_type' => $row2['Post_Type'] ? true : false,
				'post_prof_ID' => intval($row2['Post_Prof_ID']),
				'post_prof_user' => $row2['Post_Prof_User'],
				'post_prof_pic' => $row2['Post_Prof_Pic'],
				'post_post' => $row2['Post_Post'],
				'post_created' => $row2['Post_Created'],
				'post_attachment_count' => intval($row2['Post_Attachment_Count']),
				'post_pin_count' => intval($row2['Post_Pin_Count']),
				'post_reply_count' => intval($row2['Post_Reply_Count']),
				'post_love_count' => intval($row2['Post_Love_Count']),
				'post_pin_flag' => $row2['Post_Pin_Flag'] ? true : false,
				'post_reply_flag' => $row2['Post_Reply_Flag'] ? true : false,
				'post_love_flag' => $row2['Post_Love_Flag'] ? true : false,
				'post_prof_ID_ref' => intval($row2['Post_Prof_ID_Ref'])
			);

			$attachmentQuery = $db->prepare("SELECT 
  							  			  Attach_ID,
										  Attach_Key, 
										  Attach_Post_ID, 
										  Attach_File_Name,
										  Attach_File_Extension,
										  Attach_File_Size,
										  Attach_File_Path,
										  Attach_Created,
										  Attach_Modified
										  FROM   ATTACHMENT 
										  INNER  JOIN POST ON Attach_Post_ID = Post_ID
										  WHERE  Post_ID = ?
										  ORDER  BY Attach_ID ASC"
			);

			$attachmentQuery->execute([$row2['Post_ID']]);

			$rownum = $attachmentQuery->rowCount();

			if($rownum > 0) {

				while ($row3 = $attachmentQuery->fetch(PDO::FETCH_ASSOC)) {


					$records['post'][$row2['Post_ID']]['post_attachment'][] = array(
						'attachment_ID' => intval($row3['Attach_ID']),
						'attachment_key' => $row3['Attach_Key'],
						'attachment_post_ID' => intval($row3['Attach_Post_ID']),
						'attachment_file_name' => $row3['Attach_File_Name'],
						'attachment_file_extension' => $row3['Attach_File_Extension'],
						'attachment_file_size' => $row3['Attach_File_Size'],
						'attachment_file_path' => $row3['Attach_File_Path'],
						'attachment_created' => $row3['Attach_Created'],
						'attachment_modified' => $row3['Attach_Modified']

					);

				}

			}

		}

		$records['post'] = array_values($records['post']);

		foreach ($records as $key1 => $values1) {

			foreach ($values1 as $key2 => $values2) {

				foreach ($values2 as $key3 => $values3) {

					if($values3 === null) {

						unset($records[$key1][$key2][$key3]);
					}

				}
			}

		}

		    echo json_encode($records);
		
		} else {
		
		    echo json_encode(array("success" => 0, "error_message" => NULL));

		}

	}
	
switch($_POST["command"]){
			
	//Newest Posts Filter
	case $case = "FeedHome";
		
		    $profID = addslashes($_POST["profile_ID"]);
		    $limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Love_Count DESC, Post_Pin_Count DESC, Post_Reply_Count, Post_Created DESC';

		    Post_Query($sesID, $profID, $order, $limit, $offset);
		    
		    break;
			
	//Latest Posts Filter
	case $case = "FeedLatest";

			$profID = addslashes($_POST["profile_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);	
			$order = 'Post_Created DESC';
				
		    Post_Query($sesID, $profID, $order, $limit, $offset);
		
			break;
			
	//Remove Post
	case $case = "removePost";
	
			$post_ID = intval($_POST["post_ID"]);
			$type = $_POST["type"];

			$stmt = $db->prepare(
						   "DELETE 
			 	            FROM 
				            POST 
				            WHERE
				            Post_ID = ?"
							);
		
			$stmt->execute([$post_ID]);

			if ($stmt) {
			
				if ($type == "Reply") {
				
					$stmt = $db->prepare(
						   "DELETE 
			 	            FROM 
				            REPLY 
				            WHERE
				            Reply_Post_ID = ?"
							);
		
					$stmt->execute([$post_ID]);
					
					if ($stmt) {
			
						$response = array("success" => 1, "error_message" => NULL);

					} else {
					
						$response = array("success" => 0, "error_message" => "Error! There was a problem removing your Reply, please try again.");;

					}
				
				} else { 
			
					$response = array("success" => 1, "error_message" => NULL);
				
				}    
				
			} else {
			
			 	$response = array("success" => 0, "error_message" => "Error! There was a problem removing your Post, please try again.");;
			
			}
			
			echo json_encode($response);

	break;
		
	}

?>
