import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:training_diary/view/all_layout.dart';
import 'package:training_diary/view/myCarousel.dart';
import 'package:wakelock/wakelock.dart';


void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Greek Journey';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: appTitle,
      darkTheme: ThemeData.dark(),
      home: MySplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name){
          case '/accueil' :
            return PageTransition(child: MyHomePage(title: appTitle), type: PageTransitionType.fade, duration: Duration(milliseconds: 1000));
        }
      },
      routes: {
        '/exercice' : (context) => ExerciceScreen(),
        '/routine' : (context) => RoutineScreen(),
        '/choisirSeance' : (context) => ChoisirRoutineScreen()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text(title), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: 
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("img/home_background.png", fit: BoxFit.cover,)
            ),
            Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 41, 47, 50).withOpacity(0.8)),
            ),
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10), 
                            child: Builder(builder: (context) {
                              return IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu, color: Color.fromARGB(255, 227, 174, 64),));
                            }),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10), 
                            child: Card( // with Card
                                child: Image.asset('img/top_r_logo.png', height: 40,),
                                elevation: 18.0,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                              ),
                            
                          )
                        ],
                      ),
                      SizedBox(height: 50,),
                      RandomCitation(),
                      SizedBox(height: 35,),
                      SizedBox(
                        height: 250.0,
                        child: CarouselWithIndicatorDemo() ,
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                  color: Color.fromARGB(255, 227, 174, 64),
                ),
                SizedBox(height: 40,)
              ],
            ),
          ],
        ),
      
      drawer: const MyDrawer(),
    );
  }
}

class RandomCitation extends StatelessWidget {
  RandomCitation({super.key});

  final List<Map> citations = [
    {'citation' : "C'est une honte qu'un homme vieillisse sans voir la beauté et la force dont son corps est capable.", 'auteur' : "Socrate"},
    {'citation' : "Connais-toi toi-même.", 'auteur' : "Socrate"},
    {'citation' : "Les maux du corps sont les mots de l'âme, ainsi on ne doit pas chercher à guérir le corps sans chercher à guérir l'âme.", 'auteur' : "Platon"},
    {'citation' : "Repose-toi d'avoir bien fait, et laisse les autres dire de toi ce qu'ils veulent.", 'auteur' : "Pythagore"},
    {'citation' : "L'ignorant affirme, le savant doute, le sage réfléchit.", 'auteur' : "Aristote"},
    {'citation' : "On ne peut mieux vivre qu'en cherchant à devenir meilleur, ni plus agréablement qu'en ayant la pleine conscience de son amélioration.", 'auteur' : "Socrate"},
  ];

  @override
  Widget build(BuildContext context) {
    citations.shuffle();
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 40), 
                child: Text(
                  "QUOTE DIEI", 
                  style: TextStyle(
                    fontFamily: "Augustus", 
                    fontWeight: FontWeight.bold, 
                    color: Color.fromARGB(255, 227, 174, 64),
                    fontSize: 30
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Text(
              citations.first['citation'], 
              style: TextStyle(
                fontFamily: "Romanica",
                color: Color.fromARGB(255, 227, 174, 64),
                fontSize: 20
              )
            ,),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Padding(
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Text(
                citations.first['auteur'],
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: "Augustus",
                  color: Color.fromARGB(255, 227, 174, 64),
                  fontSize: 22
                )
              ,),
            )],
          )
        ]
      ),
    );
    /*Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),),
        margin: const EdgeInsets.all(8),
        elevation: 8,
        child: Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(padding: EdgeInsets.only(left: 8, right: 8), child: Text(citations.first['citation'], style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(padding: EdgeInsets.only(right: 8), child: Text(citations.first['auteur'], style: const TextStyle(fontWeight: FontWeight.bold)),)
              ],
            )
          ]
        ),)
        ,
      );*/
  }
}

