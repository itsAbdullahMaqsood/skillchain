import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/models/timecoin.dart';
import 'package:skillchain/services/timecoin_service.dart';

class TimecoinScreen extends StatelessWidget {
  const TimecoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timecoinService = TimecoinService.instance;
    final balance = timecoinService.getBalance();
    final transactions = timecoinService.getTransactions();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Timecoins"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Your Balance",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/timecoin.svg',
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      balance.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showPurchaseDialog(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Buy Timecoins"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Transactions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Transaction History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (transactions.isEmpty)
                  TextButton(onPressed: () {}, child: const Text("Clear")),
              ],
            ),
          ),

          // Transactions List
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No transactions yet",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction =
                          transactions[transactions.length -
                              1 -
                              index]; // Reverse order
                      return _TransactionCard(transaction: transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Timecoins"),
        content: const Text(
          "Timecoins are the currency of Skill Chain:\n\n"
          "• Start with 10 timecoins\n"
          "• Earn timecoins by teaching skills to others\n"
          "• Spend timecoins to learn skills from others\n"
          "• Purchase more timecoins through in-app purchases\n\n"
          "Trade your time and expertise for timecoins!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PurchaseBottomSheet(),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TimecoinTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String prefix;

    switch (transaction.type) {
      case 'earned':
        icon = Icons.arrow_downward;
        color = Colors.green;
        prefix = '+';
        break;
      case 'spent':
        icon = Icons.arrow_upward;
        color = Colors.red;
        prefix = '-';
        break;
      case 'purchased':
        icon = Icons.shopping_cart;
        color = Colors.blue;
        prefix = '+';
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
        prefix = '';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          _formatDate(transaction.timestamp),
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Text(
          '$prefix${transaction.amount}',
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class _PurchaseBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> packages = [
    {'coins': 50, 'price': '\$4.99', 'popular': false},
    {'coins': 100, 'price': '\$8.99', 'popular': true},
    {'coins': 250, 'price': '\$19.99', 'popular': false},
    {'coins': 500, 'price': '\$34.99', 'popular': false},
  ];

  _PurchaseBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Buy Timecoins",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose a package to purchase",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ...packages.map(
            (package) => _PackageCard(
              coins: package['coins'] as int,
              price: package['price'] as String,
              isPopular: package['popular'] as bool,
              onTap: () {
                // Handle purchase
                final timecoinService = TimecoinService.instance;
                timecoinService.purchaseTimecoins(
                  package['coins'] as int,
                  'purchase_${DateTime.now().millisecondsSinceEpoch}',
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully purchased ${package['coins']} timecoins!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final int coins;
  final String price;
  final bool isPopular;
  final VoidCallback onTap;

  const _PackageCard({
    required this.coins,
    required this.price,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isPopular ? Colors.blue : Colors.grey.shade300,
          width: isPopular ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.monetization_on, color: Colors.blue),
        ),
        title: Row(
          children: [
            Text(
              '$coins Timecoins',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (isPopular) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'POPULAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: Text(
          price,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
