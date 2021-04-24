import 'package:flutter/material.dart';

 

 
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child:Column(
            children:<Widget> [
              Text('Hello World'),
              MaterialButton( 
                color: Colors.redAccent[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Logout'),
                onPressed: () {
                  Navigator.of(context).pop();
               } ,
               )
                ],
            )
            

          ),
        ),
      ),
    );
  }
}