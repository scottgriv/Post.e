<?php
header('Content-type: application/json');

include("session.php"); //Include Session Handler

error_reporting(0); //Turn OFF error exceptions.

$db = DB::getInstance();
DB::setCharsetEncoding();

define('SALT_LENGTH', 15);

new MySessionHandler();

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

function HashMe($phrase, &$salt = null)
	{
	$key = '!@#$%^&*()_+=-{}][;";/?<>.,';
	    if ($salt == '')
	    {
	        $salt = substr(hash('sha512',uniqid(rand(), true).$key.microtime()), 0, SALT_LENGTH);
	    }
	    else
	    {
	        $salt = substr($salt, 0, SALT_LENGTH);
	    }

	    return hash('sha512',$salt . $key .  $phrase);
	}

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

switch($_POST["command"]){ 
 
 	//Login
	case $case = "Login";
 	
 		$username = addslashes($_POST["username"]);
 		$password = addslashes($_POST["password"]);
    	$salt = '';

    	$stmt = $db->prepare(
    		"SELECT 
			 User_ID, 
			 User_Name, 
			 User_Pass, 
			 User_Salt 
			 FROM USER 
			 WHERE User_Name = ?"
		);

    	$stmt->execute([$username]);
    	$arr = $stmt->fetch(PDO::FETCH_ASSOC);

    	if(!$arr) {


        	$response = array(
        		"success" 		=> 9,
				"token" 		=> 0,
				"error_message" => "Incorrect Login Credentials!"
			);
			
			write_log('Failed Login for User: '.$username.'');

        	echo json_encode($response);
        	return false;

        	exit('No Rows');

    	} else {

        	$salt = $arr['User_Salt'];
        	$hashed_password = HashMe($password, $salt);

        		if ($hashed_password == $arr['User_Pass']) {

        			$userID = $arr['User_ID'];

        			date_default_timezone_set('America/New_York');

            		$date = date('Y-m-d H:i:s');
            		$dateSes = date('dmyHis');

            		$lastLogin = $db->prepare(
            			"UPDATE 
    					 USER 
						 SET 
						 User_Last_Login = ?, 
						 User_Login_Status = 1 
						 WHERE User_ID = ?"
					);

            		$lastLogin->execute([$date, $userID]);

            		if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
            			$ip = $_SERVER['HTTP_CLIENT_IP'];
            		} else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
                		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
            		} else {
                		$ip = $_SERVER['REMOTE_ADDR'];
            		}

            		if (strpos($ip, ',') !== false) {

               		 $ips = explode(',', $ip);
                	 $ip = trim($ips[0]); // taking the first one

            		}

            		$uniqueSes = md5($ip.'-'.$dateSes.'-'.$userID);

            		session_id($uniqueSes);
            		session_start();

            		$_SESSION['UserSes'] = $userID;

            		$response = array(
            			"success" 		=> 1,
						"token" 		=> $userID,
						"tokenID"		=> $uniqueSes,
						"error_message" => "nil"
					);

            		echo json_encode($response);
            		return true;
					$username = addslashes($_POST["username"]);
					$password = addslashes($_POST["password"]);
					$salt = '';

					$stmt = $db->prepare(
						"SELECT 
			 			 User_ID, 
						 User_Name, 
						 User_Pass, 
						 User_Salt 
			 			 FROM USER 
			 			 WHERE User_Name = ?"
					);

					$stmt->execute([$username]);
					$arr = $stmt->fetch(PDO::FETCH_ASSOC);

					if(!$arr) {


						$response = array(
							"success" 		=> 9,
							"token" 		=> 0,
							"error_message" => "Incorrect Login Credentials!"
						);
						
						write_log('Failed Login for User: '.$userID.'');

						echo json_encode($response);
						return false;

						exit('No Rows');

					} else {

						$salt = $arr['User_Salt'];
						$hashed_password = HashMe($password, $salt);

						if ($hashed_password == $arr['User_Pass']) {

							$userID = $arr['User_ID'];

							date_default_timezone_set('America/New_York');

							$date = date('Y-m-d H:i:s');
							$dateSes = date('dmyHis');

							$lastLogin = $db->prepare(
								"UPDATE 
    					 		 USER 
						 		 SET 
						 		 User_Last_Login = ?, 
						 		 User_Login_Status = 1 
								 WHERE User_ID = ?"
							);

							$lastLogin->execute([$date, $userID]);

							if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
								$ip = $_SERVER['HTTP_CLIENT_IP'];
							} else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
								$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
							} else {
								$ip = $_SERVER['REMOTE_ADDR'];
							}

							if (strpos($ip, ',') !== false) {

								$ips = explode(',', $ip);
								$ip = trim($ips[0]); // taking the first one

							}

							$uniqueSes = md5($ip.'-'.$dateSes.'-'.$userID);

							session_id($uniqueSes);
							session_start();

							$_SESSION['UserSes'] = $userID;

							$response = array(
								"success" 		=> 1,
								"token" 		=> $userID,
								"tokenID"		=> $uniqueSes,
								"error_message" => "nil"
							);

							write_log('Successful Login for User: '.$userID.'');

							echo json_encode($response);
							return true;


						} else {

							$response = array(
								"success" 		=> 9,
								"token" 		=> 0,
								"error_message" => "Incorrect Login Credentials!"
							);
							
							write_log('Failed Login for User: '.$userID.'');


							echo json_encode($response);
							return false;

						}

					}

					break;

        		} else {

        			$response = array(
        				"success" 		=> 9,
						"token" 		=> 0,
						"error_message" => "Incorrect Login Credentials!"
					);
					
					write_log('Failed Login for User: '.$userID.'');

            		echo json_encode($response);
            		return false;

        		}

    	}

    break;

	//Register
	case $case = "Register";
		
		$username = addslashes($_POST["username"]);
 		$password = addslashes($_POST["password"]);
 		$repassword = addslashes($_POST["repassword"]);

		$stmt = $db->prepare(
			"SELECT 
			 User_ID, 
			 User_Name, 
			 User_Pass, 
			 User_Salt 
			 FROM USER 
			 WHERE User_Name = ?"
		);

		$stmt->execute([$username]);
		$arr = $stmt->fetch(PDO::FETCH_ASSOC);

		if($arr) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Username or Email is already in use!"
			);
			
			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if($password != $repassword) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! The two entered passwords don't match!"
			);
			
			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if(strlen($username) > 15) {
  
            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Username is too long!"
			);
			
			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if(strlen($username) < 6) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Username is too short!"
			);
			
			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if(strlen($password) > 45) {
 
            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Password is too long!"
			);

			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if(strlen($password) < 8) {
 	
            $response = array(
            	"success"		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Password is too short!"
			);
			
			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

		} else if(preg_match('/[^0-9A-Za-z]/',$username)) {

            $response = array(
            	"success" 		=> 0,
				"token" 		=> 0,
				"error_message" => "Warning! Unknown letters or spaces in username!"
			);

			write_log('Failed Registration for User: '.$userID.'');

            echo json_encode($response);
            return false;

 		} else {

   			$salt = '';
   			$hashed_password = HashMe($password, $salt);
   			$rehashed_password = HashMe($repassword, $salt);

			date_default_timezone_set('America/New_York');
			$date = date('Y-m-d H:i:s');

			$stmt = $db->prepare(
				"INSERT 
			 	 INTO 
				 USER 
			 		(
			 		 User_Name,
			 		 User_Pass,
			 	 	 User_Salt,
			 	 	 User_Last_Login,
			 	 	 User_Login_Status
			 	 	 )
			 	 VALUES
			 	 	(
			 	 	?,
			 	 	?,
			 	 	?,
			 	 	?,
			 	 	1
			 	 	)"
			);

			$stmt->execute([$username, $hashed_password, $salt, $date]);

			$stmt = $db->prepare(
				"SELECT 
       			 LAST_INSERT_ID() AS User_ID 
				 FROM 
				 USER LIMIT 1"
			);

			$stmt->execute();
			$arr = $stmt->fetch(PDO::FETCH_ASSOC);
              
			$userID = $arr['User_ID'];
            $prof_key = generateKey();

			date_default_timezone_set('America/New_York');
			$date = date('Y-m-d H:i:s');
			$dateSes = date('dmyHis');

			$stmt = $db->prepare(
				"INSERT 
			 	 INTO 
				 PROFILE 
			 		(
			 		 Prof_Key,
			 		 Prof_ID,
			 		 Prof_User
			 	 	 )
			 	 VALUES
			 	 	(
			 	 	?,
			 	 	?,
			 	 	?
			 	 	)"
			);

			$stmt->execute([$prof_key, $userID, $username]);

				if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
   					$ip = $_SERVER['HTTP_CLIENT_IP'];
	    		} else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
   		    		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
	    		} else {
  					$ip = $_SERVER['REMOTE_ADDR'];
	    		}
	    		
	    		
	    		if (strpos($ip, ',') !== false) {
	    
   			 		$ips = explode(',', $ip);
   			 		$ip = trim($ips[0]); // taking the first one

				}
        		
        		$uniqueSes = md5($ip.'-'.$dateSes.'-'.$userID);
        		
        		session_id($uniqueSes);
    			session_start();
    		
				$_SESSION['UserSes'] = $userID;
				
				//Create a Root Folder for Profile Items
				$folderPath = '../../uploads/' .$userID;
				mkdir($folderPath);
				//Give Folder Full Permissions For All
				chmod($folderPath, 0777);
				
				//Create Folder for Post Items
				$folderPath = '../../uploads/' .$userID. '/posts/';
				mkdir($folderPath);
				//Give Folder Full Permissions For All
				chmod($folderPath, 0777);

                $response = array(
                	"success" 		=> 1,
					"token" 		=> $userID,
					"tokenID" 		=> $uniqueSes,
					"error_message" => "nil"
				);
				
				write_log('Successful Registration for User: '.$userID.'');

                echo json_encode($response);
                return true;
             	    
		}

	break;
	
	 case $case = "changePassword";
 
  		session_start();
 		$sesID = $_SESSION['UserSes'];
 		
	    $cur_password = urlencode($_POST['cur_password']);
 	    $new_password = urlencode($_POST['new_password']);
 	   
        $stmt = $db->prepare(
		     	"SELECT 
		    	 User_Pass, 
		      	 User_Salt 
		    	 FROM USER 
		     	 WHERE User_ID = ?"
		       );

		$stmt->execute([$sesID]);
		$row = $stmt->fetch(PDO::FETCH_ASSOC);
		    
		$cur_salt = $row['User_Salt'];
        $cur_hashed_password = HashMe($cur_password, $cur_salt);
	
	    if($cur_hashed_password == $row['User_Pass']) {
	
	    	$new_salt = '';
	     	$new_hashed_password = HashMe($new_password, $new_salt);
	   		
	        $stmt2 = $db->prepare(
             	"UPDATE 
		    	 USER 
		    	 SET 
		    	 User_Pass = ?, 
		    	 User_Salt = ?
		    	 WHERE User_ID = ?"
	     	);

            $stmt2->execute([$new_hashed_password, $new_salt, $sesID]);
        
	    	if ($stmt2) {
	
                $response = array("success" => 1);
		
	    	} else {
		
		        $response = array("success" => 0, "error_message" => "There was a problem changing your password, please try again later!");
		
		    }
		
	    } else {
	
	    	$response = array("success" => 0, "error_message" => "The current password entered does not match your actual current password!");
    	
	    }
	
	    echo json_encode($response);

	break;
	
    //Logout
    case $case = "Logout";
 		
 		session_start();
 		$sesID = $_SESSION['UserSes'];	
 		
 		date_default_timezone_set('America/New_York');
		$date = date('Y-m-d H:i:s');

        $stmt = $db->prepare(
        	"UPDATE 
			 USER 
			 SET 
			 User_Last_Logout = ?, 
			 User_Login_Status = 0 
			 WHERE User_ID = ?"
		);

        $stmt->execute([$date, $sesID]);

        session_destroy();
        $db = DB::closeInstance();
        
		if($stmt) {
		
 		    $response = array(
 		    	"success" 		=> 1,
				"title" => "Success!",
				"subtitle" => "Successfully logged out."
			);
			
			write_log('Successful Logout for User: '.$sesID.'');
        
        } else {

 		    $response = array(
 		    	"success" 		=> 0,
				"title" => "Error!",
				"subtitle" => "There was a problem logging out, please try again."
			);
			
			write_log('Failed Logout for User: '.$sesID.'');
        
    	}
    	
 		echo json_encode($response);

	break;

    //Session
    case $case = "Session";
    
        $tokenID = addslashes($_POST["tokenID"]);

    	session_id($tokenID);
 		session_start();
 			
    	$token = $_SESSION['UserSes'];
    	
    	if ($tokenID != "" && $token != "") {

    		date_default_timezone_set('America/New_York');
			$date = date('Y-m-d H:i:s');
	    	$dateSes = date('dmyHis');

	   		if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
   				$ip = $_SERVER['HTTP_CLIENT_IP'];
	    	} else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
   		 	    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
	   		} else {
  				$ip = $_SERVER['REMOTE_ADDR'];
	   		}
	    
			if (strpos($ip, ',') !== false) {
	    
   				$ips = explode(',', $ip);
   		 		$ip = trim($ips[0]); // taking the first one
		
			}
				
			$uniqueSes = md5($ip.'-'.$dateSes.'-'.$token);               
            unset($_SESSION['UserSes']);
			session_destroy();
			
			session_id($uniqueSes);
			session_start();
 		
            $_SESSION['UserSes'] = $token;

            $response = array(
            	"success" => 1,
				"tokenID" => $uniqueSes,
				"token"   => $token
			);

            echo json_encode($response);
            return true;
    	
    	
    	} else {

 		    $response = array(
 		    	"success" 		=> 0,
 		    	"token" 		=> 0,
				"error_message" => "Oops! Unknown letters or spaces in username!"
			);

 		    echo json_encode($response);
            return false;
        
    	}
    
	break;

    }
     
?>
