import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/models/occasion.dart';

void main() {
  test('Occasion Object should be Created', () {
    Occasion occasion =
        Occasion("test", "testtitle", DateTime(1, 1, 1), "testDescription1");
    expect(occasion.getId(), "test");
    expect(occasion.getTitle(), "testtitle");
    expect(occasion.getDate(), DateTime(1, 1, 1));
    expect(occasion.getDescription(), "testDescription");
  });
}
