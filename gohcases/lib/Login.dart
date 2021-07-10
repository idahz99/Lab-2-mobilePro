import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gohcase/adminaddProduct.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Register.dart';
import 'User.dart';
import 'adminmainscreen.dart';
import 'dashboard.dart';
import 'mainscreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _remember = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  SharedPreferences preferences;
  @override
  void initState() {
   loadinput();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Welcome back!',
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: new InputDecoration(
                        hintText: 'E-mail',
                      ),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: 'Password',
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Checkbox(
                            value: _remember,
                            onChanged: (bool value) {
                              _changestatus(value);
                             //setState(() {
                               // _remember =value;
                            //  });
                             
                             
                             
                            },
                          ),
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(''),
                      ],
                    ),
                    MaterialButton(
                        color: Colors.redAccent[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Login'),
                        onPressed: _userLogin),
                    MaterialButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Register',
                            style: TextStyle(color: Colors.black)),
                        onPressed: _register),
                    GestureDetector(
                      onTap: _forgotpass,
                      child: Text('Forgot Password ?'),
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

  Future<void> _userLogin() async {
   

    String _useremail = _email.text.toString();
    String _userpassword = _password.text.toString();
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/Login.php"),
        body: {
          "email": _useremail,
          "password": _userpassword
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Login Failed check your password or Email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
       
      } else {
                Fluttertoast.showToast(
            msg: "Login Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
            List udata = response.body.split(",");
            User user=User(
              username: udata[1],
              email: _useremail,
              password: _userpassword,
              date:udata[2],
              status: udata[3],
              id : udata[4],
              address: udata[5],
              phonenum: udata[6],
            );
            if (udata[3]=="User"){
        Navigator.push(
            context, MaterialPageRoute(builder: (content) => MainScreen(user: user)));
            }else {
               Navigator.push(
            context, MaterialPageRoute(builder: (content) => Dashpage(user: user)));
            //do not forget to change back
            }
      }
    });
  }

  void _register() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => RegisterApp()));
  }
  void _forgotpass() {
     TextEditingController _recoveryemail = TextEditingController();
  
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Recover password"),
            content: new Container(
                height: 100,
                child: Column(
                  children: [
                    
                    TextField(
                      controller: _recoveryemail,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                    )
                  ],
                )),
            actions: [
              TextButton(
                child:Text("Submit"),
                 onPressed: () {
                  print(_recoveryemail.text);
                  _forgotpassver(_recoveryemail.text.toString());
                  Navigator.of(context).pop();
                },
              ),
               TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('cancel'),
               ),
             ] ,);
        },
        );
  



  }
       

  void _forgotpassver(String p) {
   http.post(
        Uri.parse(
              "https://crimsonwebs.com/s269349/GohCases/php/resetpass.php"),
        body: {
           "email": p
        
        }).then((response) {
         print(response.body);
      if (response.body == "success"){
      Fluttertoast.showToast(
            msg: "Password can now be reset.please check your e-mail",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
      }else{
         Fluttertoast.showToast(
            msg: "could not reset the password.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
      }
        
        
  }
  );}
  Future<void> storeinput(bool value, String email, String password) async {
    preferences = await SharedPreferences.getInstance();
    if (value ) {
      await preferences.setString("email", email);
      await preferences.setString("password", password);
      await preferences.setBool("checked", value);
      Fluttertoast.showToast(
          msg: "credentials saved ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
          return;
    } else {
      await preferences.setString("email", "");
      await preferences.setString("password", "");
      await preferences.setBool("checked", value);
      Fluttertoast.showToast(
          msg: "credentials removed ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        _email.text = "";
        _password.text = "";
        _remember = false;
      });
      return;
    }
  }

  Future<void> loadinput() async {
    preferences = await SharedPreferences.getInstance();
    String _uemail = preferences.getString("email") ?? '';
    String _upassword = preferences.getString("password") ?? '';
    _remember = preferences.getBool("checked") ?? false;

    setState(() {
      _email.text = _uemail;
      _password.text = _upassword;
    });
  }

  void _changestatus(bool value) {
    String _uemail = _email.text.toString();
    String _upassword = _password.text.toString();

    if (_uemail.isEmpty ||_upassword.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill in your email and password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    setState(() {
      _remember = value;
      storeinput(value, _uemail,_upassword);
    });
  }
}
