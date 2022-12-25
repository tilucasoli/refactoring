import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  int totalAmount = 0;
  int volumeCredits = 0;
  String result = ' Statement for ${invoice.customer}\n';

  Play? playFor(Performance aPerformance) => plays[aPerformance.playID];

  int amountFor(Performance perf) {
    int result = 0;
    
    switch (playFor(perf)?.type) {
      case 'tragedy':
        result = 40000;
        if (perf.audience > 30) {
          result += 1000 * (perf.audience - 30);
        }
        break;
      case 'comedy':
        result = 30000;
        if (perf.audience > 20) {
          result += 10000 + 500 * (perf.audience - 20);
        }
        break;
      default:
        result += 300 * perf.audience;
        throw Exception('unknown type: ${playFor(perf)?.type}');
    }
    return result;
  }
  
  final format = NumberFormat.currency(locale: 'en-US', symbol: 'USD');

  for (var perf in invoice.performances) {

    volumeCredits += max(perf.audience - 30, 0);

    if ('comedy' == playFor(perf)?.type) volumeCredits += (perf.audience / 5).floor();

    result +=
        ' ${playFor(perf)?.name}: ${format.format(amountFor(perf) / 100)} (${perf.audience} seats)\n';
    totalAmount += amountFor(perf);
  }
  result += 'Amount owed is ${format.format(totalAmount / 100)}\n';
  result += 'You earned $volumeCredits credits\n';
  return result;
}
