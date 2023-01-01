
class Routine{
  int? id;
  String nom;
  String description;

  Routine(this.id, this.nom, this.description);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'nom' : nom,
      'description' : description
    };
  }

  factory Routine.fromMap(Map<String, dynamic> map) => new Routine(map['id'], map['nom'], map['description']);
}