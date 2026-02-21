import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/models/myoffer.dart';
import 'package:skillchain/models/exchange_type.dart';
import 'package:skillchain/services/timecoin_service.dart';

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({super.key});

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Received offers - offers from others in exchange for something they're offering
  final List<Offer> _receivedOffers = [
    Offer(
      // Required fields from schema
      id: '1',
      userId: 'user1',
      userName: 'Sarah Jenkins',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=47',
      title: "UI Design Session Request",
      description:
          "Sarah Jenkins wants to exchange Python programming skills for UI Design mentorship. Perfect match for your skills!",
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      timeline: "2 hours",
      exchangeType: ExchangeType.skillExchange,
      // Optional fields from schema
      coverImage:
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400',
      skillsOffering: ['UI Design', 'Figma', 'Design Principles'],
      skillsNeeded: ['Python', 'React'],
      status: 'active',
      matchPercentage: 98,
      offerDetails:
          "Session duration: 2 hours. Sarah has 4.9 rating and specializes in React development. She's offering Python tutoring in return.",
    ),
    Offer(
      id: '2',
      userId: 'user2',
      userName: 'David Chen',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=12',
      title: "React Development Exchange",
      description:
          "David Chen is offering Django backend development in exchange for React frontend guidance. Great opportunity to learn!",
      expiryDate: DateTime.now().add(const Duration(days: 5)),
      timeline: "1 week",
      exchangeType: ExchangeType.skillExchange,
      coverImage:
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400',
      skillsOffering: ['Django', 'Python', 'Backend Development'],
      skillsNeeded: ['React', 'Frontend Development'],
      status: 'active',
      matchPercentage: 85,
      offerDetails:
          "David is online now and responds quickly. He has experience with Python and Django. Perfect for expanding your backend skills.",
    ),
    Offer(
      id: '3',
      userId: 'user3',
      userName: 'Elena Rodriguez',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=33',
      title: "Marketing & SEO Training",
      description:
          "Elena Rodriguez offers professional Marketing and SEO training. Pay with timecoins to learn from a top-rated expert.",
      expiryDate: DateTime.now().add(const Duration(days: 10)),
      timeline: "3 hours",
      exchangeType: ExchangeType.timecoinExchange,
      coverImage:
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
      skillsOffering: ['Marketing', 'SEO', 'Digital Strategy'],
      skillsNeeded: [],
      rewardTimeCoins: 8,
      status: 'active',
      matchPercentage: 0,
      offerDetails:
          "Elena is top-rated (5.0) and specializes in Marketing and SEO. Comprehensive training session with practical examples.",
    ),
    Offer(
      id: '4',
      userId: 'user4',
      userName: 'Alex Johnson',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=51',
      title: "Figma Design Workshop",
      description:
          "Looking for someone to teach Figma design principles. Willing to offer research and UX design skills in return.",
      expiryDate: DateTime.now().add(const Duration(days: 3)),
      timeline: "3 hours",
      exchangeType: ExchangeType.skillExchange,
      coverImage:
          'https://images.unsplash.com/photo-1558655146-d09347e92766?w=400',
      skillsOffering: ['Research', 'UX Design', 'User Testing'],
      skillsNeeded: ['Figma', 'Design Tools'],
      status: 'active',
      matchPercentage: 75,
      offerDetails:
          "One-time 3-hour workshop session. Ideal for beginners looking to learn Figma from an experienced designer.",
    ),
    Offer(
      id: '5',
      userId: 'user5',
      userName: 'Michael Thompson',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=20',
      title: "Python Programming Course",
      description:
          "Learn Python programming from scratch. Perfect for beginners. Pay with timecoins to access this comprehensive course.",
      expiryDate: DateTime.now().add(const Duration(days: 14)),
      timeline: "2 weeks",
      exchangeType: ExchangeType.timecoinExchange,
      coverImage:
          'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=400',
      skillsOffering: ['Python', 'Programming', 'Coding'],
      skillsNeeded: [],
      rewardTimeCoins: 10,
      status: 'active',
      matchPercentage: 0,
      offerDetails:
          "Complete Python course covering basics to advanced topics. Includes hands-on projects and coding exercises.",
    ),
    // Additional offers to show different statuses
    Offer(
      id: '6',
      userId: 'user6',
      userName: 'Emma Wilson',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=45',
      title: "Data Science Bootcamp",
      description:
          "Comprehensive data science training covering Python, SQL, and machine learning fundamentals.",
      expiryDate: DateTime.now().subtract(const Duration(days: 2)),
      timeline: "4 weeks",
      exchangeType: ExchangeType.timecoinExchange,
      coverImage:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
      skillsOffering: ['Data Science', 'Machine Learning', 'Python', 'SQL'],
      skillsNeeded: [],
      rewardTimeCoins: 15,
      status: 'expired',
      matchPercentage: 0,
      offerDetails:
          "Intensive 4-week bootcamp with hands-on projects and real-world case studies.",
    ),
    Offer(
      id: '7',
      userId: 'user7',
      userName: 'James Martinez',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=32',
      title: "Web Development Mentorship",
      description:
          "Looking to exchange JavaScript expertise for mobile app development skills.",
      expiryDate: DateTime.now().add(const Duration(days: 20)),
      timeline: "Ongoing",
      exchangeType: ExchangeType.skillExchange,
      coverImage:
          'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400',
      skillsOffering: ['JavaScript', 'React', 'Node.js'],
      skillsNeeded: ['Flutter', 'Mobile Development'],
      status: 'completed',
      matchPercentage: 92,
      offerDetails:
          "Long-term mentorship program with weekly sessions and project collaboration.",
    ),
  ];

  // My offers - offers I've made to others in exchange for something I'm offering
  // Note: userName and userProfilePhoto represent the RECIPIENT (person I sent the offer to)
  final List<Offer> _myOffers = [
    Offer(
      id: '8',
      userId: 'recipient1',
      userName: 'Sarah Jenkins',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=47',
      title: "React Development Mentorship",
      description:
          "I'm offering React development mentorship in exchange for Python backend skills.",
      expiryDate: DateTime.now().add(const Duration(days: 12)),
      timeline: "2 weeks",
      exchangeType: ExchangeType.skillExchange,
      coverImage:
          'https://images.unsplash.com/photo-1633356122544-f134324a6cee?w=400',
      skillsOffering: ['React', 'Frontend Development', 'JavaScript'],
      skillsNeeded: ['Python', 'Backend Development'],
      status: 'active',
      matchPercentage: 88,
      offerDetails:
          "Comprehensive React mentorship with hands-on projects and code reviews.",
    ),
    Offer(
      id: '9',
      userId: 'recipient2',
      userName: 'David Chen',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=12',
      title: "UI/UX Design Consultation",
      description:
          "Offering professional UI/UX design consultation services. Pay with timecoins.",
      expiryDate: DateTime.now().add(const Duration(days: 8)),
      timeline: "3 hours",
      exchangeType: ExchangeType.timecoinExchange,
      coverImage:
          'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=400',
      skillsOffering: ['UI Design', 'UX Design', 'Figma'],
      skillsNeeded: [],
      rewardTimeCoins: 12,
      status: 'active',
      matchPercentage: 0,
      offerDetails:
          "Professional design consultation including wireframes, mockups, and design system guidance.",
    ),
    Offer(
      id: '10',
      userId: 'recipient3',
      userName: 'Elena Rodriguez',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=33',
      title: "Flutter Mobile App Development",
      description:
          "Looking to exchange Flutter mobile development skills for web development expertise.",
      expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      timeline: "1 month",
      exchangeType: ExchangeType.skillExchange,
      coverImage:
          'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=400',
      skillsOffering: ['Flutter', 'Dart', 'Mobile Development'],
      skillsNeeded: ['Web Development', 'HTML/CSS'],
      status: 'expired',
      matchPercentage: 75,
      offerDetails:
          "Long-term skill exchange program focusing on cross-platform mobile development.",
    ),
    Offer(
      id: '11',
      userId: 'recipient4',
      userName: 'Alex Johnson',
      userProfilePhoto: 'https://i.pravatar.cc/150?img=51',
      title: "Data Science Workshop",
      description:
          "Offering data science workshop covering Python, pandas, and machine learning basics.",
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      timeline: "1 week",
      exchangeType: ExchangeType.timecoinExchange,
      coverImage:
          'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400',
      skillsOffering: ['Data Science', 'Python', 'Machine Learning'],
      skillsNeeded: [],
      rewardTimeCoins: 20,
      status: 'pending',
      matchPercentage: 0,
      offerDetails:
          "Comprehensive data science workshop with hands-on projects and real datasets.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue.shade700,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: Colors.blue.shade700,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.inbox), text: "Received"),
            Tab(icon: Icon(Icons.send), text: "Sent"),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: TabBarView(
          controller: _tabController,
          children: [_buildReceivedOffersTab(), _buildMyOffersTab()],
        ),
      ),
    );
  }

  Widget _buildReceivedOffersTab() {
    if (_receivedOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No received offers",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              "Offers from others will appear here",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _receivedOffers.length,
      itemBuilder: (context, index) {
        final offer = _receivedOffers[index];
        return OfferCard(offer: offer, isReceived: true);
      },
    );
  }

  Widget _buildMyOffersTab() {
    if (_myOffers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No offers created",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              "Offers you create will appear here",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _myOffers.length,
      itemBuilder: (context, index) {
        final offer = _myOffers[index];
        return OfferCard(offer: offer, isReceived: false);
      },
    );
  }
}

