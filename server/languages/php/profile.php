<?php
header('Content-type: application/json');

include("session.php"); //Include Session Handler

error_reporting(0); //Turn OFF error exceptions.

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

 function write_log($log_msg) {
    
	$log_filename = '../../resources/logs';

    if (!file_exists($log_filename))
    {
        // create directory/folder uploads.
        mkdir($log_filename, 0777, true);
    }
    $log_file_data = $log_filename.'/log_' . date('d-M-Y') . '.log';
    file_put_contents($log_file_data, $log_msg . "\n", FILE_APPEND);
}

new MySessionHandler();

session_start();
$sesID = $_SESSION['UserSes'];

switch($_POST["command"]){ 
 
 	//Edit Profile
	case $case = "editProfile";
 	
 		$profileUser = $_POST["profile_user"];
 		$profileName = $_POST["profile_name"];
        $changesFields = filter_var($_POST['changes_fields'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
        $changesPic = filter_var($_POST['changes_pic'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);

		if ($changesFields && $changesPic) {
		
    	$stmt = $db->prepare(
    		"SELECT 
			 Prof_User
			 FROM PROFILE 
			 WHERE Prof_User = ?
			 AND Prof_ID != ?"
		);

    	$stmt->execute([$profileUser, $sesID]);
    	$arr = $stmt->fetch(PDO::FETCH_ASSOC);

    	if($arr) {

        	$response = array(
        		"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Username already exists! Please try again."
			);

        	echo json_encode($response);
        	return false;

        	exit('No Rows');

    	} else {
    	
    		$target = '../../uploads/'.$sesID. '/' .$sesID. '.jpg';
			move_uploaded_file($_FILES[$sesID]['tmp_name'], $target);
			
			//Create URL to store file location in database.
			$url = (isset($_SERVER['HTTPS']) ? "https" : "http") . '://' . $_SERVER['SERVER_ADDR'] . dirname($_SERVER['PHP_SELF']);
		
			$number = 2;
			for($i2=0; $i2<$number; $i2++) {
    			$url = dirname($url);
			}	
		
			//File Path
			$file_path = $url . '/uploads/' .$sesID. '/' .$sesID. '.jpg';

        	date_default_timezone_set('America/New_York');
            $date = date('Y-m-d H:i:s');

        	$updateProf = $db->prepare(
            			"UPDATE 
    					 PROFILE 
						 SET 
						 Prof_User = ?, 
						 Prof_Name = ?,
						 Prof_Pic = ?,
						 Prof_Edited = ?
						 WHERE Prof_ID = ?"
					);

            $updateProf->execute([$profileUser, $profileName, $file_path, $date, $sesID]);
            
            $updateUser = $db->prepare(
            			"UPDATE 
    					 USER 
						 SET 
						 User_Name = ?
						 WHERE User_ID = ?"
					);

            $updateUser->execute([$profileUser, $sesID]);

			
        	if ($updateProf) {
			
				$response = array("success" => 1, "error_message" => NULL);;        
				
			} else {
			
			 	$response = array("success" => 0, "error_message" => "Error! There was a problem Updating your Profile, please try again.");;
			
			}

        }
    
    } else if ($changesFields && !$changesPic) {
    
    	$stmt = $db->prepare(
    		"SELECT 
			 Prof_User
			 FROM PROFILE 
			 WHERE Prof_User = ?
			 AND Prof_ID != ?"
		);

    	$stmt->execute([$profileUser, $sesID]);
    	$arr = $stmt->fetch(PDO::FETCH_ASSOC);

    	if($arr) {


        	$response = array(
        		"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Username already exists! Please try again."
			);

        	echo json_encode($response);
        	return false;

        	exit('No Rows');

    	} else if (preg_match('/[^0-9A-Za-z]/', $profileUser)) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Oops! Unknown letters or spaces in username!"
			);

            echo json_encode($response);
            return false;


		} else if(strlen($profileUser) > 15) {
  
            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Oops! Username is too long!"
			);

            echo json_encode($response);
            return false;

		} else if(strlen($profileUser) < 6) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Oops! Username is too short!"
			);

            echo json_encode($response);
            return false;		
		
		} else {

        	$updateProf = $db->prepare(
            			"UPDATE 
    					 PROFILE 
						 SET 
						 Prof_User = ?, 
						 Prof_Name = ?,
						 Prof_Edited = ?
						 WHERE Prof_ID = ?"
					);

            $updateProf->execute([$profileUser, $profileName, $date, $sesID]);

		    $updateUser = $db->prepare(
            			"UPDATE 
    					 USER 
						 SET 
						 User_Name = ?
						 WHERE User_ID = ?"
					);
					
			$updateUser->execute([$profileUser, $sesID]);
					
        	if ($updateProf) {
			
				$response = array("success" => 1, "error_message" => NULL);;        
				
			} else {
			
			 	$response = array("success" => 0, "error_message" => "Error! There was a problem Updating your Profile, please try again.");;
			
			}

        }
    
    } else if (!$changesFields && $changesPic) {
    	
    		$target = '../../uploads/'.$sesID. '/' .$sesID. '.jpg';
			move_uploaded_file($_FILES[$sesID]['tmp_name'], $target);
			
			//Create URL to store file location in database.
			$url = (isset($_SERVER['HTTPS']) ? "https" : "http") . '://' . $_SERVER['SERVER_ADDR'] . dirname($_SERVER['PHP_SELF']);
		
			$number = 2;
			for($i2=0; $i2<$number; $i2++) {
    			$url = dirname($url);
			}	
		
			//File Path
			$file_path = $url . '/uploads/' .$sesID. '/' .$sesID. '.jpg';

        	date_default_timezone_set('America/New_York');
            $date = date('Y-m-d H:i:s');

        	$updateProf2 = $db->prepare(
            			"UPDATE 
    					 PROFILE 
						 SET 
						 Prof_Pic = ?,
						 Prof_Edited = ?
						 WHERE Prof_ID = ?"
					);

            $updateProf2->execute([$file_path, $date, $sesID]);
            
            $updateUser = $db->prepare(
            			"UPDATE 
    					 USER 
						 SET 
						 User_Name = ?
						 WHERE User_ID = ?"
					);

            $updateUser->execute([$profileUser, $sesID]);

        	if ($updateProf2) {
			
				$response = array("success" => 1, "error_message" => NULL);;        
				
			} else {
			
			 	$response = array("success" => 0, "error_message" => "There was a problem Updating your Profile, please try again.");;
			
			}
        
    } else {
    
		$response = array("success" => 0, "error_message" => "There was a problem Updating your Profile, please try again.");;

    }

    echo json_encode($response);

    break;
    
    //Remove Profile Pic
    case $case = "removeProfPic";
			
            $updateProf = $db->prepare(
            			"UPDATE 
    					 PROFILE 
						 SET 
						 Prof_Pic = NULL
						 WHERE Prof_ID = ?"
					);

            $updateProf->execute([$sesID]);
            
            if ($updateProf) {
            
           	 	$target = '../../uploads/'.$sesID. '/' .$sesID. '.jpg';
           		unlink($target);
           		
           		$response = array("success" => 1, "error_message" => NULL);;        
            
            } else {
            
            	$response = array("success" => 0, "error_message" => "There was a problem removing your Profile Picture, please try again.");;

            }
            
            echo json_encode($response);

	break;
	
	//Delete Profile
    case $case = "deleteProfile";
    
       $postQuery = $db->prepare("SELECT Post_ID FROM POST WHERE Post_Prof_ID = ? ORDER BY Post_ID DESC");

	   $postQuery->execute([$sesID]);
		
		while ($postRow = $postQuery->fetch(PDO::FETCH_ASSOC)) {
			
			$post_ID = $postRow['Post_ID'];
			
            $replyQuery = $db->prepare("CALL p_find_nested_reply(?)");

		    $replyQuery->execute([$post_ID]);
		    
		    $rownum = $replyQuery->rowCount();

			if($rownum > 0) {
		
		            while ($row = $replyQuery->fetch(PDO::FETCH_ASSOC)) {
		             
		                   $stmt1 = $db->prepare(
						          "DELETE 
			 	                   FROM 
				                   POST 
				                   WHERE
				                   Post_ID = ?"
							      );
		
					       $stmt1->execute([$row['Child_Post_ID']]);
					       
					       $dirname = '../../uploads/'. $row['Child_Prof_ID'] .'/posts/'. $row['Child_Post_ID'] .'/';
			               delete_directory($dirname);	
	
					}	
				
			}
			
		}
		
		if ($postQuery) {
		
      	    $stmt2 = $db->prepare(
        		"DELETE FROM 
				 POST
				 WHERE Post_Prof_ID = ?;"
			);
 		
 		    $stmt2->execute([$sesID]);	
 		    
            $stmt3 = $db->prepare(
        		"INSERT INTO user_deleted (User_ID, User_Name)
                 SELECT User_ID, User_Name
                 FROM user
                 WHERE User_ID = ?;"
			);
 		
 		    $stmt3->execute([$sesID]);	
 		
       	    $stmt4 = $db->prepare(
        		"DELETE FROM 
				 USER
				 WHERE User_ID = ?;"
			);
			
        	$stmt4->execute([$sesID]);	

			if ($stmt4) {
			
				write_log('Successful Profile Delete for User: '.$sesID.'');

			    session_destroy();
       			$db = DB::closeInstance();
       			
       			$dirname = '../../uploads/'. $sesID . '/';
				delete_directory($dirname);	
		
 		   	    $response = array(
 		    		"success" 		=> 1,
					"title" => "Success!",
					"subtitle" => "Successfully Deleted Profile!"
				);
        
      		} else {
      		
      			write_log('Failed Profile Delete for User: '.$sesID.'');

 		  	  	$response = array(
 		    		"success" 		=> 0,
					"title" => "Error!",
					"subtitle" => "There was a problem Deleting your Profile, please try again."
				);
        
    		}
    	
    		session_destroy();
       		$db = DB::closeInstance();
		
		} else {
		
		    write_log('Failed Profile Delete for User: '.$sesID.'');

			$response = array(
 		    		"success" 		=> 0,
					"title" => "Error!",
					"subtitle" => "There was a problem Deleting your Profile, please try again."
				);
				
		}
			
    	echo json_encode($response);
    	
    	break;

    }
     
?>
