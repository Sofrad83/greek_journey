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
      appBar: AppBar(title: const Text("Choisir une routine"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      drawer: MyDrawer(),
      body: FutureBuilder<List<Routine>>(
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
              image: AssetImage("img/routine.png"),
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
                      child: Text(routine.nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ),),
                    ),
                    Text(
                      routine.description, 
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
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