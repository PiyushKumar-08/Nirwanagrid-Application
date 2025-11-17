class Subscription {
  final DateTime expiryDate;
  final double walletBalance;

  Subscription({
    required this.expiryDate,
    required this.walletBalance,
  });

  /// Calculate remaining full months till expiry
  int get remainingMonths {
    final now = DateTime.now();
    if (expiryDate.isBefore(now)) return 0;

    int years = expiryDate.year - now.year;
    int months = expiryDate.month - now.month;

    int totalMonths = years * 12 + months;

    // If expiry day is smaller than today’s day → subtract 1 month
    if (expiryDate.day < now.day) {
      totalMonths -= 1;
    }
    return totalMonths < 0 ? 0 : totalMonths;
  }
}

class SubscriptionService {
  Future<Subscription> fetchSubscription() async {
    await Future.delayed(const Duration(seconds: 1));

    return Subscription(
      expiryDate: DateTime.now().add(const Duration(days: 120)), // mock 4 months
      walletBalance: 150.0, // mock balance
    );
  }

  /// Recharge plans (in months → price)
  final Map<int, double> rechargePlans = {
    1: 199,
    3: 299,
    6: 499,
  };

  Future<Subscription> recharge(Subscription current, int months) async {
    await Future.delayed(const Duration(seconds: 1));

    // Extend expiry date
    final newExpiry = current.expiryDate.isBefore(DateTime.now())
        ? DateTime.now().add(Duration(days: months * 30))
        : current.expiryDate.add(Duration(days: months * 30));

    return Subscription(
      expiryDate: newExpiry,
      walletBalance: current.walletBalance, // keep same wallet for mock
    );
  }
}
