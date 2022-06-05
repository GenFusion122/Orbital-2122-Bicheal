class User {
  String _uid;
  bool _dailyJournalEntry;
  bool _weeklyReminder;

  User(this._uid, this._dailyJournalEntry, this._weeklyReminder);

  getUid() {
    return this._uid;
  }

  getDailyJournalEntry() {
    return this._dailyJournalEntry;
  }

  getWeeklyReminder() {
    return this._weeklyReminder;
  }
}
