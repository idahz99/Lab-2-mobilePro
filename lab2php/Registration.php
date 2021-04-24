<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s269349/GohCases/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s269349/GohCases/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s269349/GohCases/php/PHPMailer/src/SMTP.php';


include_once("dbconnector.php");
    
$Username   =$_POST['username'];
$email   =$_POST['email'];
$password =$_POST['password'];
$encryptedpass =sha1($password);
$OTP = rand(1000,9999);


$sqlregistration ="INSERT INTO tabel_Users (Email , Password ,OTP, username ) VALUES  ('$email','$encryptedpass','$OTP','$Username') ";
if ($conn->query($sqlregistration)===TRUE){
       echo "success";
      sendEmail($OTP,$email,$Username);
}else {
    echo "fail";
}

function sendEmail($OTP,$email,$Username){
    $mail = new PHPMailer(true);

    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'gohcases@crimsonwebs.com';                  //SMTP username
    $mail->Password   = 'xv.Y6mvyJ)aq';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       =  587;
    
    $from = "gohcases@crimsonwebs.com";
    $to = $email;
    $subject = 'From GohCases.Please verify your account';
    $message = "<p>Click the following link to verify your account<br><br><a href='https://crimsonwebs.com/s269349/GohCases/php/Verification.php?email=".$email."&key=".$OTP."'>Click Here</a>";
    
    $mail->setFrom($from,"GohCases");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();

}

?>