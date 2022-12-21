class Invoice {
  final String customer;
  final List<Performance> performances;

  const Invoice({
    required this.customer,
    required this.performances,
  });
}

class Performance {
  final String playID;
  final int audience;

  const Performance({
    required this.playID,
    required this.audience,
  });
}
