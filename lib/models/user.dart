import 'package:skillchain/services/api_service.dart';

String? _str(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

/// Extracts display name from skill - supports {id, name} objects or plain strings.
String _skillToDisplayName(dynamic e) {
  if (e == null) return '';
  if (e is Map) {
    final name = e['name'] ?? e['Name'];
    if (name != null && name.toString().trim().isNotEmpty) {
      return name.toString().trim();
    }
  }
  if (e is String) return e.trim();
  return '';
}

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
  final String? profilePic; // Path from backend, e.g. /public/uploads/...
  final String? education;
  final List<String> offeringSkills;
  final List<String> learningSkills;
  final String? pastExperience;
  final String? resume; // Path from backend
  final String? portfolio; // Path from backend
  final int timeCoins;
  final String? subscriptionPackage;
  final double ratings;
  final int reviewsCount;
  final List<Review> reviews;
  final String status;
  final bool isPremium;
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
    this.bio,
    this.profilePic,
    this.education,
    this.offeringSkills = const [],
    this.learningSkills = const [],
    this.pastExperience,
    this.resume,
    this.portfolio,
    this.timeCoins = 0,
    this.subscriptionPackage,
    this.ratings = 0.0,
    this.reviewsCount = 0,
    this.reviews = const [],
    this.status = 'active',
    this.isPremium = false,
    this.earnedCertificates = const [],
    this.myOffers = const [],
    this.username,
    this.posts,
    this.donations,
    this.connections,
    this.linkedin,
    this.github,
    this.twitter,
  })  : assert(
          username == null || username.isEmpty || username.length <= 15,
          'Username must be 15 characters or less',
        );

  /// Build from login/signup user JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final fullName = (json['fullName'] ?? json['full_name'] ?? '').toString();
    final email = (json['email'] ?? '').toString();
    final age = (json['age'] as num?)?.toInt() ?? 0;
    final gender = (json['gender'] ?? '').toString();
    final location = (json['location'] ?? '').toString();
    final phoneNumber = (json['phoneNumber'] ?? json['phone_number'] ?? '').toString();
    final profilePic = (json['profilePic'] ?? json['profile_pic'])?.toString();
    final portfolio = (json['portfolio'])?.toString();
    final resume = (json['resume'])?.toString();
    final verified = json['verified'] == true;
    final ratings = (json['ratings'] as num?)?.toDouble() ?? 0.0;
    final reviewsCount = (json['reviews'] as num?)?.toInt() ?? 0;
    final isPremium = json['is_premium'] == true;

    final offeringRaw = json['offeringSkills'] ?? json['offering_skills'] ?? [];
    final offeringSkills = offeringRaw is List
        ? offeringRaw.map(_skillToDisplayName).where((s) => s.isNotEmpty).toList()
        : <String>[];
    final learningRaw = json['learningSkills'] ?? json['learning_skills'] ?? [];
    final learningSkills = learningRaw is List
        ? learningRaw.map(_skillToDisplayName).where((s) => s.isNotEmpty).toList()
        : <String>[];

    final certsRaw = json['earnedCertificates'] ?? json['earned_certificates'] ?? [];
    final earnedCertificates =
        certsRaw is List ? certsRaw.map((e) => e.toString()).toList() : <String>[];

    String portfolioLink = '';
    if (portfolio != null && portfolio.isNotEmpty) {
      portfolioLink = portfolio.startsWith('http')
          ? portfolio
          : '${ApiService.baseUrl}$portfolio';
    }

    return UserModel(
      id: id,
      fullName: fullName,
      email: email,
      password: '',
      age: age,
      gender: gender,
      location: location,
      phoneNumber: phoneNumber,
      portfolioLink: portfolioLink,
      verified: verified,
      bio: _str(json['bio']),
      profilePic: profilePic,
      education: _str(json['education']),
      offeringSkills: offeringSkills,
      learningSkills: learningSkills,
      pastExperience: _str(json['pastExperience'] ?? json['past_experience']),
      resume: resume,
      portfolio: portfolio,
      timeCoins: (json['timeCoins'] ?? json['time_coins'] as num?)?.toInt() ?? 0,
      subscriptionPackage: (json['subscriptionPackage'] ?? json['subscription_package'])?.toString(),
      ratings: ratings,
      reviewsCount: reviewsCount,
      status: (json['status'] ?? 'active').toString(),
      isPremium: isPremium,
      earnedCertificates: earnedCertificates,
      myOffers: const [],
    );
  }

  // Backward compatibility getters
  String get name => fullName;
  String get profileImage => profilePic ?? '';
  /// Full URL for profile image (baseUrl + path if path is relative).
  String get profileImageUrl {
    final p = profilePic;
    if (p == null || p.isEmpty) return '';
    if (p.startsWith('http')) return p;
    return '${ApiService.baseUrl}$p';
  }
  /// Full URL for portfolio file.
  String get portfolioFileUrl {
    if (portfolio == null || portfolio!.isEmpty) return portfolioLink;
    if (portfolio!.startsWith('http')) return portfolio!;
    return '${ApiService.baseUrl}$portfolio';
  }
  /// Full URL for resume file.
  String get resumeFileUrl {
    final r = resume;
    if (r == null || r.isEmpty) return '';
    if (r.startsWith('http')) return r;
    return '${ApiService.baseUrl}$r';
  }
  /// Full URLs for earned certificates.
  List<String> get earnedCertificateUrls => earnedCertificates
      .map((p) => p.startsWith('http') ? p : '${ApiService.baseUrl}$p')
      .toList();
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
