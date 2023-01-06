import 'package:flutter/material.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';
import 'package:training_diary/view/seanceScreen.dart';

class ChoisirRoutineScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return ChoisirRoutineScreenState();
  }
}

class ChoisirRoutineScreenState extends State<ChoisirRoutineScreen> {
  List<Routine>? routines;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Choisir une routine"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      drawer: MyDrawer(),
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("img/carousel-start-seance.png", fit: BoxFit.cover,)
            ),
            Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 41, 47, 50).withOpacity(0.8)),
            ),
            Column(
              children: [
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10), 
                      child: Builder(builder: (context) {
                        return IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu, color: Color.fromARGB(255, 227, 174, 64), size: 40,));
                      }),
                    ),
                    Text(
                      "Choix d'une routine", 
                        style: TextStyle(
                        fontFamily: "Augustus", 
                        fontWeight: FontWeight.bold, 
                        color: Color.fromARGB(255, 227, 174, 64),
                        fontSize: 20
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10), 
                      child: Card(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)),),
                        margin: const EdgeInsets.all(8),
                        elevation: 8,
                        color: Color.fromARGB(255, 227, 174, 64),
                        child: Row(
                          children: [
                            Container(
                              width: 30, 
                              height: 30,
                              child: Card(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)),),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5, 
                                      height: 5,
                                    )
                                  ],
                                )
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ],
                ),
                Expanded(
                  child: FutureBuilder<List<Routine>>(
                    future: TrainingDiaryDatabase.instance.getAllRoutines(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        routines = snapshot.data;
                        if(routines!.isNotEmpty){
                            return ListView.builder(
                            itemCount: routines?.length,
                            itemBuilder: (context, index) {
                              final routine = routines![index];
                              return ChoisirRoutineItemWidget(routine: routine);
                            }, 
                          );
                        }else{
                          return const Center(child: Text("Pas de routines :( \nAllez d'abord créer des routines."),);
                        }
                      }else {
                        return const Center(child: Text("Pas de routines :( \nAllez d'abord créer des routines."),);
                      }
                    }, 
                  ),
                )
              ],
            )
          ],
        ),
    );
  }
}

class ChoisirRoutineItemWidget extends StatelessWidget {
  final Routine routine;
  const ChoisirRoutineItemWidget({Key? key, required this.routine}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      return Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
        margin: const EdgeInsets.all(8),
        elevation: 8,
        child: Row(
          children: [
            const Image(
              image: AssetImage("img/drawer.png"),
              width: 100,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(routine.nom, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Romanica", color: Color.fromARGB(255, 220, 160, 58)),),
                    ),
                    Text(
                      routine.description, 
                      style: TextStyle(color: Color.fromARGB(255, 144, 105, 36), fontSize: 16,fontFamily: "Romanica"),
                    )
                  ],
                )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return SeanceScreen(routine : routine);} ));
                  },
                  icon: const Icon(Icons.check_circle, color: Colors.green,)
                )
              ],
            )
          ],
        ),
      );
  }
}