class OfferCard extends StatelessWidget {
  final Offer offer;
  final bool isReceived;

  const OfferCard({super.key, required this.offer, this.isReceived = true});

  @override
  Widget build(BuildContext context) {
    final isSkillExchange = offer.exchangeType == ExchangeType.skillExchange;
    final daysUntilExpiry = offer.expirationDate
        .difference(DateTime.now())
        .inDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OfferDetailsScreen(offer: offer, isReceived: isReceived),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Title, Status, and Exchange Type Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  offer.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildStatusBadge(offer.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSkillExchange
                                      ? Colors.green.shade50
                                      : Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSkillExchange
                                        ? Colors.green.shade200
                                        : Colors.blue.shade200,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSkillExchange
                                          ? Icons.swap_horiz
                                          : Icons.monetization_on,
                                      size: 14,
                                      color: isSkillExchange
                                          ? Colors.green.shade700
                                          : Colors.blue.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isSkillExchange
                                          ? 'Skill Exchange'
                                          : 'Timecoin Exchange',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSkillExchange
                                            ? Colors.green.shade700
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isSkillExchange &&
                                  offer.timecoinCost != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: SvgPicture.asset(
                                          'assets/images/timecoin.svg',
                                          width: 16,
                                          height: 16,
                                          fit: BoxFit.contain,
                                          placeholderBuilder: (context) =>
                                              Container(
                                                width: 16,
                                                height: 16,
                                                color: Colors.grey.shade300,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${offer.timecoinCost}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // User info section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(offer.userProfilePhoto),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isReceived
                            ? offer.userName
                            : "Sent to ${offer.userName}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    if (offer.matchPercentage != null &&
                        offer.matchPercentage! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${offer.matchPercentage}% match',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  offer.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Footer: Expiration Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: daysUntilExpiry <= 3
                            ? Colors.red.shade50
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: daysUntilExpiry <= 3
                                ? Colors.red.shade700
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            daysUntilExpiry <= 0
                                ? 'Expired'
                                : daysUntilExpiry == 1
                                ? 'Expires tomorrow'
                                : 'Expires in $daysUntilExpiry days',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: daysUntilExpiry <= 3
                                  ? Colors.red.shade700
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (!isReceived)
                      Text(
                        'Timeline: ${offer.timeline}',
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
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        borderColor = Colors.green.shade200;
        statusText = 'Active';
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        borderColor = Colors.orange.shade200;
        statusText = 'Pending';
        break;
      case 'completed':
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        borderColor = Colors.blue.shade200;
        statusText = 'Completed';
        break;
      case 'expired':
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        borderColor = Colors.red.shade200;
        statusText = 'Expired';
        break;
      default:
        backgroundColor = Colors.grey.shade50;
        textColor = Colors.grey.shade700;
        borderColor = Colors.grey.shade200;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;
  final bool isReceived;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
    this.isReceived = true,
  });

  @override
  Widget build(BuildContext context) {
    final isSkillExchange = offer.exchangeType == ExchangeType.skillExchange;
    final daysUntilExpiry = offer.expirationDate
        .difference(DateTime.now())
        .inDays;

    return Scaffold(
      appBar: AppBar(title: Text(offer.title), elevation: 0),
      body: Container(
        color: Colors.grey.shade50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            offer.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSkillExchange
                                ? Colors.green.shade50
                                : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSkillExchange
                                  ? Colors.green.shade200
                                  : Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSkillExchange
                                    ? Icons.swap_horiz
                                    : Icons.monetization_on,
                                size: 16,
                                color: isSkillExchange
                                    ? Colors.green.shade700
                                    : Colors.blue.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isSkillExchange
                                    ? 'Skill Exchange'
                                    : 'Timecoin Exchange',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSkillExchange
                                      ? Colors.green.shade700
                                      : Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isSkillExchange && offer.timecoinCost != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.amber.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    'assets/images/timecoin.svg',
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${offer.timecoinCost}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: daysUntilExpiry <= 3
                            ? Colors.red.shade50
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: daysUntilExpiry <= 3
                                ? Colors.red.shade700
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            daysUntilExpiry <= 0
                                ? 'Expired'
                                : daysUntilExpiry == 1
                                ? 'Expires tomorrow'
                                : 'Expires in $daysUntilExpiry days',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: daysUntilExpiry <= 3
                                  ? Colors.red.shade700
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Profile Card (for offers I sent - My Offers tab)
              if (!isReceived) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Sent To",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                              offer.userProfilePhoto,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      offer.userName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (offer.matchPercentage != null &&
                                        offer.matchPercentage! > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.green.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '${offer.matchPercentage}% match',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (offer.skillsOffering.isNotEmpty) ...[
                                  Text(
                                    "Offering:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: offer.skillsOffering.take(3).map((
                                      skill,
                                    ) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          skill,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (offer.skillsNeeded.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          "Looking for:",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: offer.skillsNeeded.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.orange.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              // Description Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      offer.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Exchange Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Exchange Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      offer.offerDetails ?? offer.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              if (offer.exchangeType == ExchangeType.timecoinExchange &&
                  offer.timecoinCost != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            'assets/images/timecoin.svg',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You will earn",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${offer.timecoinCost} Timecoins",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              // Action Buttons
              if (isReceived) ...[
                // For received offers - show Accept/Decline buttons
                ElevatedButton(
                  onPressed: () {
                    if (offer.exchangeType == ExchangeType.skillExchange) {
                      final timecoinService = TimecoinService.instance;
                      const earnedCoins = 5;

                      timecoinService.earnTimecoins(
                        earnedCoins,
                        "Earned from ${offer.title}",
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Skill exchange accepted! You earned $earnedCoins timecoins.",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Exchange accepted! You will earn ${offer.timecoinCost} timecoins when the session is completed.",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSkillExchange
                        ? Colors.green
                        : Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSkillExchange
                            ? Icons.check_circle_outline
                            : Icons.monetization_on,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        offer.exchangeType == ExchangeType.skillExchange
                            ? "Accept Skill Exchange"
                            : "Accept Timecoin Exchange",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Exchange declined"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.close, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Decline",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // For my offers - show status and action buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Waiting for response from ${offer.userName}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Offer cancelled"),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 56),
                    side: BorderSide(color: Colors.red.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Cancel Offer",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
