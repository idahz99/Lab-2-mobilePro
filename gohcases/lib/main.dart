import 'dart:async';
import 'package:flutter/material.dart';
import 'Login.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home:Splashscreen()
    );
  }
}

class Splashscreen extends StatefulWidget {
  @override
  SplashscreenState createState()=> SplashscreenState();
   
  
}
class SplashscreenState extends State<Splashscreen>{
@override
void initState(){
super.initState();
  Timer (Duration(seconds:4),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (content)=>Login())));
}

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home:Scaffold(
      body:Center(
        child:Stack(
      children :<Widget> [
      Container(
        height: double.infinity,
       width: double.infinity,
       constraints: BoxConstraints.expand(),
      child:FittedBox (child:Image.asset("assets/images/japanese.jpg"),
        fit: BoxFit.cover),
            ),
        
         Row(
             mainAxisAlignment:MainAxisAlignment.center,
           
             children: [
                SizedBox(height:200),
            Image.asset("assets/images/cover.png",scale:30),
           ],
         )
      
      ]
        )
      )
    )
     
   );
   
  }


  }
  
