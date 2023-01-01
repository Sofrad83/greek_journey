
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/utils/database.dart';
import 'all_layout.dart';

class AddRoutineScreen extends StatefulWidget {
  const AddRoutineScreen({super.key});

  @override
  State<AddRoutineScreen> createState() => _AddRoutineScreenState();
}

class _AddRoutineScreenState extends State<AddRoutineScreen> {

  final formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle routine"),
        backgroundColor: Color.fromARGB(255, 220, 160, 58),
      ),
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: 8.0
              ),
              child: TextFormField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: "Nom",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  )
                ),
                validator: (value) {
                  if(value != null && value.isEmpty){
                    return 'Renseignez un nom';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: 8.0
              ),
              child: TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  )
                ),
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
                validator: (value) {
                  if(value != null && value.isEmpty){
                    return 'Renseignez une description';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8.0,),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 220, 160, 58)),
                onPressed: () async {
                  if(formKey.currentState!.validate()){
                    Routine routine = Routine(null, nomController.value.text, descriptionController.value.text);
                    int id = await TrainingDiaryDatabase.instance.insertRoutine(routine);
                    Routine newRoutine = await TrainingDiaryDatabase.instance.getRoutine(id);
                    showDialog(context: context, builder: (BuildContext context){
                      return CupertinoAlertDialog(
                        title: const Text("Ajouté !"),
                        content: const Text("La routine a bien été créée :)"),
                        actions: [
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) {return AddExerciceToRoutineScreen(routine : newRoutine);} ));
                            },
                            child: const Text("Ok")
                            )
                        ],
                      );
                    });
                  }
                },
                child: const Text("Enregistrer"),
              ),
            )
          ],
        )
        ),
    );
  }
}
