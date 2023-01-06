import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:training_diary/model/exercice.dart';
import 'package:training_diary/model/lastSeance.dart';
import 'package:training_diary/model/routine.dart';
import 'package:training_diary/model/seance.dart';
import 'package:training_diary/model/serie.dart';
import 'package:training_diary/utils/database.dart';
import 'package:training_diary/view/all_layout.dart';
import 'package:wakelock/wakelock.dart';

List<Serie> _mySeries = [];
var _commentaireExo = [];

class SeanceScreen extends StatefulWidget {
  final Routine routine;
  const SeanceScreen({super.key, required this.routine});

  @override
  State<SeanceScreen> createState() => _SeanceScreenState(routine: routine,);
}

class _SeanceScreenState extends State<SeanceScreen> {
  final Routine routine;
  Seance? seance;
  List<Exercice> _myExercices = [];
  int _indexExercice = 0;
  late Future<List<Exercice>> _future;
  String _lastSeance = "-";
  bool _lastSeancerequest = false;

  _SeanceScreenState({required this.routine});

  StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;

  @override
  void initState() {
    _future = TrainingDiaryDatabase.instance.getAllExercicesFromRoutine(routine);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  createSeance() async {
    if(seance == null){
      seance = Seance(null, routine.id!, "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}" );
      int id = await TrainingDiaryDatabase.instance.insertSeance(seance!);
      setState(()  {
        seance!.id = id;
      });
    }
  }

  getLastSeance() async{
    if(_lastSeancerequest == false){
      List<LastSeance> lastSeance = await TrainingDiaryDatabase.instance.getLastSeance(_myExercices[_indexExercice].id);
      if(lastSeance.isNotEmpty){
        setState(() {
          _lastSeance = lastSeance[0].commentaire;
          _lastSeancerequest = true;
        });
      }else{
        setState(() {
          _lastSeance = "-";
          _lastSeancerequest = true;
        });
      }
    }
  }

  mySeriesToJson(){
    var obj = {};
    int key = 1;
    _mySeries.forEach((element) {
      var map = {'key${key}' :{
        'serie' : _mySeries.indexOf(element) + 1,
        'nb_rep' : element.nbRep,
        'poids' : element.poids,
      }};
      obj.addAll(map);
      key++;
    });
    return json.encode(obj);
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      createSeance();
      getLastSeance();
    });
    return Scaffold(
      //appBar: AppBar(title: Text("Séance - ${routine.nom}"), backgroundColor: Color.fromARGB(255, 220, 160, 58),),
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
                      "${routine.nom}", 
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
                    future: _future,
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data!.isEmpty){
                          SchedulerBinding.instance.addPostFrameCallback((_) {setState(() {
                            
                          });});
                          return Center(child: Text("Pas d'exo"),);
                        }
                        _myExercices = snapshot.data!;
                        return Stack(children: [
                          ListView(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0), 
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        StreamBuilder(
                                          stream: _stopWatchTimer.rawTime,
                                          initialData: _stopWatchTimer.rawTime.value,
                                          builder: (context, snapshot) {
                                            final int? value = snapshot.data as int?;
                                            final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                                            return Text(displayTime, style: const TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 220, 160, 58)),);
                                          }),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(onPressed: (){
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                              }, icon: const Icon(Icons.play_arrow, color: Color.fromARGB(255, 220, 160, 58), size: 35.0,)),
                                              
                                              IconButton(onPressed: (){
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                              }, icon: const Icon(Icons.pause, color: Color.fromARGB(255, 220, 160, 58), size: 35.0,)),

                                              IconButton(onPressed: (){
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                              }, icon: const Icon(Icons.square, color: Color.fromARGB(255, 220, 160, 58), size: 30.0,))
                                            ],
                                          )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              CurrentExerciceItemWidget(exercice: _myExercices[_indexExercice]),
                              const SizedBox(height: 8.0,),
                              SerieTableWidget(seance: seance!, exercice: _myExercices[_indexExercice], refreshParent: (uneSerie){
                                setState(() {
                                  _mySeries.add(uneSerie);
                                });
                              },),
                              const SizedBox(height: 8.0,),
                              ButtonProchainExo(
                                lastExo: _myExercices[_indexExercice] == _myExercices.last, 
                                prochainExo: () {
                                  TrainingDiaryDatabase.instance.insertLastSeance(_myExercices[_indexExercice].id, mySeriesToJson());
                                  setState(() {
                                    _indexExercice++;
                                    _mySeries = [];
                                    _commentaireExo = [];
                                    _lastSeancerequest = false;
                                  });
                                }, 
                                finirSeance: () {
                                  TrainingDiaryDatabase.instance.insertLastSeance(_myExercices[_indexExercice].id, mySeriesToJson());
                                  setState(() {
                                    _mySeries = [];
                                    _commentaireExo = [];
                                    _lastSeancerequest = false;
                                    _indexExercice = 0;
                                  });
                                  Navigator.pushReplacementNamed(context, '/accueil');
                                }),
                              const SizedBox(height: 20,),
                              const Center(child: Text("Récap dernière séance pour cette exercice :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Romanica", color: Color.fromARGB(255, 220, 160, 58)),),),
                              const SizedBox(height: 25,),
                              LastSerieTableWidget(myJson: _lastSeance)
                              
                            ],
                          )
                        ]);
                      }else{
                        return const Center(child: Text("Il n'y a pas d'exerice :("),);
                      }
                    }),
                )
              ],
            )
          ],
        ),
    );
  }
  
}

