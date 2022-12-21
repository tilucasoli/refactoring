import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String,Play> plays) {
  int totalAmount = 0;
  int volumeCredits = 0;
  String result = ' Statement for ${invoice.customer}\n';

  final format = NumberFormat.currency(locale: 'en-US', symbol: 'USD');

  for (var perf in invoice.performances) {
    var play = plays[perf.playID];
    int thisAmount = 0;
    switch (play?.type) {
      case 'tragedy':
        thisAmount = 40000;
        if (perf.audience > 30) {
          thisAmount += 1000 * (perf.audience - 30);
        }
        break;
      case 'comedy':
        thisAmount = 30000;
        if (perf.audience > 20) {
          thisAmount += 10000 + 500 * (perf.audience - 20);
        }
        break;
      default:
        thisAmount += 300 * perf.audience;
        throw Exception('unknown type: ${play?.type}');
    }
    // add volume credits
    volumeCredits += max(perf.audience - 30, 0);
    // add extra credit for every ten comedy attendees
    if ('comedy' == play?.type) volumeCredits += (perf.audience / 5).floor();
    // print line for this order
    result += ' ${play?.name}: ${format.format(thisAmount / 100)} (${perf.audience} seats)\n';
    totalAmount += thisAmount;
  }
  result += 'Amount owed is ${format.format(totalAmount / 100)}\n';
  result += 'You earned $volumeCredits credits\n';
  return result;
}
