// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  Play? playFor(Performance aPerformance) => plays[aPerformance.playID];

  PerformanceEnrich enrichPerformance(Performance aPerformance) =>
      PerformanceEnrich(
        play: playFor(aPerformance),
        audience: aPerformance.audience,
        playID: aPerformance.playID,
      );

  final data = StatementData(
    customer: invoice.customer,
    performances:
        invoice.performances.map((e) => enrichPerformance(e)).toList(),
  );

  return renderPlainText(data, plays);
}

String renderPlainText(StatementData data, Map<String, Play> plays) {
  int amountFor(PerformanceEnrich aPerfomance) {
    int result = 0;

    switch (aPerfomance.play?.type) {
      case 'tragedy':
        result = 40000;
        if (aPerfomance.audience > 30) {
          result += 1000 * (aPerfomance.audience - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (aPerfomance.audience > 20) {
          result += 10000 + 500 * (aPerfomance.audience - 20);
        }
        break;
      default:
        result += 300 * aPerfomance.audience;
        throw Exception('unknown type: ${aPerfomance.play?.type}');
    }
    return result;
  }

  int volumeCreditsFor(PerformanceEnrich perf) {
    int result = 0;
    result += max(perf.audience - 30, 0);
    if ('comedy' == perf.play?.type) result += (perf.audience / 5).floor();
    return result;
  }

  int totalVolumeCredits() {
    int result = 0;
    for (var perf in data.performances) {
      result += volumeCreditsFor(perf);
    }
    return result;
  }

  int totalAmount() {
    int result = 0;
    for (var perf in data.performances) {
      result += amountFor(perf);
    }
    return result;
  }

  String result = ' Statement for ${data.customer}\n';

  for (var perf in data.performances) {
    result +=
        ' ${perf.play?.name}: ${formatToUSD(amountFor(perf))} (${perf.audience} seats)\n';
  }

  result += 'Amount owed is ${formatToUSD(totalAmount())}\n';
  result += 'You earned ${totalVolumeCredits()} credits\n';
  return result;
}

String formatToUSD(dynamic number) {
  var formatter = NumberFormat.currency(locale: 'en-US', symbol: 'USD');
  return formatter.format(number / 100);
}

class StatementData {
  final String customer;
  final List<PerformanceEnrich> performances;

  StatementData({
    required this.customer,
    required this.performances,
  });
}

class PerformanceEnrich {
  final String playID;
  final int audience;
  final Play? play;

  PerformanceEnrich({
    required this.playID,
    required this.audience,
    required this.play,
  });
}
