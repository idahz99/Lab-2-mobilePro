import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Login.dart';
import 'package:http/http.dart' as http;

class RegisterApp extends StatefulWidget {
  @override
  _RegisterAppState createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _newemail = new TextEditingController();
  TextEditingController _newpassworda = new TextEditingController();
  TextEditingController _newpasswordb = new TextEditingController();
  ProgressDialog progress;
 
  bool _isChecked = false;
 
  @override
  Widget build(BuildContext context) {
   
    progress = ProgressDialog(context);
    progress.style(
      message: 'Signing In',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
         resizeToAvoidBottomInset: false,
        body: Center(
            child: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            constraints: BoxConstraints.expand(),
            child: FittedBox(
                child: Image.asset("assets/images/colourful.jpg"),
                fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Text("Register new user.",style:TextStyle(fontSize:18),),
                    TextField(
                      controller: _newemail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                     hintText: 'Email',
                      ),
                      
                    ),
                    TextField(
                      controller: _username,
                       keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        hintText: 'Username',
                      ),
                    ),
                    TextField(
                      controller: _newpassworda,
                      obscureText: true,
                       keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    TextField(
                      controller: _newpasswordb,
                      obscureText: true,
                       keyboardType: TextInputType.text,
                      decoration: new InputDecoration(
                        hintText: 'Re-enter Password',
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Checkbox(
                            value: _isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                _isChecked =value;
                              });
                             
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: _terms,
                          child: Text('I have read and accept terms and conditions ',
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    ),
                    MaterialButton(
                        color: Colors.redAccent[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Register new user'),
                        onPressed: _isChecked? (registeration):null,
                        ),
                    GestureDetector(
                      onTap: alreadyreg,
                      child: Text('Already have and account.'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  bool validatePassword(String value) {
   
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$';
    RegExp regExp = new RegExp(pattern);
    print(regExp.hasMatch(value));
    return regExp.hasMatch(value);
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  void registeration() {
    String _uname = _username.text.toString();
    String _email = _newemail.text.toString();
    String _passa = _newpassworda.text.toString();
    String _passb = _newpasswordb.text.toString();
    if (_passa.isEmpty || _passb.isEmpty || _email.isEmpty || _uname.isEmpty) {
      Fluttertoast.showToast(
          msg: "Missing credentials.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    } else if (!(_passa == _passb)) {
      Fluttertoast.showToast(
          msg: "Passwords not matching",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    } else if (_passa.length < 8) {
      Fluttertoast.showToast(
          msg: "Password too short.Please enter 8 characters or more ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    } else if (!validateEmail(_email)) {
      Fluttertoast.showToast(
          msg: "Invalid email ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    } else if (!validatePassword(_passa)) {
      Fluttertoast.showToast(
          msg: "should contain one upper and lower case.one digit and special character",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
    return;
    }
   
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text("Register new user"),
            content: Text("Are your sure?"),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _acRegister(_uname, _email, _passa);
                },
              ),
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
  void _terms(){
    showDialog(context: context, 
    builder:(BuildContext context) {
    return AlertDialog(
    content: Text("End-User Liscense Agreement"),


    );
 

   
    }
    );
  }

  void alreadyreg() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (content) => Login()));
  }

  

  Future<void> _acRegister(
      String username, String email, String password) async {
   
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/Registration.php"),
        body: {
          "username": username,
          "email": email,
          "password": password
        }).then((response) {
      print(response.body);
      if (response.body == "success") 
      {
        Fluttertoast.showToast(
            msg:
                "Registration Success. Please check your email for verification link",
            toastLength: Toast.LENGTH_SHORT,
            
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
        
       FocusScope.of(context).unfocus();
        _newpasswordb.clear();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => Login()));
      } else if (response.body == "fail") {
        Fluttertoast.showToast(
            msg: "Registration Failed",
            toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
      
      }
    });
  }

  
       

  
 
}
 

