import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/models/recommendation.dart';
import 'package:skillchain/models/exchange_type.dart';
import 'package:skillchain/services/timecoin_service.dart';
import 'package:skillchain/Pages/timecoin/timecoin_screen.dart';

class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback? onBalanceUpdate;

  const RecommendationCard({
    super.key,
    required this.recommendation,
    this.onBalanceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Profile, Name, Rating, Match Badge
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(recommendation.profileImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          recommendation.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (recommendation.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          recommendation.rating.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recommendation.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (recommendation.isTopRated)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Top Rated',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '${recommendation.matchPercentage}% Match',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // OFFERS Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'OFFERS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recommendation.exchangeType ==
                        ExchangeType.timecoinExchange &&
                    recommendation.timecoinCost != null)
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/timecoin.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'timecoins: ${recommendation.timecoinCost}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recommendation.offers.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // NEEDS Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.purple.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'NEEDS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recommendation.needs.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Exchange Type Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      recommendation.exchangeType == ExchangeType.skillExchange
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      recommendation.exchangeType == ExchangeType.skillExchange
                          ? Icons.swap_horiz
                          : Icons.monetization_on,
                      size: 14,
                      color:
                          recommendation.exchangeType ==
                              ExchangeType.skillExchange
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      recommendation.exchangeType == ExchangeType.skillExchange
                          ? 'Skill Exchange'
                          : 'Timecoin Exchange',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            recommendation.exchangeType ==
                                ExchangeType.skillExchange
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleRequestPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        recommendation.exchangeType ==
                            ExchangeType.skillExchange
                        ? Colors.green
                        : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recommendation.exchangeType ==
                                ExchangeType.skillExchange
                            ? 'Request Skill Exchange'
                            : 'Request Session',
                      ),
                      if (recommendation.exchangeType ==
                              ExchangeType.timecoinExchange &&
                          recommendation.timecoinCost != null) ...[
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/images/timecoin.svg',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleRequestPressed(BuildContext context) {
    if (recommendation.exchangeType == ExchangeType.skillExchange) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Request Skill Exchange"),
          content: Text(
            "You'll exchange your skills with ${recommendation.name}.\n\n"
            "This is a skill-for-skill exchange - no timecoins required!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Skill exchange requested with ${recommendation.name}!",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      );
    } else {
      final timecoinService = TimecoinService.instance;
      final sessionCost = recommendation.timecoinCost ?? 5;

      if (timecoinService.getBalance() >= sessionCost) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Request Session"),
            content: Text(
              "This session will cost $sessionCost timecoins.\n\n"
              "Current balance: ${timecoinService.getBalance()} timecoins\n"
              "After payment: ${timecoinService.getBalance() - sessionCost} timecoins\n\n"
              "Do you want to proceed?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final success = timecoinService.spendTimecoins(
                    sessionCost,
                    "Session with ${recommendation.name}",
                    relatedUserId: recommendation.id,
                  );
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Session requested! $sessionCost timecoins deducted.",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                    onBalanceUpdate?.call();
                  }
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Insufficient Timecoins"),
            content: Text(
              "You need $sessionCost timecoins to request this session.\n\n"
              "Current balance: ${timecoinService.getBalance()} timecoins\n\n"
              "Would you like to purchase more timecoins?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TimecoinScreen(),
                    ),
                  ).then((_) => onBalanceUpdate?.call());
                },
                child: const Text("Buy Timecoins"),
              ),
            ],
          ),
        );
      }
    }
  }
}
