<?php
class DB {

    protected static $instance;

    protected function __construct() {}

    public static function getInstance() {

        $ini = parse_ini_file(realpath(dirname(__FILE__) . '/../../resources/config/config.ini'));


        if(empty(self::$instance)) {

            $db_info = array(
                "db_host" => $ini['db_host'],
                "db_port" => $ini['db_port'],
                "db_user" => $ini['db_user'],
                "db_pass" => $ini['db_pass'],
                "db_name" => $ini['db_name'],
                "db_charset" => $ini['db_charset']);

            try {
                self::$instance = new PDO("mysql:host=".$db_info['db_host'].';port='.$db_info['db_port'].';dbname='.$db_info['db_name'], $db_info['db_user'], $db_info['db_pass']);
                self::$instance->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_SILENT);
                self::$instance->query('SET NAMES utf8mb4');
                self::$instance->query('SET CHARACTER SET utf8mb4');

            } catch(PDOException $error) {
                echo $error->getMessage();
            }

        }

        return self::$instance;
    }

    public static function setCharsetEncoding() {
        if (self::$instance == null) {
            //self::connect();
        }

        self::$instance->exec(
            "SET NAMES 'utf8mb4';
			SET character_set_connection=utf8mb4;
			SET character_set_client=utf8mb4;
			SET character_set_results=utf8mb4");
    }

    public static function closeInstance() {

        self::$instance = null;

    }
}

?>
