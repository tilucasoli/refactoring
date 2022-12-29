// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:chapter1/statement_data.dart';
import 'package:intl/intl.dart';

String statement(Invoice invoice, Map<String, Play> plays) {
  return renderPlainText(
    invoice: invoice,
    data: createStatementData(plays, invoice),
  );
}

String renderPlainText({
  required Invoice invoice,
  required StatementData data,
}) {
  String result = ' Statement for ${invoice.customer}\n';

  for (var perf in data.performances) {
    result +=
        ' ${perf.play.name}: ${formatToUSD(perf.amount)} (${perf.audience} seats)\n';
  }

  result += 'Amount owed is ${formatToUSD(data.totalAmount)}\n';
  result += 'You earned ${data.totalVolumeCredits} credits\n';
  return result;
}

String formatToUSD(dynamic value) {
  final format = NumberFormat.currency(locale: 'en-US', symbol: 'USD');
  return format.format(value / 100);
}
