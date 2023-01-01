
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:training_diary/model/exercice.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/model/routineHasExercice.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';


class AddExerciceToRoutineScreen extends StatefulWidget {
  final Routine routine;
  const AddExerciceToRoutineScreen({super.key, required this.routine});

  @override
  State<AddExerciceToRoutineScreen> createState() => _AddExerciceToRoutineScreenState(routine);
}

class _AddExerciceToRoutineScreenState extends State<AddExerciceToRoutineScreen> {
  final Routine routine;
  late String selectedIndex  = "0";
  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Exercice> _myExercices = [];
  bool _myExercicesRequest = false;

  _AddExerciceToRoutineScreenState(this.routine);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getExercice();
    });
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("\"${routine.nom}\" - ajouter exercices"),
          backgroundColor: Color.fromARGB(255, 220, 160, 58),
        ),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        body: FutureBuilder<List<Exercice>>(
          future: TrainingDiaryDatabase.instance.getAllExercices(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<Exercice>? exercices = snapshot.data;
              dropdownItems.clear();
              if(exercices!.isNotEmpty){
                  if(selectedIndex == "0"){
                      selectedIndex = exercices.first.id.toString();
                    }
                    exercices.forEach((element) {
                      dropdownItems.add(DropdownMenuItem(child: Text(element.nom), value: element.id.toString(),));
                    },);
                    return Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 70, bottom: 20), child: Text("Choisissez un exercice à ajouter :"),),
                        DropdownButton(
                          value: selectedIndex,
                          items: dropdownItems, 
                          onChanged: (String? value) {
                            setState(() {
                              selectedIndex = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 8.0,),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 220, 160, 58)),
                            onPressed: () async {
                              TrainingDiaryDatabase.instance.insertRoutineHasExercice(RoutineHasExercice(null, int.parse(selectedIndex), routine.id!));
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: const Text("Ajouté !"),
                                  content: const Text("L'exercice a bien été ajouté à la routine."),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          _myExercicesRequest = false;
                                        });
                                      },
                                      child: const Text("Ok")
                                      )
                                  ],
                                );
                              });
                            },
                            child: const Text("Ajouter"),
                          ),
                        ),
                        const SizedBox(height: 60.0,),
                        ListExercicesOfRoutine(exercices: _myExercices, routine: routine, refresh: () {
                          setState(() {
                            _myExercicesRequest = false;
                          });
                        },)
                      ],
                    );
              }else{
                dropdownItems.add(DropdownMenuItem(child: Text("Pas d'exercices :("), value: "0",));
                selectedIndex = "0";
                return Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 70, bottom: 20), child: Text("Choisissez un exercice à ajouter"),),
                    DropdownButton(
                    value: selectedIndex,
                    items: dropdownItems, 
                    onChanged: (String? value) {

                    }),
                    const SizedBox(height: 8.0,),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Créer des exercices pour en ajouter à la routine")));
                        },
                        child: const Text("Ajouter"),
                      ),
                    ),
                    const SizedBox(height: 60.0,),
                    ListExercicesOfRoutine(exercices: _myExercices, routine: routine, refresh: () {
                      setState(() {
                        _myExercicesRequest = false;
                      });
                    },)
                  ],
                );
              }
            }else {
              dropdownItems.add(DropdownMenuItem(child: Text("Pas d'exercices :("), value: "0",));
              selectedIndex = "0";
              return Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 70, bottom: 20), child: Text("Choisissez un exercice à ajouter"),),
                  DropdownButton(
                    value: selectedIndex,
                    items: dropdownItems, 
                    onChanged: (String? value) {

                  }),
                  const SizedBox(height: 8.0,),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Créer des exercices pour en ajouter à la routine")));
                      },
                      child: const Text("Ajouter"),
                    ),
                  ),
                  const SizedBox(height: 60.0,),
                  ListExercicesOfRoutine(exercices: _myExercices, routine: routine, refresh: (){
                    setState(() {
                      _myExercicesRequest = false;
                    });
                  })
                ],
              );
            }
          }, 
        ), 
      ), 
      onWillPop: () async{
        Navigator.pushReplacementNamed(context, '/routine');
        return true;
      }
    );
    ;
  }

  getExercice() async{
    if(_myExercicesRequest == false){
      List<Exercice> exercices = await TrainingDiaryDatabase.instance.getAllExercicesFromRoutine(routine);
      setState(() {
        _myExercices = exercices;
        _myExercicesRequest = true;
      });
    }
  }
}

class ListExercicesOfRoutine extends StatelessWidget {
  final List<Exercice> exercices;
  final Routine routine;
  final Function refresh;

  const ListExercicesOfRoutine({super.key, required this.exercices, required this.routine, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text("Liste des exercices déjà dans cette routine :"),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: exercices.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(exercices[index].nom),
                  IconButton(
                    onPressed: (){
                      TrainingDiaryDatabase.instance.deleteRoutineHasExercice(exercices[index].id!, routine.id!);
                      showDialog(context: context, builder: (BuildContext context){
                        return CupertinoAlertDialog(
                          title: const Text("Supprimé !"),
                          content: const Text("L'exercice a bien été enlevé de la routine."),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                                refresh();
                              },
                              child: const Text("Ok")
                              )
                          ],
                        );
                      });
                    }, 
                    icon: const Icon(Icons.close, color: Colors.red,)
                  ),
                ],
              )
              ,
              leading: const Icon(Icons.circle),
            );
          }
        )
      ],
    );
  }
}
