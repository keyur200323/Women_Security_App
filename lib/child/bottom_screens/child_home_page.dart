

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:security/widgets/home_widgets/CustomCarouel.dart';
import 'package:security/widgets/home_widgets/custom_appBar.dart';
import 'package:security/widgets/home_widgets/emergency.dart';
import 'package:security/widgets/home_widgets/safehome/SafeHome.dart';
import 'package:security/widgets/live_safe.dart';



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //const HomeScreen({super.key});
  int qIndex=2;

  getRandomQuote(){
    Random random = Random();

    setState(() {
      qIndex=random.nextInt(6);
    });
  }
  @override
  void initState() {
    getRandomQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:[
              CustomAppBar(
                  quoteIndex: qIndex,
                  onTap: (){
                    getRandomQuote();
                  }),
              Expanded(
                  child:ListView(
                    shrinkWrap: true,
                    children: [
                      CustomCarouel(),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Text(
                            "Emergency",
                            style:
                            TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          )
                      ),
                      Emergency(),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:Text(
                            "Explore LiveSafe",
                            style:
                            TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          )
                      ),
                      LiveSafe(),
                      SafeHome(),
                    ],
                  )

              )

            ],
          ),
        ),
      ),
    );
  }
}
//Safearea is used to keep content on our screen
//qIndex is for the quotes
//randomquotes is used to get random quotes(6) because tere are 6 quotes in quotes.dart
//in stateless widget there is no changes in Ui in runtime
//setstate is used to change the state