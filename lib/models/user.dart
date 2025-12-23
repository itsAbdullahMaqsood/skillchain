class UserModel {
  // Required fields (*)
  final String id;
  final String fullName; // Primary field
  final String email;
  final String password;
  final int age;
  final String gender;
  final String location;
  final String phoneNumber; // Primary field
  final String portfolioLink;
  final bool verified; // Primary field

  // Optional fields
  final String? bio;
  final String? profilePic; // Primary field
  final String? education;
  final List<String> offeringSkills;
  final String? pastExperience;
  final String? resume;
  final int timeCoins;
  final String? subscriptionPackage;
  final double ratings;
  final List<Review> reviews;
  final String status;
  final List<String> earnedCertificates;
  final List<String> myOffers;

  // Legacy fields (for backward compatibility)
  final String? username; // Optional now
  final int? posts;
  final int? donations;
  final int? connections;
  final String? linkedin;
  final String? github;
  final String? twitter;

  UserModel({
    // Required fields
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.location,
    required this.phoneNumber,
    required this.portfolioLink,
    required this.verified,
    // Optional fields
    this.bio,
    this.profilePic,
    this.education,
    this.offeringSkills = const [],
    this.pastExperience,
    this.resume,
    this.timeCoins = 0,
    this.subscriptionPackage,
    this.ratings = 0.0,
    this.reviews = const [],
    this.status = 'active',
    this.earnedCertificates = const [],
    this.myOffers = const [],
    // Legacy fields
    this.username,
    this.posts,
    this.donations,
    this.connections,
    this.linkedin,
    this.github,
    this.twitter,
  }) : assert(
         username == null || username.isEmpty || username.length <= 15,
         'Username must be 15 characters or less',
       );

  // Backward compatibility getters
  String get name => fullName;
  String get profileImage => profilePic ?? '';
  bool get isVerified => verified;
  String get phone => phoneNumber;

  // Helper method to get truncated username for display
  String get displayUsername {
    if (username != null && username!.isNotEmpty) {
      return username!.length > 15 ? username!.substring(0, 15) : username!;
    }
    // Generate username from email if not provided
    final emailUsername = email.split('@')[0];
    return emailUsername.length > 15
        ? emailUsername.substring(0, 15)
        : emailUsername;
  }
}

class Review {
  final String id;
  final String reviewerId;
  final String reviewerName;
  final String reviewerProfilePic;
  final double rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.reviewerId,
    required this.reviewerName,
    required this.reviewerProfilePic,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });
}
