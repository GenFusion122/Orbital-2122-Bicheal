import 'package:beecheal/models/occasion.dart';

class Task extends Occasion {
  DateTime _completedOn;
  Task(super._id, super._title, super._date, super._description,
      this._completedOn);

  getCompletedOn() {
    return this._completedOn;
  }

  setCompletedOn(DateTime completedOn) {
    this._completedOn = completedOn;
  }
}
