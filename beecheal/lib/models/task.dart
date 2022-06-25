import 'package:beecheal/models/occasion.dart';

class Task extends Occasion {
  DateTime _completedOn;
  Task(super._id, super._title, super._date, super._description,
      this._completedOn);

  static final DateTime incompletePlaceholder = DateTime(2999, 1, 1, 0, 0);

  DateTime getCompletedOn() {
    return this._completedOn;
  }

  void setCompletedOn(DateTime completedOn) {
    this._completedOn = completedOn;
  }
}