class CurrentExerciceItemWidget extends StatelessWidget {
  final Exercice exercice;
  const CurrentExerciceItemWidget({Key? key, required this.exercice}) : super(key: key);
  
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
              width: 70,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(exercice.nom, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Romanica", color: Color.fromARGB(255, 220, 160, 58)),),
                    ),
                    Text(
                      exercice.description, 
                      style: TextStyle(color: Color.fromARGB(255, 144, 105, 36), fontSize: 14,fontFamily: "Romanica"),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      );
  }
}

class ButtonProchainExo extends StatelessWidget {
  final bool lastExo;
  final Function prochainExo;
  final Function finirSeance;
  const ButtonProchainExo({Key? key,required this.lastExo, required this.prochainExo, required this.finirSeance}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      if(lastExo){
        return ElevatedButton(
          onPressed: () => finirSeance(),
          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 220, 160, 58)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Terminer la séance. ", style: TextStyle(fontFamily: "Romanica")),
              Icon(Icons.check)
            ]
          ,)
        );
      }else{
        return ElevatedButton(
          onPressed: () => prochainExo(), 
          style: ElevatedButton.styleFrom(primary: Color.fromARGB(255, 220, 160, 58)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Passer au prochain exo ", style: TextStyle(fontFamily: "Romanica"),),
              Icon(Icons.arrow_circle_right)
            ]
          ,)
        );
      }
  }
}

class SerieTableWidget extends StatelessWidget {
  final Seance seance;
  final Exercice exercice;
  final Function refreshParent;
  const SerieTableWidget({Key? key,required this.seance, required this.exercice, required this.refreshParent}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      List<TableRow> _children = [
        const TableRow(
            children: [
              Center(child: Text("Série", style: TextStyle(fontFamily: "Romanica"),),),
              Center(child: Text("Nb reps", style: TextStyle(fontFamily: "Romanica")),),
              Center(child: Text("Poids", style: TextStyle(fontFamily: "Romanica")),),
              Center(child: Icon(Icons.check),)
            ],
          ),
      ];
      for(int i = 0; i < _mySeries.length; i++){
        _children.add(
          TableRow(
            children: [
              Center(child: Text((i+1).toString()),),
              Center(child: SizedBox(child: Text(_mySeries[i].nbRep.toString()),) ),
              Center(child: SizedBox(child: Text(_mySeries[i].poids,) )),
              const Center(child: Icon(Icons.check_circle, color: Colors.green,)),
            ]
          )
        );
      }
      TextEditingController repController = TextEditingController(text: _mySeries.isNotEmpty ? _mySeries.last.nbRep.toString() : "");
      TextEditingController poidsController = TextEditingController(text: _mySeries.isNotEmpty ? _mySeries.last.poids : "");
      _children.add(
          TableRow(
            children: [
              Center(child: Text((_mySeries.length+1).toString()),),
              Center(child: SizedBox(child: TextFormField(keyboardType: TextInputType.number, textAlign: TextAlign.center, controller: repController,),) ),
              Center(child: SizedBox(child: TextFormField(keyboardType: TextInputType.number, textAlign: TextAlign.center, controller: poidsController,),) ),
              Center(child: IconButton( icon: const Icon(Icons.check_circle), onPressed: () async {
                try{
                  Serie maSerie = Serie(null, exercice.id!, int.parse(repController.value.text), poidsController.value.text, seance.id!);
                  refreshParent(maSerie);
                }catch (e){
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(e.toString())));
                }
              },)),
            ]
          )
        );
      return Table(
        border: TableBorder.all(color: Colors.white, width: 0.4, borderRadius: BorderRadius.circular(5)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _children,
      );
  }
}


class LastSerieTableWidget extends StatelessWidget {
  final String myJson;
  const LastSerieTableWidget({Key? key, required this.myJson}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
      List<TableRow> _children = [
        const TableRow(
            children: [
              Center(child: Text("Série",  style: TextStyle(fontFamily: "Romanica")),),
              Center(child: Text("Nb reps", style: TextStyle(fontFamily: "Romanica")),),
              Center(child: Text("Poids", style: TextStyle(fontFamily: "Romanica")),),
            ],
          ),
      ];
      try{
        var series = json.decode(myJson);
        series.forEach((k,v) {
          _children.add(
            TableRow(
              
              children: [
                Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child:Center(child: SizedBox(child: Text(v["serie"].toString()),)),),
                Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child:Center(child: SizedBox(child: Text(v["nb_rep"].toString()),)),),
                Padding(padding: EdgeInsets.only(top: 8, bottom: 8), child:Center(child: SizedBox(child: Text(v["poids"].toString()),)),),
              ]
            )
          );
        });
      }catch(e){
        print(e);
        return Center(child: Text("Pas de récap :(",  style: TextStyle(fontFamily: "Romanica")),);
      }
      return Table(
        border: TableBorder.all(color: Colors.white, width: 0.4, borderRadius: BorderRadius.circular(5)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: _children,
      );
  }
}



