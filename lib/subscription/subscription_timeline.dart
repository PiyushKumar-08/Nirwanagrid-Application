import 'package:flutter/material.dart';

class SubscriptionTimeline extends StatelessWidget {
  final int remainingMonths; // how many months left
  final int totalMonths; // usually 6

  const SubscriptionTimeline({
    super.key,
    required this.remainingMonths,
    this.totalMonths = 6,
  });

  @override
  Widget build(BuildContext context) {
    int usedMonths = totalMonths - remainingMonths;

    return Row(
      children: List.generate(totalMonths, (index) {
        final isUsed = index < usedMonths;

        final gradient = LinearGradient(
          colors: isUsed
              ? [Colors.greenAccent.shade200, Colors.green.shade600]
              : [Colors.blueAccent.shade200, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 22,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: isUsed
                      ? Colors.green.withOpacity(0.4)
                      : Colors.blue.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
