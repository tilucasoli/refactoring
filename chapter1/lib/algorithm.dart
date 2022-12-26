import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  int totalAmount = 0;
  int volumeCredits = 0;
  String result = ' Statement for ${invoice.customer}\n';

  Play? playFor(Performance aPerformance) => plays[aPerformance.playID];

  int amountFor(Performance aPerfomance) {
    int result = 0;

    switch (playFor(aPerfomance)?.type) {
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
        throw Exception('unknown type: ${playFor(aPerfomance)?.type}');
    }
    return result;
  }

  int volumeCreditsFor(Performance perf) {
    int result = 0;
    result += max(perf.audience - 30, 0);
    if ('comedy' == playFor(perf)?.type) result += (perf.audience / 5).floor();
    return result;
  }

  for (var perf in invoice.performances) {
    volumeCredits += volumeCreditsFor(perf);
  }

  for (var perf in invoice.performances) {
    totalAmount += amountFor(perf);
  }
  
  for (var perf in invoice.performances) {
    result +=
        ' ${playFor(perf)?.name}: ${formatToUSD(amountFor(perf))} (${perf.audience} seats)\n';
  }
  
  result += 'Amount owed is ${formatToUSD(totalAmount)}\n';
  result += 'You earned $volumeCredits credits\n';
  return result;
}

String formatToUSD(dynamic number) {
  var formatter = NumberFormat.currency(locale: 'en-US', symbol: 'USD');
  return formatter.format(number/ 100);
}
