import 'package:beecheal/models/occasion.dart';

class Task extends Occasion {
  DateTime completedOn;
  Task(super.id, super.title, super.date, super.description, this.completedOn);
}
