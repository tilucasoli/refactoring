import 'package:chapter1/algorithm.dart';
import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';

void main(List<String> arguments) {
  final plays = {
    'hamlet': Play(name: 'Hamlet', type: 'tragedy'),
    'as-like': Play(name: 'As You Like It', type: 'comedy'),
    'othello': Play(name: 'Othello', type: 'tragedy'),
  };

  final invoices = [
    Invoice(
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
    ),
  ];

  for (var invoice in invoices) {
    print(statement(invoice, plays));
  }
}
