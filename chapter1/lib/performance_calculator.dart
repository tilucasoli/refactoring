import 'dart:math';

abstract class PerformanceCalculator {
  final int audience;

  PerformanceCalculator(this.audience);
  
  int amount();
  int volumeCredits();
}

class TragedyCalculator extends PerformanceCalculator {
  TragedyCalculator(super.audience);

  @override
  int amount() {
    int result = 40000;
    if (audience > 30) {
      result += 1000 * (audience - 30);
    }
    return result;
  }

  @override
  int volumeCredits() {
    return max(audience - 30, 0);
  }
}

class ComedyCalculator extends PerformanceCalculator {
  ComedyCalculator(super.audience);

  @override
  int amount() {
    int result = 30000;
    if (audience > 20) {
      result += 10000 + 500 * (audience - 20);
    }
    return result;
  }

  @override
  int volumeCredits() {
    return max(audience - 30, 0) + (audience / 5).floor();
  }
}