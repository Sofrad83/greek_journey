import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_diary/model/exercice.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';

List<Exercice>? exercices;

class ExerciceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExerciceScreenState();
  }
}

class ExerciceScreenState extends State<ExerciceScreen> {

  refresh(){
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Mes exercices"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      drawer: const MyDrawer(),
      body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset("img/carousel-exercice.png", fit: BoxFit.cover,)
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
                      "Mes exercices", 
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
                  child: FutureBuilder<List<Exercice>>(
                  future: TrainingDiaryDatabase.instance.getAllExercices(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        exercices = snapshot.data;
                        if(exercices!.isNotEmpty){
                            return ListView.builder(
                            itemCount: exercices?.length,
                            itemBuilder: (context, index) {
                              final exercice = exercices![index];
                              return ExerciceItemWidget(exercice: exercice, notifyParent: refresh,);
                            }, 
                          );
                        }else{
                          return const Center(child: Text("Pas d'exercices :("),);
                        }
                      }else {
                        return const Center(child: Text("Pas d'exercices :("),);
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {return AddExerciceScreen();} ));
        },
        backgroundColor: Color.fromARGB(255, 220, 160, 58),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExerciceItemWidget extends StatelessWidget {
  final Exercice exercice;
  final Function() notifyParent;
  const ExerciceItemWidget({Key? key, required this.exercice, required this.notifyParent }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      return Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40)),),
        margin: const EdgeInsets.all(8),
        elevation: 8,
        child: Row(
          children: [
            const Image(
              image: AssetImage("img/exercice.png"),
              width: 100,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(exercice.nom, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "Romanica", color: Color.fromARGB(255, 220, 160, 58)),),
                    ),
                    Text(
                      exercice.description, 
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
                    showDialog(context: context, builder: (BuildContext context){
                      return CupertinoAlertDialog(
                        title: const Text("Voulez-vous vraiment supprimé cet exercice ?"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              TrainingDiaryDatabase.instance.deleteExercice(exercice.id);
                              notifyParent();
                              Navigator.of(context).pop();
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: const Text("Supprimé !"),
                                  content: Text("L'exercice \"${exercice.nom}\" a été supprimé."),
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