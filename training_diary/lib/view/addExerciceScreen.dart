import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_diary/model/exercice.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';

class AddExerciceScreen extends StatefulWidget {
  const AddExerciceScreen({super.key});

  @override
  State<AddExerciceScreen> createState() => _AddExerciceScreenState();
}

class _AddExerciceScreenState extends State<AddExerciceScreen> {

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
      //appBar: AppBar(title: const Text("Nouvel exercice"),backgroundColor: Color.fromARGB(255, 220, 160, 58),),
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
                      return IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 227, 174, 64), size: 40,));
                    }),
                  ),
                  Text(
                    "Nouvel exercice", 
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
                child: Form(
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
                          style: TextStyle(color: Color.fromARGB(255, 227, 174, 64), fontFamily: "Romanica"),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color.fromARGB(255, 227, 174, 64), fontFamily: "Romanica"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 227, 174, 64),
                              ),
                            ),
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
                          style: TextStyle(color: Color.fromARGB(255, 227, 174, 64), fontFamily: "Romanica"),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Color.fromARGB(255, 227, 174, 64), fontFamily: "Romanica"),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 227, 174, 64),
                              ),
                            ),
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
                              Exercice exercice = Exercice(null, nomController.value.text, descriptionController.value.text);
                              TrainingDiaryDatabase.instance.insertExercice(exercice);
                              showDialog(context: context, builder: (BuildContext context){
                                return CupertinoAlertDialog(
                                  title: const Text("Ajouté !"),
                                  content: const Text("L'exercice a bien été enregistré :)"),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context).pop(true); // On en met deux à cause du champ description
                                        Navigator.of(context).pop(true);
                                        Navigator.of(context).pop(true);
                                        Navigator.pushNamed(context, '/exercice');
                                      },
                                      child: const Text("Ok")
                                      )
                                  ],
                                );
                              });
                            }
                          },
                          child: const Text("Enregistrer", style: TextStyle(fontFamily: "Romanica"),),
                        ),
                      )
                    ],
                  )
                  ),
              )
            ],
          )
        ],
      )
    );
  }
}