

class RoutineHasExercice{
  int? id;
  int exerciceId;
  int routineId;

  RoutineHasExercice(this.id, this.exerciceId, this.routineId);

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'exercice_id' : exerciceId,
      'routine_id' : routineId
    };
  }

  factory RoutineHasExercice.fromMap(Map<String, dynamic> map) => new RoutineHasExercice(map['id'], map['exercice_id'], map['routine_id']);
}