import 'model/invoice.dart';
import 'model/play.dart';
import 'dart:math';

StatementData createStatementData(Invoice invoice, Map<String, Play> plays) {
  return StatementData(
    customer: invoice.customer,
    performances:
        invoice.performances.map((e) => enrichPerformance(e, plays)).toList(),
  );
}

PerformanceEnriched enrichPerformance(
    Performance aPerformance, Map<String, Play> plays) {
  Play? playFor(Performance aPerformance) => plays[aPerformance.playID];

  int amountFor(Performance aPerformance) {
    return calculatorFor(playFor(aPerformance)).amount(aPerformance.audience);
  }

  int volumeCreditsFor(Performance aPerformance) {
    return calculatorFor(playFor(aPerformance))
        .volumeCredits(aPerformance.audience);
  }

  return PerformanceEnriched(
    play: playFor(aPerformance),
    audience: aPerformance.audience,
    playID: aPerformance.playID,
    amount: amountFor(aPerformance),
    volumeCredits: volumeCreditsFor(aPerformance),
  );
}

Calculator calculatorFor(Play? play) {
  switch (play?.type) {
    case 'tragedy':
      return TragedyCalculator();
    case 'comedy':
      return ComedyCalculator();
    default:
      throw Exception('unknown type: ${play?.type}');
  }
}

class StatementData {
  final String customer;
  final List<PerformanceEnriched> performances;

  StatementData({
    required this.customer,
    required this.performances,
  });

  int get totalVolumeCredits => performances
      .map((e) => e.volumeCredits)
      .reduce((value, element) => value + element);

  int get totalAmount => performances
      .map((e) => e.amount)
      .reduce((value, element) => value + element);
}

class PerformanceEnriched {
  final String playID;
  final int audience;
  final Play? play;
  final int amount;
  final int volumeCredits;

  PerformanceEnriched({
    required this.playID,
    required this.audience,
    required this.play,
    required this.amount,
    required this.volumeCredits,
  });
}
