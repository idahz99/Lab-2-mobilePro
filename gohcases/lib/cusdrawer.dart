import 'package:flutter/material.dart';
import 'package:gohcase/orderhistory.dart';
import 'package:gohcase/profile.dart';
import 'Login.dart';
import 'User.dart';
import 'cart.dart';
import 'mainscreen.dart';


class CusDrawer extends StatefulWidget {
  final User user;

  const CusDrawer({Key key, this.user}) : super(key: key);
  @override
  _CusDrawerState createState() => _CusDrawerState();
}

class _CusDrawerState extends State<CusDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.pink[100]),
          accountEmail: Text(widget.user.email),
          currentAccountPicture: ClipOval(
                 
                    child:              
                   FadeInImage(image: NetworkImage( "https://crimsonwebs.com/s269349/GohCases/images/Profilepicture/${widget.user.id}.png"), placeholder: AssetImage("assets/images/defaultpic.jpg"),
                   fadeInDuration:const Duration(seconds:2) ,
                   height: 240,
                   width: 240,
                   fit: BoxFit.cover,
           
          ),
          ),
          accountName: Text(widget.user.username),
        ),
        ListTile(
        
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => MainScreen(
                            user: widget.user,
                          )));
            }),
        ListTile(
          leading:Icon(Icons.person_outline),
            title: Text("My Profile"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Myprofile(user:widget.user                       
                          )));
            }),
        ListTile(
            leading:Icon(Icons.shopping_cart),
            title: Text("My Cart"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Cart(
                          user:widget.user,email:widget.user.getemail()
                          )));
            }),
        ListTile(
            leading:Icon(Icons.history),
            title: Text("Orders"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => CusOrder(
                          user:widget.user
                          )));
            }),
        ListTile(
            title: Text("Signout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Login(
                          
                          )));
            }),
      
      ],
    ));
  }
}