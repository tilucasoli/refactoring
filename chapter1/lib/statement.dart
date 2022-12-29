// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

import 'statement_data.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  return renderPlainText(createStatementData(invoice, plays));
}

String renderPlainText(StatementData data) {
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