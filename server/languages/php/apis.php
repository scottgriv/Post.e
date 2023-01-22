<?php
header('Content-type: application/json');

require_once('database.php'); //Include Database Connection
error_reporting(0); //Turn OFF error exceptions

$db = DB::getInstance();
DB::setCharsetEncoding();

/*

***** API SCRIPT *****

TOKEN     : Token issued by user signed up for API's on our website (future development).

TYPE      : CHECK_TOKEN  				: Check if Token is Valid.
		  : USER_OVERALL_TOTAL			: Total Users in Post.e (Count).
		  : POST_OVERALL_TOTAL  		: Total Posts in Post.e (Count).
		  : POST_TOTAL_BY_PROF			: Total Posts by Profile (Count).
		  : FOLLOWER_TOTAL_BY_PROF 		: Total Followers by Profile (Count).
		  : FOLLOWING_TOTAL_BY_PROF 	: Total Following by Profile (Count).
		  : FOLLOWER_ARRAY_BY_PROF 		: Followers List by Profile (Array).
		  : FOLLOWING_ARRAY_BY_PROF 	: Following List by Profile (Array).

URL EXAMPLES: 

http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=CHECK_TOKEN
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=USER_OVERALL_TOTAL
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=POST_OVERALL_TOTAL
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=POST_TOTAL_BY_PROF
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=FOLLOWER_TOTAL_BY_PROF
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=FOLLOWING_TOTAL_BY_PROF
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=FOLLOWER_ARRAY_BY_PROF
http://localhost/Post.e/languages/php/apis.php?TOKEN=j2Srmh&TYPE=FOLLOWING_ARRAY_BY_PROF

*/

			//Pass in parameters
		    $token = $_GET["TOKEN"];
		    $type = $_GET["TYPE"];
		    
		    //Create Response Array
			$response = array();

			//Check if Token & Type are passed in
		    if ($token == '' || $type == '') {
			
				$response = array("message" => "Token and/or Type is not set! View the API for more information on how to structure the API call!");

			//Run API's:
			} else if (strtoupper($type) == "CHECK_TOKEN" || 
			strtoupper($type) == "USER_OVERALL_TOTAL" || 
			strtoupper($type) == "POST_OVERALL_TOTAL" || 
			strtoupper($type) == "POST_TOTAL_BY_PROF" || 
			strtoupper($type) == "FOLLOWER_TOTAL_BY_PROF" || 
			strtoupper($type) == "FOLLOWING_TOTAL_BY_PROF" || 
			strtoupper($type) == "FOLLOWER_ARRAY_BY_PROF" || 
			strtoupper($type) == "FOLLOWING_ARRAY_BY_PROF") {
				
				if (strtoupper($type) == "CHECK_TOKEN") {
									
					$stmt = $db->prepare("SELECT UA_Token, UA_Active, UA_Issued, UA_Expired FROM USER_API WHERE UA_Token = ?;");
					
					$stmt->execute([$token]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					
					if($arr) {

						if ($arr['UA_Active'] == true) {

							$issuedDateTime = $arr['UA_Issued'];
        					$response = array(
								"message" => "Token $token is a valid Token : Issued: $issuedDateTime"
							);
			
			
						} else if ($arr['UA_Active'] == false) {
						
							$expDateTime = $arr['UA_Expired'];
							$response = array(
								"message" => "Token $token is an expired Token : Expired Since: $expDateTime"
							);
						
						} 
						
					} else {
					
					$response = array("message" => "Invalid or Expired Token: $token !");
					
					}

				
				} else if (strtoupper($type) == "USER_OVERALL_TOTAL" || 
				strtoupper($type) == "POST_OVERALL_TOTAL" || 
				strtoupper($type) == "POST_TOTAL_BY_PROF" || 
				strtoupper($type) == "FOLLOWER_TOTAL_BY_PROF" || 
				strtoupper($type) == "FOLLOWING_TOTAL_BY_PROF") {
			
					$stmt = $db->prepare("SELECT UA_Token FROM USER_API WHERE UA_Token = ? AND UA_Active = 1");
					
					$stmt->execute([$token]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					
					if($arr) {
														
							$stmt = $db->prepare("SELECT Name, Type, Count FROM v_user_api WHERE Type = ? AND Token = ?");
					
							$stmt->execute([$type, $token]);
					
							if ($stmt) {
					
								//O(n)
								while ($arr = $stmt->fetch(PDO::FETCH_ASSOC)) {
										$response[] = array(
										'Name'  => $arr['Name'],
										'Type'  => $arr['Type'],
										'Count' => $arr['Count']
										);
										
									}
					
							} else {
					
								$response = array("message" => "Invalid Result! Please check your Token and API Type and try again!");
							
							}
					
					} else {
					
					$response = array("message" => "Invalid or Expired Token: $token !");
					
					}
					
				} else if (strtoupper($type) == "FOLLOWER_ARRAY_BY_PROF") {
					
					$stmt = $db->prepare("SELECT UA_Token FROM USER_API WHERE UA_Token = ? AND UA_Active = 1");
					
					$stmt->execute([$token]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					
					if($arr) {
														
							$stmt = $db->prepare("SELECT
												   Prof_User
												   FROM PROFILE
												   INNER JOIN FOLLOW ON Prof_ID = Fol_Follower
												   INNER JOIN User_API ON UA_Prof = Fol_Following
												   WHERE UA_Token = ?
												   ORDER BY Fol_Created ASC");
					
							$stmt->execute([$token]);
					
							if ($stmt) {
					
								//O(n)
								while ($arr = $stmt->fetch(PDO::FETCH_ASSOC)) {
										$response[] = array(
										'profile_follower_user'  => $arr['Prof_User']
										);
										
									}
					
							} else {
					
								$response = array("message" => "Invalid Result! Please check your Token and API Type and try again!");
							
							}
					
					} else {
					
					$response = array("message" => "Invalid or Expired Token: $token !");
					
					}			
								
				} else if (strtoupper($type) == "FOLLOWING_ARRAY_BY_PROF") {
				
					$stmt = $db->prepare("SELECT UA_Token FROM USER_API WHERE UA_Token = ? AND UA_Active = 1");
					
					$stmt->execute([$token]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);
					
					if($arr) {
														
							$stmt = $db->prepare("SELECT
												   Prof_User
												   FROM PROFILE
												   INNER JOIN FOLLOW ON Prof_ID = Fol_Following
												   INNER JOIN User_API ON UA_Prof = Fol_Follower
												   WHERE UA_Token = ?
												   ORDER BY Fol_Created ASC");
					
							$stmt->execute([$token]);
					
							if ($stmt) {
					
								//O(n)
								while ($arr = $stmt->fetch(PDO::FETCH_ASSOC)) {
										$response[] = array(
										'profile_following_user'  => $arr['Prof_User']
										);
										
									}
					
							} else {
					
								$response = array("message" => "Invalid Result! Please check your Token and API Type and try again!");
							
							}
					
					}  else {
				
					$response = array("message" => "Invalid or Expired Token: $token !");
				
					}
					
				} else {
				
					$response = array("message" => "Invalid or Expired Token: $token !");
				
				}
				
			} else {
				
				$response = array("message" => "Invalid Type: $type ! Please use type CHECK_TOKEN, USER_OVERALL_TOTAL, POST_OVERALL_TOTAL, POST_TOTAL_BY_PROF, FOLLOWER_TOTAL_BY_PROF, FOLLOWING_TOTAL_BY_PROF");
				
			}
			
			
		//Output the data as JSON
		echo json_encode($response);
			
?>