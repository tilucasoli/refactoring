import 'package:chapter1/algorithm.dart';
import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:test/test.dart';

void main() {
  final plays = {
    'hamlet': Play(name: 'Hamlet', type: 'tragedy'),
  };

  final invoice = Invoice(
    customer: 'BigCo',
    performances: [
      Performance(
        playID: 'hamlet',
        audience: 55,
      ),
    ],
  );

  const expectedResult = '''
 Statement for BigCo
 Hamlet: USD650.00 (55 seats)
Amount owed is USD650.00
You earned 25 credits
''';

  test('Statement', () {
    expect(
      statement(invoice, plays),
      expectedResult,
    );
  });
}
