

class Serie{
  int? id;
  int exerciceId;
  int nbRep;
  String poids;
  int seanceId;

  Serie(this.id, this.exerciceId, this.nbRep, this.poids, this.seanceId);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'exercice_id' : exerciceId,
      'nb_rep' : nbRep,
      'poids' : poids,
      'seance_id' : seanceId
    };
  }

  factory Serie.fromMap(Map<String, dynamic> map) => new Serie(map['id'], map['exercice_id'], map['nb_rep'], map['poids'], map['seance_id']);
}