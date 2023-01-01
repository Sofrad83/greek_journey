import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';

List<Routine>? routines;

class RoutineScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RoutineScreenState();
  }
}

class RoutineScreenState extends State<RoutineScreen> {

  refresh(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mes routines"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      drawer: const MyDrawer(),
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
                  return RoutineItemWidget(routine: routine, notifyParent: refresh,);
                }, 
              );
            }else{
              return const Center(child: Text("Pas de routines :("),);
            }
          }else {
            return const Center(child: Text("Pas de routines :("),);
          }
        }, 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {return AddRoutineScreen();} ));
        },
        backgroundColor: Color.fromARGB(255, 220, 160, 58),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RoutineItemWidget extends StatelessWidget {
  final Routine routine;
  final Function() notifyParent;
  const RoutineItemWidget({Key? key, required this.routine, required this.notifyParent }) : super(key: key);
  
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return AddExerciceToRoutineScreen(routine : routine);} ));
                  },
                  icon: const Icon(Icons.edit)
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context){
                      return CupertinoAlertDialog(
                        title: const Text("Voulez-vous vraiment supprimer cette routine ?"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              TrainingDiaryDatabase.instance.deleteRoutine(routine.id);
                              notifyParent();
                              Navigator.of(context).pop();
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: const Text("Supprimée !"),
                                  content: Text("La routine \"${routine.nom}\" a été supprimée."),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK")
                                    ),
                                  ],
                                );
                              });
                            },
                            child: const Text("Oui")
                          ),
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Non")
                          )
                        ],
                      );
                    });
                  }, 
                  icon: const Icon(Icons.close, color: Colors.red,)
                )
              ],
            )
          ],
        ),
      );
  }
}