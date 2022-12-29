import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:chapter1/performance_calculator.dart';

StatementData createStatementData(Map<String, Play> plays, Invoice invoice) {
  Play playFor(Performance perf) {
    if (plays[perf.playID] == null) {
      throw Exception('unknown play type');
    }
    return plays[perf.playID]!;
  }

  PerformanceCalculator calculatorFor(Performance perf) {
    switch (playFor(perf).type) {
      case 'tragedy':
        return TragedyCalculator(perf.audience);
      case 'comedy':
        return ComedyCalculator(perf.audience);
      default:
        throw Exception('unknown play type');
    }
  }

  int totalAmount(List<Performance> performances) {
    return performances.fold(
        0, (total, perf) => total + calculatorFor(perf).amount());
  }

  int totalVolumeCredits(List<Performance> performances) {
    return performances.fold(
        0, (total, perf) => total + calculatorFor(perf).volumeCredits());
  }

  PerformanceEnriched enrichPerformance(Performance perf) {
    return PerformanceEnriched(
      play: playFor(perf),
      audience: perf.audience,
      amount: calculatorFor(perf).amount(),
      volumeCredits: calculatorFor(perf).volumeCredits(),
    );
  }

  return StatementData(
    totalVolumeCredits: totalVolumeCredits(invoice.performances),
    totalAmount: totalAmount(invoice.performances),
    performances:
        invoice.performances.map((e) => enrichPerformance(e)).toList(),
  );
}

class StatementData {
  final int totalVolumeCredits;
  final int totalAmount;
  final List<PerformanceEnriched> performances;

  StatementData({
    required this.totalVolumeCredits,
    required this.totalAmount,
    required this.performances,
  });
}

class PerformanceEnriched {
  final int audience;
  final Play play;
  final int amount;
  final int volumeCredits;

  PerformanceEnriched({
    required this.audience,
    required this.play,
    required this.amount,
    required this.volumeCredits,
  });
}
