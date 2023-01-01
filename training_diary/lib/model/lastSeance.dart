

class LastSeance{
  int exerciceId;
  String commentaire;

  LastSeance(this.exerciceId, this.commentaire);

  Map<String, dynamic> toMap() {
    return {
      'exercice_id' : exerciceId,
      'commentaire' : commentaire
    };
  }

  factory LastSeance.fromMap(Map<String, dynamic> map) => new LastSeance(map['exercice_id'], map['commentaire']);
}