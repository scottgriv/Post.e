<?php
header('Content-type: application/json');

include("session.php"); //Include Session Handler

error_reporting(E_ALL); //Turn OFF error exceptions.

new MySessionHandler();

session_start();
$sesID = $_SESSION['UserSes'];

$db = $GLOBALS['db'];

function delete_directory($dirname) {
   if (is_dir($dirname))
      $dir_handle = opendir($dirname);
   if (!$dir_handle)
      return false;
   while($file = readdir($dir_handle)) {
      if ($file != "." && $file != "..") {
         if (!is_dir($dirname."/".$file))
            unlink($dirname."/".$file);
         else
            delete_directory($dirname.'/'.$file);    
      }
   }
   closedir($dir_handle);
   rmdir($dirname);
   return true;
}

function Post_Query($sesID, $profID, $order, $limit, $offset) {

		$db = $GLOBALS['db'];

		$records = array();
		$profRecords = array();

		$profQuery = $db->prepare("SELECT Prof_ID,
    									  Prof_Key,
    									  Prof_User,
    									  Prof_Name,
    									  Prof_Pic,
										  Prof_Follower_Count,
										  Prof_Following_Count,
										  Prof_Post_Count,
										  f_follow_flag(?, ?) AS Prof_Follow_Flag
										  FROM V_PROFILE 
										  WHERE Prof_ID = ? LIMIT 1"
		);

		$profQuery->execute([$profID, $sesID, $profID]);

		while ($row = $profQuery->fetch(PDO::FETCH_ASSOC)) {
			$profRecords['header'][] = array(
				'profile_ID' => intval($row['Prof_ID']),
				'profile_key' => $row['Prof_Key'],
				'profile_user' => $row['Prof_User'],
				'profile_name' => $row['Prof_Name'],
				'profile_pic' => $row['Prof_Pic'],
				'profile_follower_count' => intval($row['Prof_Follower_Count']),
				'profile_following_count' => intval($row['Prof_Following_Count']),
				'profile_post_count' => intval($row['Prof_Post_Count']),
				'profile_follow_flag' => $row['Prof_Follow_Flag'] ? true : false

			);


		}


		foreach ($profRecords as $profKey1 => $profValues1) {

			foreach ($profValues1 as $profKey2 => $profValues2) {

				foreach ($profValues2 as $profKey3 => $profValues3) {

					if($profValues3 == null) {

						unset($profRecords[$profKey1][$profKey2][$profKey3]);
					}
				}
			}

		}

		$query = $db->prepare("SELECT *,
							 				f_post_pin_flag(Post_ID, ?) AS Post_Pin_Flag,
							 				f_post_reply_flag(Post_ID, ?) AS Post_Reply_Flag,
							 				f_post_love_flag(Post_ID, ?) AS Post_Love_Flag
							 				FROM V_POST WHERE 
							 				Post_Prof_ID = ?
							 				AND Post_Type <> 2
							 				ORDER BY $order LIMIT $limit OFFSET $offset"
		);

		$query->execute([$sesID, $sesID, $sesID, $profID]);


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

        $records['post'] = is_array($records['post'])? array_values($records['post']): array();   

		foreach ($records as $key1 => $values1) {

			foreach ($values1 as $key2 => $values2) {

				foreach ($values2 as $key3 => $values3) {

					if($values3 === null) {

						unset($records[$key1][$key2][$key3]);
					}

				}
			}

		}

		echo json_encode(array_merge($profRecords, $records));

	}

