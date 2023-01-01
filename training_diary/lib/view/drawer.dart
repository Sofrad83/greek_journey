import 'package:flutter/material.dart';
import 'all_layout.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      child:  Image.asset("img/drawer.png", fit: BoxFit.cover,)
                    ),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Color.fromARGB(255, 220, 160, 58).withOpacity(0.6),
                    ),
                    Container(
                      height: 100,
                      width: 65,
                      child: const Center(child: Text("Menu")),
                    )
                    
                  ]
                ),
                ListTile(
                  title: const Text('Accueil'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
                ListTile(
                  title: const Text('Exercices'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/exercice');
                  },
                ),
                ListTile(
                  title: const Text('Routines'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/routine');
                  },
                ),
              ],
            ),
          );
  }
}