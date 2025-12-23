class TimecoinTransaction {
  final String id;
  final String type; // 'earned', 'spent', 'purchased'
  final int amount;
  final String description;
  final DateTime timestamp;
  final String? relatedUserId; // User who gave/received the skill exchange

  TimecoinTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.relatedUserId,
  });
}
