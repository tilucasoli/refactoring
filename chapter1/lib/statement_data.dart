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

PerformanceEnriched enrichPerformance(Performance aPerformance, Map<String, Play> plays) {
  Play? playFor(Performance aPerformance) => plays[aPerformance.playID];

  int amountFor(Performance aPerformance) {
    int result = 0;

    switch (playFor(aPerformance)?.type) {
      case 'tragedy':
        result = 40000;
        if (aPerformance.audience > 30) {
          result += 1000 * (aPerformance.audience - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (aPerformance.audience > 20) {
          result += 10000 + 500 * (aPerformance.audience - 20);
        }
        break;
      default:
        result += 300 * aPerformance.audience;
        throw Exception('unknown type: ${playFor(aPerformance)?.type}');
    }
    return result;
  }

  int volumeCreditsFor(Performance perf) {
    int result = 0;
    result += max(perf.audience - 30, 0);
    if ('comedy' == playFor(perf)?.type) result += (perf.audience / 5).floor();
    return result;
  }

  return PerformanceEnriched(
    play: playFor(aPerformance),
    audience: aPerformance.audience,
    playID: aPerformance.playID,
    amount: amountFor(aPerformance),
    volumeCredits: volumeCreditsFor(aPerformance),
  );
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