function Reply_Query($sesID, $postID, $order, $limit, $offset) {

		$db = $GLOBALS['db'];

		$records = array();
		$replyRecords = array();
		
		$replyQuery = $db->prepare("SELECT *,
							 				f_post_pin_flag(Post_ID, ?) AS Post_Pin_Flag,
							 				f_post_reply_flag(Post_ID, ?) AS Post_Reply_Flag,
							 				f_post_love_flag(Post_ID, ?) AS Post_Love_Flag
							 				FROM V_POST WHERE 
							 				Post_ID = ?
							 				ORDER BY $order LIMIT 1"
		);

		$replyQuery->execute([$sesID, $sesID, $sesID, $postID]);
		
		while ($row = $replyQuery->fetch(PDO::FETCH_ASSOC)) {
			$replyRecords['header'][$row['Post_ID']] = array(
				'post_ID' => intval($row['Post_ID']),
				'post_key' => $row['Post_Key'],
				'post_type' => $row['Post_Type'] ? true : false,
				'post_prof_ID' => intval($row['Post_Prof_ID']),
				'post_prof_user' => $row['Post_Prof_User'],
				'post_prof_pic' => $row['Post_Prof_Pic'],
				'post_post' => $row['Post_Post'],
				'post_created' => $row['Post_Created'],
				'post_attachment_count' => intval($row['Post_Attachment_Count']),
				'post_pin_count' => intval($row['Post_Pin_Count']),
				'post_reply_count' => intval($row['Post_Reply_Count']),
				'post_love_count' => intval($row['Post_Love_Count']),
				'post_pin_flag' => $row['Post_Pin_Flag'] ? true : false,
				'post_reply_flag' => $row['Post_Reply_Flag'] ? true : false,
				'post_love_flag' => $row['Post_Love_Flag'] ? true : false,
				'post_prof_ID_ref' => intval($row['Post_Prof_ID_Ref'])
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

			$attachmentQuery->execute([$row['Post_ID']]);

			$rownum = $attachmentQuery->rowCount();

			if($rownum > 0) {

				while ($row4 = $attachmentQuery->fetch(PDO::FETCH_ASSOC)) {


					$replyRecords['header'][$row['Post_ID']]['post_attachment'][] = array(
						'attachment_ID' => intval($row4['Attach_ID']),
						'attachment_key' => $row4['Attach_Key'],
						'attachment_post_ID' => intval($row4['Attach_Post_ID']),
						'attachment_file_name' => $row4['Attach_File_Name'],
						'attachment_file_extension' => $row4['Attach_File_Extension'],
						'attachment_file_size' => $row4['Attach_File_Size'],
						'attachment_file_path' => $row4['Attach_File_Path'],
						'attachment_created' => $row4['Attach_Created'],
						'attachment_modified' => $row4['Attach_Modified']

					);

				}

			}

		}

		$replyRecords['header'] = array_values($replyRecords['header']);

		foreach ($replyRecords as $replyKey1 => $replyValues1) {

			foreach ($replyValues1 as $replyKey2 => $replyValues2) {

				foreach ($replyValues2 as $replyKey3 => $replyValues3) {

					if($replyValues3 == null) {

						unset($replyRecords[$replyKey1][$replyKey2][$replyKey3]);
					}
				}
			}

		}
		

		$query = $db->prepare("SELECT *,
							 				f_post_reply_flag(Post_ID, ?) AS Post_Reply_Flag,
							 				f_post_love_flag(Post_ID, ?) AS Post_Love_Flag
							 				FROM V_POST WHERE 
							 				Post_ID_Ref = ?
							 				AND Post_Type = 2
							 				ORDER BY $order LIMIT $limit OFFSET $offset"
		);

		$query->execute([$sesID, $sesID, $postID]);

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

        $records['post'] = is_array($records['post'])? array_values($records['post']): array();   

		foreach ($records as $key1 => $values1) {

			foreach ($values1 as $key2 => $values2) {

				foreach ($values2 as $key3 => $values3) {

					if($values3 === null) {

						unset($records[$key1][$key2][$key3]);
					}

				}
			}

		}

		echo json_encode(array_merge($replyRecords, $records));

	}
	
switch($_POST["command"]){
			
		//Newest Posts Filter
		case $case = "PostNew";
		
		    $profID = addslashes($_POST["profile_ID"]);
		    $limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Created DESC';
			
		    Post_Query($sesID, $profID, $order, $limit, $offset);
		    
		    break;
			
		//Oldest Posts Filter
		case $case = "PostOld";

			$profID = addslashes($_POST["profile_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Created ASC';
			
		    Post_Query($sesID, $profID, $order, $limit, $offset);
		
			break;
		
		//Loved Posts Filter
		case $case = "PostLove";

			$profID = addslashes($_POST["profile_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);			
			$order = 'Post_Love_Count DESC';
			
		    Post_Query($sesID, $profID, $order, $limit, $offset);

			break;
		
		//Pin Posts Filter
		case $case = "PostPin";

			$profID = addslashes($_POST["profile_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);			
			$order = 'Post_Pin_Count DESC';
			
		    Post_Query($sesID, $profID, $order, $limit, $offset);
		    
			break;
			
		//Reply Posts Filter
		case $case = "PostReply";

			$profID = addslashes($_POST["profile_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Reply_Count DESC';
			
		    Post_Query($sesID, $profID, $order, $limit, $offset);

			break;
			
		//Reply Posts Filter
		case $case = "ReplyNew";

			$postID = addslashes($_POST["post_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Created DESC';
			
		    Reply_Query($sesID, $postID, $order, $limit, $offset);

			break;
			
		//Reply Posts Filter
		case $case = "ReplyOld";

			$postID = addslashes($_POST["post_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Created ASC';
			
		    Reply_Query($sesID, $postID, $order, $limit, $offset);

			break;
			
		//Reply Posts Filter
		case $case = "ReplyLove";

			$postID = addslashes($_POST["post_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Love_Count DESC';
			
		    Reply_Query($sesID, $postID, $order, $limit, $offset);

			break;
			
		//Reply Posts Filter
		case $case = "ReplyReply";

			$postID = addslashes($_POST["post_ID"]);
			$limit = intval($_POST["limit"]);
		    $offset = intval($_POST["offset"]);		
			$order = 'Post_Reply_Count DESC';
			
		    Reply_Query($sesID, $postID, $order, $limit, $offset);

			break;
			
	//Remove Post
	case $case = "removePost";
	
			$post_ID = addslashes($_POST["post_ID"]);

			try {

				//Stored Procedure Call is Not Working with MySQL.
				//Thus, I placed the entire SP code below to get it to work.

				//$replyQuery = $db->prepare("CALL p_find_nested_reply(?)");
				//$replyQuery->execute([$post_ID]);
				
				$replyQuery = $db->prepare("SELECT 
				(SELECT Post_Prof_ID FROM POST WHERE Post_ID = ?) AS Parent_Prof_ID, 
				Reply_Prof_ID AS Child_Prof_ID, 
				Reply_Post_ID_Ref AS Parent_Post_ID, 
				Reply_Post_ID AS Child_Post_ID
				FROM REPLY a
				WHERE FIND_IN_SET(Reply_Post_ID, (
				   SELECT GROUP_CONCAT(Level SEPARATOR ',') FROM (
					  SELECT @Ids := (
						  SELECT GROUP_CONCAT(Reply_Post_ID SEPARATOR ',')
						  FROM REPLY
						  WHERE FIND_IN_SET(Reply_Post_ID_Ref, @Ids)
					  ) Level
					  FROM REPLY
					  JOIN (SELECT @Ids := ?) temp1
				   ) temp2
				)) ORDER BY Reply_Post_ID DESC;");
				$replyQuery->execute([$post_ID, $post_ID]);

				$rownum = $replyQuery->rowCount();

				if ($rownum > 0) {
					// do something


					while ($row = $replyQuery->fetch(PDO::FETCH_ASSOC)) {
		             
						$stmt = $db->prepare(
							   "DELETE 
								 FROM 
								POST 
								WHERE
								Post_ID = ?"
							   );
	 
						$stmt->execute([$row['Child_Post_ID']]);
						
						$dirname = '../../uploads/'. $row['Child_Prof_ID'] .'/posts/'. $row['Child_Post_ID'] .'/';
						delete_directory($dirname);	

				 }
				 
				 
				 if ($replyQuery) {
		 
					   $stmt = $db->prepare(
						   "DELETE 
							 FROM 
							POST 
							WHERE
							Post_ID = ?"
							);
	 
					   $stmt->execute([$post_ID]);

					  if ($stmt) {
		 
						$dirname = '../../uploads/'. $sesID .'/posts/'. $post_ID .'/';
						delete_directory($dirname);	
				 
						$response = array("success" => 1, "error_message" => NULL);

			 
					   } else {
		 
						  $response = array("success" => 0, "error_message" => "Error! There was a problem removing your Post, please try again.");
			  
						}
			  
				 } else {
				 
					 $response = array("success" => 0, "error_message" => "Error! There was a problem removing your Reply, please try again.");;

				 }
				} else {

					//$db->commit();

					$stmt = $db->prepare(
						"DELETE 
							FROM 
							POST 
							WHERE
							Post_ID = ?"
						);
	   
					 $stmt->execute([$post_ID]);
	
				   if ($stmt) {
				
						$dirname = '../../uploads/'. $sesID .'/posts/'. $post_ID .'/';
						//delete_directory($dirname);	
						
						$response = array("success" => 1, "error_message" => NULL);
	
					
					} else {
				
						 $response = array("success" => 0, "error_message" => "Error! There was a problem removing your Post, please try again.");
					 
					 }
				}

			} catch (PDOException $e) {
				echo "Error: " . $e->getMessage();
			}

			echo json_encode($response);

	break;

	//Create Post
	case $case = "createPost";

		$profile_ID = intval($_POST["profile_ID"]);
		$post_ID = intval($_POST["post_ID"]);
		$post = $_POST["post"];
		$attachments = $_POST["attachments"];
		$type = $_POST["type"];
		$post_key = generateKey();

		if ($type == "Watch") {
		
		
			$sesID = $profile_ID;
		
		}


		$stmt = $db->prepare(
						   "INSERT 
			 	            INTO 
				            POST 
			 		        (
			 		        Post_Key,
			 		        Post_Type,
			 		        Post_Prof_ID,
			 		        Post_Post
			 	 	        )
			 	            VALUES
			 	 	        (
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?
			 	 	        )"
		);

		$stmt->execute([$post_key, $type, $sesID, $post]);

		$stmt = $db->prepare(
							"SELECT 
                             LAST_INSERT_ID() AS Post_ID 
                             FROM 
				             POST LIMIT 1"
		);

		$stmt->execute();
		$arr = $stmt->fetch(PDO::FETCH_ASSOC);

		$posted_ID = $arr['Post_ID'];

		$decoded_json = json_decode($attachments, TRUE);

		if ($decoded_json != "") {
		
		for($i=0; $i<count($decoded_json); $i++) {

			$file_name = $decoded_json[$i]["post_attachment_file_name"];
			$file_extension = $decoded_json[$i]["post_attachment_file_extension"];
			$file_size = $decoded_json[$i]["post_attachment_file_size"];
			$creation_date = $decoded_json[$i]["post_attachment_creation_date"];
			$modification_date = $decoded_json[$i]["post_attachment_modification_date"];

			date_default_timezone_set('America/New_York');

			if ($creation_date == NULL) {
			
				$creation_date = date('Y-m-d H:i:s');

			} 
			
			if ($modification_date == NULL) {
			
				$modification_date = date('Y-m-d H:i:s');

			} 
			
			//Create Folder for Post Items
			$folder_path = '../../uploads/'.$sesID. '/posts/' .$posted_ID;
			mkdir($folder_path);
			//Give Folder Full Permissions For All
			chmod($folder_path, 0777);
			
			$target = '../../uploads/'.$sesID. '/posts/' .$posted_ID. '/' .$file_name. '.' .$file_extension;
			move_uploaded_file($_FILES[$i]['tmp_name'], $target);
			
			//Create URL to store file location in database.
			$url = (isset($_SERVER['HTTPS']) ? "https" : "http") . '://' . $_SERVER['SERVER_ADDR'] . dirname($_SERVER['PHP_SELF']);
		
			$number = 2;
			for($i2=0; $i2<$number; $i2++) {
    			$url = dirname($url);
			}	
		
			//File Path
			$file_path = $url . '/uploads/' .$sesID. '/posts/' .$posted_ID. '/' .$file_name. '.' .$file_extension;
			
			//Generate Base64 Attachment Key
			$attachment_key = generateKey();

			$stmt = $db->prepare(
						   "INSERT 
			 	            INTO 
				            ATTACHMENT 
			 		        (
			 		        Attach_Key,
			 		        Attach_Post_ID,
			 		        Attach_File_Name,
			 		        Attach_File_Extension,
			 		        Attach_File_Size,
			 		        Attach_File_Path,
			 		        Attach_Created,
			 		        Attach_Modified
			 	 	        )
			 	            VALUES
			 	 	        (
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?,
			 	 	        ?
			 	 	        )"
			);

			$stmt->execute([$attachment_key, $posted_ID, $file_name, $file_extension, $file_size, $file_path, $creation_date, $modification_date]);

		}
		
	}
	
		    if ($type == "Reply") {

	
			$stmt = $db->prepare(
						   "INSERT 
			 	            INTO 
				            REPLY 
			 		        (
			 		        Reply_Prof_ID,
			 		        Reply_Post_ID,
			 		        Reply_Post_ID_Ref
			 	 	        )
			 	            VALUES
			 	 	        (
			 	 	        ?,
			 	 	        ?,
			 	 	        ?
			 	 	        )"
	       	);

	         	$stmt->execute([$sesID, $posted_ID, $post_ID]);
	
	        }


			if ($stmt) {
			
				$response = array("success" => 1, "error_message" => NULL);;        
				
			} else {
			
			 	$response = array("success" => 0, "error_message" => "Error! There was a problem creating your Post, please try again.");;
			
			}
			
			echo json_encode($response);
			
		break;
		
	}

?>
