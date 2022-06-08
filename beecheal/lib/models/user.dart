class User {
  String _uid;
  bool _dailyJournalEntry;
  bool _weeklyReminder;

  User(this._uid, this._dailyJournalEntry, this._weeklyReminder);

  String getUid() {
    return this._uid;
  }

  bool getDailyJournalEntry() {
    return this._dailyJournalEntry;
  }

  bool getWeeklyReminder() {
    return this._weeklyReminder;
  }
}
