import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import 'User.dart';
import 'mainscreen.dart';
 
void main() => runApp(Paypage());
 
class Paypage extends StatefulWidget {
 final User user;
 final String deliveryaddress;
  final String nameentered;
  final String phonenumentered;
  final String total;
  const Paypage({Key key, this.user, this.deliveryaddress, this.nameentered, this.phonenumentered, this.total}) : super(key: key);
  @override
  _PaypageState createState() => _PaypageState();
}
 
class _PaypageState extends State<Paypage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
@override
  initState() {
    _printname();
        super.initState();
      }
      @override
        Widget build(BuildContext context) {
        return  Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[100],
              title: Text('Payment'),
              leading: GestureDetector(
    onTap: () {Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                           MainScreen(user:widget.user),
                      ),
                    ); },
    child: Icon(
      Icons.arrow_back_rounded,  
    ),
  ),
            ),
            body: Center(
              child: Container(
                child: Column(
                  children: [
                     Expanded(
                      child: WebView(
                        initialUrl:
                            "https://crimsonwebs.com/s269349/GohCases/php/generate_bill.php?email=" +
                                widget.user.email +
                                '&phone=' +
                                widget.phonenumentered +
                                '&name=' +
                                widget.nameentered +
                                '&amount=' +
                                widget.total + 
                                '&address=' + 
                                widget.deliveryaddress,
                    javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController webViewController) {
                          _controller.complete(webViewController);
                        },
                      ),
                    )
                  ]
                ),
              ),
        ),);
      
      }
    
      void _printname() {
 
        print( widget.user.email);
        print((widget.phonenumentered).toString());
        print(( widget.nameentered).toString());
         print((widget.deliveryaddress).toString());
      }
}