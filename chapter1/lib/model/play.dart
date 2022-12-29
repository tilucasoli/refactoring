import 'dart:math';

class Play {
  final String name;
  final String type;

  const Play({
    required this.name,
    required this.type,
  });
}

abstract class Calculator {
  int amount(int audience);
  int volumeCredits(int audience);
}

class TragedyCalculator extends Calculator {
  @override
  int amount(int audience) {
    var result = 40000;
    if (audience > 30) {
      result += 1000 * (audience - 30);
    }
    return result;
  }

  @override
  int volumeCredits(int audience) {
    return max(audience - 30, 0);
  }
}

class ComedyCalculator extends Calculator {
  @override
  int amount(int audience) {
    var result = 30000;
    if (audience > 20) {
      result += 10000 + 500 * (audience - 20);
    }
    return result;
  }

  @override
  int volumeCredits(int audience) {
    int result = 0;
    result += max(audience - 30, 0);
    result += (audience / 5).floor();
    return result;
  }
}
