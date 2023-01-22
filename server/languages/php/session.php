<?php
require_once ('database.php');
include("encoder.php");

error_reporting(0); //Turn OFF error exceptions.

class MySessionHandler

{

    private static $lifetime = 0; 

    public function __construct() //object constructor
    { 

       session_set_save_handler(
           array($this,'open'),
           array($this,'close'),
           array($this,'read'),
           array($this,'write'),
           array($this,'destroy'),
           array($this,'gc')
       );
    }


     public function open()

    {
     
        $GLOBALS['db'] = DB::getInstance();
        DB::setCharsetEncoding();

  		return true;
	}

    public static function read($id)
    {

		$db = $GLOBALS['db'];

        $stmt = $db->prepare("SELECT 
                              Ses_User 
                              FROM 
                              SESSION 
                              WHERE Ses_ID = ? LIMIT 1"
        );

        $stmt->execute([$id]);
        $arr = $stmt->fetch(PDO::FETCH_ASSOC);
		
		//return $arr['Ses_User'];
		
		return $arr['Ses_User'] ?? '';

        
    }

    public static function write($id, $data)
    {   

        $db = $GLOBALS['db'];

		if ($data != NULL || $data != "") {
		
		    date_default_timezone_set('America/New_York');
			$date = date('Y-m-d H:i:s');

            $stmt = $db->prepare("SELECT 
                                  CONCAT(Param_Value_Integer,' ', Param_UOM) AS Exp_Date
                                  FROM PARAMETER 
                                  WHERE Param_Code = ?"
            );

            $stmt->execute(['POLICY_SESSION']);
            $arr = $stmt->fetch(PDO::FETCH_ASSOC);

            $expDate = $arr['Exp_Date'];
            $exp = date('Y-m-d H:i:s', strtotime("+$expDate"));

            $stmt = $db->prepare(
                                        "REPLACE
                                         INTO
                                         SESSION
						                 (Ses_ID, 
						                  Ses_User, 
						                  Ses_Started, 
       		                              Ses_Expires) VALUES 
       		                             (?, 
       		                              ?, 
       		                              ?, 
       		                              ?)"
                                     );

            $stmt->execute([$id, $data, $date, $exp]);


		 } else {
		 
            return false;
            
         }
             
		 
    }

    public static function destroy($id)
    {   
    global $db;
    
    $db = $GLOBALS['db'];

        $stmt = $db->prepare(
            "DELETE 
			 FROM 
			 SESSION  
			 WHERE Ses_ID = ?"
        );

        $stmt->execute([$id]);
        
        return true;
    }

    public static function gc()
    {
        return true;
    }

    public static function close()
    {

	$db = $GLOBALS['db'];

   global $db;
        DB::closeInstance();
        return true;
    }

    public function __destruct()
    {
        //session_write_close(true);
        return true;
    }
    
}

?>