import 'package:chapter1/algorithm.dart';
import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:test/test.dart';

void main() {
  final plays = {
    'hamlet': Play(name: 'Hamlet', type: 'tragedy'),
    'as-like': Play(name: 'As You Like It', type: 'comedy'),
    'othello': Play(name: 'Othello', type: 'tragedy'),
  };

  testDefaultCase(plays);

  testExceptionCase(plays);
}

void testDefaultCase(Map<String, Play> plays) {
  final invoice = Invoice(
    customer: 'BigCo',
    performances: [
      Performance(
        playID: 'hamlet',
        audience: 55,
      ),
      Performance(
        playID: 'as-like',
        audience: 35,
      ),
      Performance(
        playID: 'othello',
        audience: 40,
      ),
    ],
  );
  
  const expectedResult = '''
 Statement for BigCo
 Hamlet: USD650.00 (55 seats)
 As You Like It: USD475.00 (35 seats)
 Othello: USD500.00 (40 seats)
Amount owed is USD1,625.00
You earned 47 credits
''';
  
  test('Statement', () {
    expect(
      statement(invoice, plays),
      expectedResult,
    );
  });
}

void testExceptionCase(Map<String, Play> plays) {
  final invoiceWithWrongPlayID = Invoice(
    customer: 'BigCo',
    performances: [
      Performance(
        playID: 'halet',
        audience: 55,
      ),
    ],
  );
  
  test('Statement with unknown play type', () {
    expect( () =>
      statement(invoiceWithWrongPlayID, plays),
      throwsA(isA<Exception>()),
    );
  });
}
