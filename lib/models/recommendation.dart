import 'package:skillchain/models/exchange_type.dart';

class Recommendation {
  final String id;
  final String name;
  final String profileImage;
  final bool isVerified;
  final double rating;
  final String status; // "Online Now", "Replies in 1h", "Replies in 5m"
  final int matchPercentage;
  final bool isTopRated;
  final List<String> offers; // Skills they offer
  final List<String> needs; // Skills they need
  final ExchangeType exchangeType;
  final int? timecoinCost; // Only for timecoinExchange

  Recommendation({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.isVerified,
    required this.rating,
    required this.status,
    required this.matchPercentage,
    this.isTopRated = false,
    required this.offers,
    required this.needs,
    required this.exchangeType,
    this.timecoinCost,
  });
}

