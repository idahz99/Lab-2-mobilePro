<?php
error_reporting(0);
include_once("dbconnector.php");
$email   =$_GET['email'];
$OTP = $_GET['key'];

$sql = "SELECT * FROM tabel_Users WHERE Email ='$email' AND OTP ='$OTP'";
$result=$conn->query($sql);
if($result-> num_rows > 0){
   $sqlupdate ="UPDATE tabel_Users SET OTP= '0' WHERE Email='$email' AND OTP = '$OTP'";
if ($conn->query($sqlupdate)===TRUE){
    echo "success";
}else {
    echo "Fail";
}
}else{
    echo "failed";
}
?>