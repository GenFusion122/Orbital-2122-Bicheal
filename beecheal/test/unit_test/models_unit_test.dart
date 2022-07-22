import 'package:beecheal/models/entry.dart';
import 'package:beecheal/models/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../../lib/models/occasion.dart';

void main() {
  //Testing Object Creation/Retrival of Information
  test('Occasion Object should be Created', () {
    Occasion occasion =
        Occasion("test", "testtitle", DateTime(1, 1, 1), "testDescription");
    expect(occasion.getId(), "test");
    expect(occasion.getTitle(), "testtitle");
    expect(occasion.getDate(), DateTime(1, 1, 1));
    expect(occasion.getDescription(), "testDescription");
  });
  test('Task Object should be Created', () {
    Task task = Task("test", "testtitle", DateTime(1, 1, 1), "testDescription",
        Task.incompletePlaceholder);
    expect(task.getId(), "test");
    expect(task.getTitle(), "testtitle");
    expect(task.getDate(), DateTime(1, 1, 1));
    expect(task.getDescription(), "testDescription");
    expect(task.getCompletedOn(), Task.incompletePlaceholder);
  });
  test('Entry Object should be Created', () {
    Entry entry = Entry("test", "testtitle", DateTime(1, 1, 1),
        "testDescription", "testBody", 2);
    expect(entry.getId(), "test");
    expect(entry.getTitle(), "testtitle");
    expect(entry.getDate(), DateTime(1, 1, 1));
    expect(entry.getDescription(), "testDescription");
    expect(entry.getBody(), "testBody");
    expect(entry.getSentiment(), 2);
  });
}
