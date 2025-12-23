import 'package:skillchain/models/exchange_type.dart';

class Offer {
  // Required fields
  final String id;
  final String userId;
  final String userName;
  final String userProfilePhoto;
  final String title;
  final String description;
  final DateTime expiryDate; // Primary field
  final String timeline;
  final ExchangeType exchangeType;

  // Optional fields
  final String? coverImage;
  final List<String> skillsOffering; // Primary field
  final int? rewardTimeCoins; // Primary field
  final List<String> skillsNeeded; // Primary field
  final String status;
  final int? matchPercentage;
  final String? offerDetails; // Legacy field for backward compatibility

  Offer({
    // Required
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfilePhoto,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.timeline,
    required this.exchangeType,
    // Optional
    this.coverImage,
    this.skillsOffering = const [],
    this.rewardTimeCoins,
    this.skillsNeeded = const [],
    this.status = 'active',
    this.matchPercentage,
    this.offerDetails,
  });

  // Backward compatibility getters
  DateTime get expirationDate => expiryDate;
  List<String> get offers => skillsOffering;
  List<String> get needs => skillsNeeded;
  int? get timecoinCost => rewardTimeCoins;
}
