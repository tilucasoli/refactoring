import 'dart:math';

import 'package:chapter1/model/invoice.dart';
import 'package:chapter1/model/play.dart';
import 'package:intl/intl.dart';

// Qual as responsabilidades da função?
// [x] - Calcula valor por performance
// [x] - Calcula valor de creditos por performance
// [ ] - Calcular o valor total da conta total
// [ ] - Calcular o valor total de créditos
// [ ] - Formatar exibição do resultado

// Qual deveria ser o objetivo central da função?
// [ ] - Retornar exibição do resultado no formato String

String statement(Invoice invoice, Map<String, Play> plays) {
  Play? playFor(Performance perf) {
    return plays[perf.playID];
  }

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

  int volumeCreditsFor(Performance perf) {
    int result = max(perf.audience - 30, 0);

    if ('comedy' == playFor(perf)?.type) {
      result += (perf.audience / 5).floor();
    }

    return result;
  }

  int totalAmount(List<Performance> performances) {
    return performances.fold(0, (total, perf) => total + amountFor(perf));
  }

  int totalVolumeCredits(List<Performance> performances) {
    return performances
        .fold(0, (total, perf) => total + volumeCreditsFor(perf));
  }

  String result = ' Statement for ${invoice.customer}\n';

  for (var perf in invoice.performances) {
    result +=
        ' ${playFor(perf)?.name}: ${formatToUSD(amountFor(perf))} (${perf.audience} seats)\n';
  }

  result += 'Amount owed is ${formatToUSD(totalAmount(invoice.performances))}\n';
  result += 'You earned ${totalVolumeCredits(invoice.performances)} credits\n';
  return result;
}

String formatToUSD(dynamic value) {
  final format = NumberFormat.currency(locale: 'en-US', symbol: 'USD');
  return format.format(value / 100);
}
