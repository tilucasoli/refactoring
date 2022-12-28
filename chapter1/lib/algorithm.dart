// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  // Nested Functions
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

  PerformanceEnriched enrichPerformance(Performance aPerformance) =>
      PerformanceEnriched(
        play: playFor(aPerformance),
        audience: aPerformance.audience,
        playID: aPerformance.playID,
        amount: amountFor(aPerformance),
        volumeCredits: volumeCreditsFor(aPerformance),
      );

  // Core logic
  final data = StatementData(
    customer: invoice.customer,
    performances:
        invoice.performances.map((e) => enrichPerformance(e)).toList(),
  );

  return renderPlainText(data, plays);
}

String renderPlainText(StatementData data, Map<String, Play> plays) {
  String formatToUSD(dynamic number) {
    var formatter = NumberFormat.currency(locale: 'en-US', symbol: 'USD');
    return formatter.format(number / 100);
  }

  String result = ' Statement for ${data.customer}\n';

  for (var perf in data.performances) {
    result +=
        ' ${perf.play?.name}: ${formatToUSD(perf.amount)} (${perf.audience} seats)\n';
  }

  result += 'Amount owed is ${formatToUSD(data.totalAmount)}\n';
  result += 'You earned ${data.totalVolumeCredits} credits\n';
  return result;
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
