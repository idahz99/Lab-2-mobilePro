import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';
import 'User.dart';
import 'adminmainscreen.dart';
import 'adminorders.dart';

class Dashpage extends StatefulWidget {
  final User user;

  const Dashpage({Key key, this.user}) : super(key: key);

  @override
  _DashpageState createState() => _DashpageState();
}

class _DashpageState extends State<Dashpage> {
  String users = '';
  @override
  initState() {
    _loadusers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Stack(children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.redAccent[100],
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 30),
              Text(' Admin Dashboard',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 50),
              Expanded(
                child: GridView.count(
                  childAspectRatio: 0.85,
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(15),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) =>
                                    AdminmainS(user: widget.user)));
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/images/producticon.jpg"),
                              Text("Products", textAlign: TextAlign.center)
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/images/numusers.jpg"),
                              Text("Customers " + users,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) =>
                                    Adminorders(user: widget.user)));
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Image.asset("assets/images/History-Icon.png"),
                              Text("Orders", textAlign: TextAlign.center)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content) => Login()));
                },
                child: Text("Logout"),
              )
            ],
          )
        ]),
      ),
    );
  }

  void _loadusers() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/countusers.php"),
        body: {}).then((response) {
      print(response.body);

      setState(() {
        users = response.body;
      });
    });
  }
}
