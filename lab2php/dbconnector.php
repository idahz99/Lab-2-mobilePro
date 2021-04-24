<?php
$servername="localhost";
$username= "crimsonw_gohcasesuser";
$password= "w)}e[9O0DqSj";
$dbname = "crimsonw_gohcasesdb";
$conn = new mysqli($servername,$username,$password,$dbname);
if($conn-> connect_error){
    die("Connection failed : ".$conn-> connect_error );
}

?>