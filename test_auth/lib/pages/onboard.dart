import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as Math;

import 'package:test_auth/pages/auth.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with TickerProviderStateMixin{


  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  final initial = Tween(begin: 0, end: 0);
  final forward = Tween(begin: 0, end: Math.pi);

  late var tween = forward;
  @override

Future<void> delay() async{
  await Future.delayed(Duration(seconds: 10));
}

  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    
   late var tween = forward;
   setState(() {
     
   });
 /// _controller.forward();
    super.initState();
  }

  Color colorText = Colors.transparent;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );
 /// double turns = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.red,
          child: Center(
              child: Stack(
            children: [
              
              Center(child: Image.asset('assets/Wheel.png')),

              Center(
                child: Container(
                 /// color: Colors.grey,
                  width: 256,
                  height: 265,

                  child: Stack(children: [

                    
                       Padding(
                         padding: const EdgeInsets.only(top:230.0),
                         child: Center(child: Text("AUTOM APP", style: TextStyle(color: colorText, fontSize: 30, fontWeight: FontWeight.bold),)),
                       ),
                       Center(child: (Image.asset('assets/base.png')),
                       
                       
                      
                    ),
                  
                   
                    Padding(
                      padding: const EdgeInsets.only(left:55.0, right: 65, top: 120),
                      child: Builder(
                        builder: (context) {
                          return TweenAnimationBuilder(
                           /// curve: Curves.,
                            onEnd: ()async{
                              log("EEEND");
                              setState(() {
                                colorText=Colors.white;
                              });
                              await Future.delayed(Duration(seconds: 1), (){});

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const AuthPage()),
                                );
                                
                             

                            },
                            duration: Duration(seconds: 1),
                            tween: tween,
                            builder:(context, value, child) 
                            {
                              return Transform.rotate(
                              angle:  value.toDouble(),
                              origin: Offset(32, -30),
                              child: Image.asset("assets/arr.png"));
                          
                            }, 
                            
                          );
                        }
                      )
                    ),
                   Center(child: Image.asset("assets/point.png")),
                    
                  ]),
                ),

                
              ),

              ////Center(child: Image.asset('assets/arrow.png'))
            ],
          )),
        ),
      ),
    );
  }
}
