

class Seance{
  int? id;
  int routineId;
  String date;

  Seance(this.id, this.routineId, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'routine_id' : routineId,
      'date' : date
    };
  }

  factory Seance.fromMap(Map<String, dynamic> map) => new Seance(map['id'], map['routine_id'], map['date']);
}