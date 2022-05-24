import 'package:beecheal/models/occasion.dart';

class Task extends Occasion {
  DateTime completedOn;
  Task(super.title, super.date, super.description, this.completedOn);
}
