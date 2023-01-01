import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'all_layout.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  child:  Image.asset("img/drawer-1.png", fit: BoxFit.cover,)
                ),
                Container(
                  decoration: BoxDecoration(color: Color.fromARGB(255, 41, 47, 50).withOpacity(0.9)),
                ),
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 50,),
                          Container(
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: Image.asset("img/icon-2.png", fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Shimmer.fromColors(
                            baseColor: Color.fromARGB(255, 227, 174, 64), 
                            highlightColor: Color.fromARGB(255, 234, 199, 133),
                            period: Duration(milliseconds: 2000),
                            child: Text(
                              "GREEK JOURNEY", 
                              style: TextStyle(
                                fontFamily: "Augustus", 
                                fontWeight: FontWeight.bold, 
                                color: Color.fromARGB(255, 227, 174, 64),
                                fontSize: 20
                              ),
                            ),
                          ),
                        ]
                      ),
                    ),
                    SizedBox(height: 25,),
                    ListTile(
                      title: Text("Accueil", style: TextStyle(
                        fontFamily: "Romanica", 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 20
                      ),),
                      onTap: () => Navigator.pushReplacementNamed(context, "/accueil"),
                    ),
                    ListTile(
                      title: Text("S'exercer", style: TextStyle(
                        fontFamily: "Romanica", 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 18
                      ),),
                      onTap: () => Navigator.pushReplacementNamed(context, "/choisirSeance"),
                    ),
                    ListTile(
                      title: Text("Exercices", style: TextStyle(
                        fontFamily: "Romanica", 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 18
                      ),),
                      onTap: () => Navigator.pushReplacementNamed(context, "/exercice"),
                    ),
                    ListTile(
                      title: Text("Routines", style: TextStyle(
                        fontFamily: "Romanica", 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 18
                      ),),
                      onTap: () => Navigator.pushReplacementNamed(context, "/routine"),
                    ),
                    ListTile(
                      title: Text("À venir ...", style: TextStyle(
                        fontFamily: "Romanica", 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 18
                      ),),
                      onTap: () => print("ah !"),
                    ),

                  ],
                )
              ]
            ),
          );
  }
}