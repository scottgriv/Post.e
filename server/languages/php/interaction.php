<?php
header('Content-type: application/json');

include("session.php"); //Include Session Handler

error_reporting(0); //Turn OFF error exceptions.

new MySessionHandler();

session_start();
$sesID = $_SESSION['UserSes'];

$db = $GLOBALS['db'];

switch($_POST["command"]){

		case $case = "NewUserList";

		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   ORDER BY Prof_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);

					}
	

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
		
		case $case = "FollowerList";

					$profID = urlencode($_POST["profile_ID"]);
		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   INNER JOIN FOLLOW 
										   ON Prof_ID = Fol_Follower
										   WHERE Fol_Following = ?
										   ORDER BY Fol_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID, $profID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);

					}

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
				
		case $case = "FollowingList";
		
					$profID = urlencode($_POST["profile_ID"]);
		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   INNER JOIN FOLLOW 
										   ON Prof_ID = Fol_Following 
										   WHERE Fol_Follower = ?
										   ORDER BY Fol_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID, $profID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);

					}
	
					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
		
		case $case = "LoveCountList";
		
					$profID = urlencode($_POST["profile_ID"]);
					$postID = urlencode($_POST["post_ID"]);
		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   INNER JOIN LOVE 
										   ON Prof_ID = Love_Prof_ID 
										   WHERE Love_Post_ID = ?
										   ORDER BY Love_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID, $postID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);


					}
	

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
		
		case $case = "PinCountList";
		
					$profID = urlencode($_POST["profile_ID"]);
					$postID = urlencode($_POST["post_ID"]);
		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   INNER JOIN PIN 
										   ON Prof_ID = Pin_Prof_ID
										   WHERE Pin_Post_ID = ?
										   ORDER BY Pin_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID, $postID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);

					}

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
		
		case $case = "ReplyCountList";
		
					$profID = urlencode($_POST["profile_ID"]);
					$postID = urlencode($_POST["post_ID"]);
		  			$limit = intval($_POST["limit"]);
		    		$offset = intval($_POST["offset"]);	
					
					$records = array();

					$query = $db->prepare("SELECT DISTINCT
										   Prof_ID,
										   Prof_User,
										   Prof_Name,
										   Prof_Pic,
										   f_follow_flag(a.Prof_ID, ?) AS Prof_Follow_Flag
										   FROM V_PROFILE a
										   INNER JOIN REPLY 
										   ON Prof_ID = Reply_Prof_ID 
										   WHERE Reply_Post_ID_Ref = ?
										   ORDER BY Reply_Created DESC LIMIT $limit OFFSET $offset"
					);

					$query->execute([$sesID, $postID]);

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records[] = array(
							'inter_prof_id' => intval($row['Prof_ID']),
							'inter_prof_user' => $row['Prof_User'],
							'inter_prof_name' => $row['Prof_Name'],
							'inter_prof_pic' => $row['Prof_Pic'],
							'inter_prof_fol_flag' => $row['Prof_Follow_Flag'] ? true : false

						);


					}

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
						
					echo json_encode($records);	
		
		break;
		
		case $case = "Follow";

		    $profID = addslashes($_POST["profile_ID"]);

			$stmt = $db->prepare(
				"INSERT 
			 	 INTO 
				 FOLLOW 
			 		(
			 		 Fol_Follower,
			 		 Fol_Following
			 	 	 )
			 	 VALUES
			 	 	(
			 	 	?,
			 	 	?
			 	 	)"
			);

			$stmt->execute([$sesID, $profID]);


				if ($stmt) {

					$stmt = $db->prepare(
						"SELECT 
       			 		 Prof_Follower_Count, 
				 		 f_follow_flag(a.Prof_ID, ?) AS Follow_Flag
				 		 FROM 
				 		 V_PROFILE a 
				 		 WHERE a.Prof_ID = ? LIMIT 1;"
					);

					$stmt->execute([$sesID, $profID]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					$newFollowCount = intval($arr['Prof_Follower_Count']);
	    	    	$newFlag = $arr['Follow_Flag'] ? true : false;

					if ($stmt) {

						$response = array("success" => true, "new_flag" => $newFlag, "new_follow_count" => $newFollowCount);

					} else {

						$response = array("success" => false);

					}


					} else {

						$response = array("success" => false);

					}

					echo json_encode($response);

		break;

		case $case = "Unfollow";

		    		$profID = addslashes($_POST["profile_ID"]);

					$stmt = $db->prepare(
						"DELETE 
			 			 FROM 
				 		 FOLLOW 
 						 WHERE 
 						 Fol_Follower = ? 
 						 AND 
 						 Fol_Following = ?"
					);

					$stmt->execute([$sesID, $profID]);

					if ($stmt) {

						$stmt = $db->prepare(
						   "SELECT 
       			 			Prof_Follower_Count, 
				 			f_follow_flag(a.Prof_ID, ?) AS Follow_Flag
				 			FROM 
				 		 	V_PROFILE a 
				 		 	WHERE a.Prof_ID = ? LIMIT 1;"
					);

					$stmt->execute([$sesID, $profID]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					$newFollowCount = intval($arr['Prof_Follower_Count']);
	    			$newFlag = $arr['Follow_Flag'] ? true : false;

					if ($stmt) {

						$response = array("success" => true, "new_flag" => $newFlag, "new_follow_count" => $newFollowCount);

					} else {

						$response = array("success" => false);

					}


					} else {

						$response = array("success" => false);

					}

					echo json_encode($response);

		break;
		
		case $case = "Love";

		    	$postID = addslashes($_POST["post_ID"]);

				$stmt = $db->prepare(
					"INSERT 
			 		 INTO 
					 LOVE 
			 			(
			 			 Love_Prof_ID,
			 			 Love_Post_ID
			 		 	 )
			 		 VALUES
			 		 	(
			 		 	?,
			 		 	?
			 	 		)"
			);

				$stmt->execute([$sesID, $postID]);
  
				if ($stmt) {
					
					$response = array("success" => true);
					
				} else {
				
					$response = array("success" => false);

				}
				
				echo json_encode($response);

		break;

		case $case = "Unlove";

		    	$postID = addslashes($_POST["post_ID"]);

				$stmt = $db->prepare(
					"DELETE 
			 		 FROM 
				 	 LOVE 
 					 WHERE 
 					 Love_Prof_ID = ? 
 					 AND 
 					 Love_Post_ID = ?"
				);

				$stmt->execute([$sesID, $postID]);

				if ($stmt) {
					
					$response = array("success" => true);

				} else {
					
					$response = array("success" => false);

				}

				echo json_encode($response);

		break;
		
		case $case = "Pin";

		    	$postID = addslashes($_POST["post_ID"]);

				$stmt = $db->prepare(
					"INSERT 
			 		 INTO 
					 PIN 
			 			(
			 			 Pin_Prof_ID,
			 			 Pin_Post_ID
			 		 	 )
			 		 VALUES
			 		 	(
			 		 	?,
			 		 	?
			 	 		)"
			);

				$stmt->execute([$sesID, $postID]);
  
				if ($stmt) {
					
					$response = array("success" => true);
					
				} else {
				
					$response = array("success" => false);

				}
				
				echo json_encode($response);

		break;

		case $case = "Unpin";

		    	$postID = addslashes($_POST["post_ID"]);

				$stmt = $db->prepare(
					"DELETE 
			 		 FROM 
				 	 PIN 
 					 WHERE 
 					 Pin_Prof_ID = ? 
 					 AND 
 					 Pin_Post_ID = ?"
				);

				$stmt->execute([$sesID, $postID]);

				if ($stmt) {
					
					$response = array("success" => true);

				} else {
					
					$response = array("success" => false);

				}

				echo json_encode($response);

		break;
		
		//O(n+n)
		case $case = "Languages";
					
					$current_language_code = $_POST["current_language_code"];

					$headerRecords = array();
					$records = array();

					$headerQuery = $db->prepare("SELECT 
										   Lang_Code AS Current_Lang_Code, 
										   CONCAT(Lang_Name,' (', Lang_Translated,')') AS Current_Lang_Name
										   FROM 
										   LANGUAGE
										   WHERE 
										   Lang_Code = ?
										   UNION
                                           SELECT
                                           Lang_Code AS Current_Lang_Code, 
                                           Lang_Name AS Current_Lang_Name
                                           FROM
                                           LANGUAGE
                                           WHERE
                                           Lang_Code = 'na'
										   LIMIT 1");
										   
					$headerQuery->execute([$current_language_code]);
				   
				   //O(n)
					while ($headerRow = $headerQuery->fetch(PDO::FETCH_ASSOC)) {
						$headerRecords['header'][] = array(
							'current_language_code' => $headerRow['Current_Lang_Code'],
							'current_language_name' => $headerRow['Current_Lang_Name']
						);


					}
					
					foreach ($headerRecords as $headerKey1 => $headerValues1) {

						foreach ($headerValues1 as $headerKey2 => $headerValues2) {

							foreach ($headerValues2 as $headerKey3 => $headerValues3) {

								if($headerValues3 == null) {

									unset($headerRecords[$headerKey1][$headerKey2][$headerKey3]);
								}
							}
						}

					}
					
					$query = $db->prepare("SELECT
										   Lang_Code,
										   CONCAT(Lang_Name,' (', Lang_Translated,')') AS Lang_Name
										   FROM LANGUAGE
										   WHERE Lang_Active = 1
										   ORDER BY Lang_ID ASC"
					);

					$query->execute();

					while ($row = $query->fetch(PDO::FETCH_ASSOC)) {
						$records['details'][] = array(
							'language_code' => $row['Lang_Code'],
							'language_name' => $row['Lang_Name']
						);


					}
	

					foreach ($records as $key1 => $values1) {

						foreach ($values1 as $key2 => $values2) {

							foreach ($values2 as $key3 => $values3) {

								if($values3 == null) {

									unset($records[$key1][$key2][$key3]);
								}
							}
						}

					}
													
				echo json_encode(array_merge($headerRecords, $records));
		
		break;

	}

?>
