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
      //appBar: AppBar(title: const Text("Mes routines"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      drawer: const MyDrawer(),
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("img/carousel-routine.png", fit: BoxFit.cover,)
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
                      "Mes routines", 
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
                )
              ],
            )
          ],
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
              image: AssetImage("img/routines.png"),
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
                      style: TextStyle(color: Color.fromARGB(255, 144, 105, 36), fontSize: 16, fontFamily: "Romanica"),
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