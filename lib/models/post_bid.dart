/// A bid embedded in the GET /skill-posts/{id} response.
/// Lighter than ReceivedBid -- no post-level fields (those come from the parent post).
class PostBid {
  final String bidId;
  final String bidderId;
  final String bidderName;
  final String bidderEmail;
  final String? message;
  final int? posterTeachingDuration;
  final int? bidderTeachingDuration;
  final int? suggestedTimeCoins;
  final String? acceptComment;
  final String status;
  final DateTime? createdAt;

  PostBid({
    required this.bidId,
    required this.bidderId,
    required this.bidderName,
    required this.bidderEmail,
    this.message,
    this.posterTeachingDuration,
    this.bidderTeachingDuration,
    this.suggestedTimeCoins,
    this.acceptComment,
    required this.status,
    this.createdAt,
  });

  factory PostBid.fromJson(Map<String, dynamic> json) {
    final bidder = json['bidder_id'];
    String bidderId = '';
    String bidderName = '';
    String bidderEmail = '';
    if (bidder is Map<String, dynamic>) {
      bidderId = (bidder['_id'] ?? '').toString();
      bidderName = (bidder['fullName'] ?? bidder['full_name'] ?? '').toString();
      bidderEmail = (bidder['email'] ?? '').toString();
    } else if (bidder is String) {
      bidderId = bidder;
    }

    return PostBid(
      bidId: (json['_id'] ?? json['id'] ?? '').toString(),
      bidderId: bidderId,
      bidderName: bidderName,
      bidderEmail: bidderEmail,
      message: json['message']?.toString(),
      posterTeachingDuration: _parseInt(json['proposed_timeline']),
      bidderTeachingDuration: _parseInt(json['course_timeline']),
      suggestedTimeCoins: _parseInt(json['suggested_time_coins']),
      acceptComment: json['accept_comment']?.toString(),
      status: (json['status'] ?? 'pending').toString(),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
