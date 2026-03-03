import 'package:flutter/material.dart';
import 'package:skillchain/models/received_bid.dart';
import 'package:skillchain/models/exchange_type.dart';
import 'package:skillchain/Pages/offers/offer_badges.dart';
import 'package:skillchain/Pages/offers/bid_sections.dart';

class ReceivedBidDetailScreen extends StatelessWidget {
  final ReceivedBid bid;

  const ReceivedBidDetailScreen({super.key, required this.bid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Received Bid Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildBidderInfo(),
                  const SizedBox(height: 20),
                  _buildSection(
                    child: buildBidSection(
                      label: 'Original:',
                      labelColor: Colors.grey.shade800,
                      offer: bid.originalOffer,
                      request: bid.originalRequest,
                      offerType: bid.postOfferType,
                      requestType: bid.postRequestType,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSection(
                    child: buildCounterSection(
                      label: 'Their Counter',
                      accentColor: Colors.orange.shade700,
                      offerType: bid.postOfferType,
                      requestType: bid.postRequestType,
                      counterTimeCoins: bid.suggestedTimeCoins,
                      counterBidderTeachingDuration: bid.bidderTeachingDuration,
                      counterPosterTeachingDuration: bid.posterTeachingDuration,
                    ),
                  ),
                  if (bid.message != null && bid.message!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildMessageSection(),
                  ],
                  const SizedBox(height: 20),
                  _buildMetadata(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  bid.postTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              buildExchangeTypeBadge(
                type: bid.isSkillExchange
                    ? ExchangeType.skillExchange
                    : ExchangeType.timecoinExchange,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildBidStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildBidStatusBadge() {
    Color bg;
    Color fg;
    switch (bid.status.toLowerCase()) {
      case 'accepted':
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        break;
      case 'rejected':
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        break;
      default:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        bid.status[0].toUpperCase() + bid.status.substring(1),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }

  Widget _buildBidderInfo() {
    final hasProfilePic = bid.profilePicUrl != null &&
        bid.profilePicUrl!.isNotEmpty &&
        Uri.tryParse(bid.profilePicUrl!)?.hasScheme == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.orange.shade100,
            backgroundImage:
                hasProfilePic ? NetworkImage(bid.profilePicUrl!) : null,
            child: hasProfilePic
                ? null
                : Text(
                    bid.bidderName.isNotEmpty
                        ? bid.bidderName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bid from',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bid.bidderName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (bid.bidderEmail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    bid.bidderEmail,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildMessageSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message_outlined,
                  size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Their Message',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bid.message!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        children: [
          if (bid.bidCreatedAt != null)
            _metaChip(
              icon: Icons.access_time,
              text: 'Received ${timeAgo(bid.bidCreatedAt)}',
            ),
          _metaChip(
            icon: Icons.hourglass_bottom,
            text: bid.expiryDate != null
                ? _expiryText(bid.expiryDate!)
                : 'No expiry',
            isWarning: bid.expiryDate != null &&
                bid.expiryDate!.isBefore(
                    DateTime.now().add(const Duration(days: 3))),
          ),
        ],
      ),
    );
  }

  Widget _metaChip({
    required IconData icon,
    required String text,
    bool isWarning = false,
  }) {
    final color = isWarning ? Colors.red : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color.shade600),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Accept bid — coming soon'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Accept',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reject bid — coming soon'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.cancel_outlined, size: 18),
              label: const Text('Reject',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _expiryText(DateTime date) {
    final diff = date.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inDays == 0) return 'Expires today';
    if (diff.inDays == 1) return 'Expires tomorrow';
    return 'Expires in ${diff.inDays} days';
  }
}
