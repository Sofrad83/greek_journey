

class Exercice{
  int? id;
  String nom;
  String description;

  Exercice(this.id, this.nom, this.description);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'nom' : nom,
      'description' : description
    };
  }

  factory Exercice.fromMap(Map<String, dynamic> map) => new Exercice(map['id'], map['nom'], map['description']);
}