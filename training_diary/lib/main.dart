import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:training_diary/view/all_layout.dart';
import 'package:training_diary/view/myCarousel.dart';
import 'package:wakelock/wakelock.dart';


void main() => runApp( const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Gorilla Journey';

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: appTitle,
      darkTheme: ThemeData.dark(),
      home: MyHomePage(title: appTitle),
      routes: {
        //'/' : (context) => const MyApp(),
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
      appBar: AppBar(title: Text(title), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: Column(
        children: [
          SizedBox(
            height: 250.0,
            child: CarouselWithIndicatorDemo() ,
          ),
          SizedBox(height: 20,),
          Text("La citation du jour :", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
          CardRandomCitation()
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}

class CardRandomCitation extends StatelessWidget {
  CardRandomCitation({super.key});

  final List<Map> citations = [
    {'citation' : "La force ne vient pas de la victoire. Ce sont vos efforts qui développent vos forces", 'auteur' : "Arnold Schwarzenegger"},
    {'citation' : "L’échec n’est pas une option. Tout le monde doit réussir", 'auteur' : "Arnold Schwarzenegger"},
    {'citation' : "Rêvez grand et aspirez à quelque chose que les autres ne pensent pas être possible", 'auteur' : "Frank Zane"},
    {'citation' : "Cherchez le progrès, pas la perfection", 'auteur' : "Inconnu"},
    {'citation' : "Si vous pensez que vous allez échouer, alors vous allez probablement échouer", 'auteur' : "Kobe Bryant"},
    {'citation' : "Ce qui me fait constamment avancer, ce sont mes objectifs", 'auteur' : "Mohamed Ali"},
    {'citation' : "Prends soin de ton corps, c’est le seul endroit où tu es obligé de vivre", 'auteur' : "Inconnu"},
    {'citation' : "Seul l’homme qui sait ce que c’est d’être vaincu peut atteindre le plus profond de son âme et revenir avec le supplément de force qu’il faut pour gagner", 'auteur' : "Mohamed Ali"},
    {'citation' : "La volonté ne suffit pas, il faut savoir agir", 'auteur' : "Bruce Lee"},
    {'citation' : "Certains veulent que ça arrive. D’autres aimeraient que ça arrive. Et les autres font que ça arrive", 'auteur' : "Michaël Jordan"},
    {'citation' : "Les excuses ne brûlent pas des calories. Les exercices si", 'auteur' : "Inconnu"},
    {'citation' : "Se réveiller déterminé. Aller se coucher satisfait", 'auteur' : "Dwayne Johnson"},
    {'citation' : "Pour être un bon bodybuilder, il faut être d’abord un bon observateur", 'auteur' : "Serge Nubret"},
    {'citation' : "Crois-moi, quand tu aimes quelque chose, tu n’a pas besoin de motivation", 'auteur' : "Serge Nubret"},
    {'citation' : "Sang, sueur et respect. Les deux premiers, vous les donnez. Le dernier vous le gagnez.", 'auteur' : "The Rock"},
    {'citation' : "Be like water my friend !", 'auteur' : "Bruce Lee"},
  ];

  @override
  Widget build(BuildContext context) {
    citations.shuffle();
    return Card(
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
      );
  }
}

