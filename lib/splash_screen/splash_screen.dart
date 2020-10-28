import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_covid19/covid19/covid_widget.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  startTime() async {
    var _duration =  Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CovidWidget()));
  }

  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      //appBar: AppBar(),

      body: Container(
        alignment: Alignment.center,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80,),
            Container(
                width: 200,
                height:  200,
                //child: SvgPicture.asset("images/corona.svg"),
                child: Image.asset("images/corona2.png"),
            ),
            SizedBox(height: 16,),
            Text("THÔNG TIN COVID-19", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
