import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shimmer/shimmer.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async{
    await Future.delayed(Duration(milliseconds: 3000), (){});
    Navigator.pushReplacementNamed(context, "/accueil");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child:  Image.asset("img/splashscreen.png", fit: BoxFit.cover,)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 300,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    child: Text(
                      "Greek\nJourney", 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontFamily: 'Augustus', 
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),
                    ), 
                    baseColor: Color.fromARGB(255, 227, 174, 64), 
                    highlightColor: Color.fromARGB(255, 234, 199, 133),
                    period: Duration(milliseconds: 3000),
                  )
                  
                ],
              )
            ],
          )
          
        ],
      ),
    );
  }
}