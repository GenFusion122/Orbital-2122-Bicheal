class Occasion {
  String _id;
  String _title;
  DateTime _date;
  String _description;
  Occasion(this._id, this._title, this._date, this._description);

  getId() {
    return this._id;
  }

  setId(String id) {
    this._id = id;
  }

  getTitle() {
    return this._title;
  }

  setTitle(String title) {
    this._title = title;
  }

  getDate() {
    return this._date;
  }

  setDate(DateTime date) {
    this._date = date;
  }

  getDescription() {
    return this._description;
  }

  setDescription(String description) {
    this._description = description;
  }
}
