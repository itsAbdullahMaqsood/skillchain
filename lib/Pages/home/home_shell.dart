import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/Pages/chat/chat_inbox.dart';
import 'package:skillchain/Pages/login/login_page.dart';
import 'package:skillchain/offers/open_offers.dart';
import 'package:skillchain/Pages/profile_page.dart';
import 'package:skillchain/Pages/timecoin/timecoin_screen.dart';
import 'package:skillchain/Pages/home/home_body_screen.dart';
import 'package:skillchain/offers/new_offer_screen.dart';
import 'package:skillchain/Widgets/home_drawer.dart';
import 'package:skillchain/models/user.dart';
import 'package:skillchain/models/recommendation.dart';
import 'package:skillchain/models/exchange_type.dart';
import 'package:skillchain/services/timecoin_service.dart';

/// Main scaffold with bottom navigation, app bar, and drawer.
/// Hosts Home, Chat, New Offer, Offers, and Profile.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final TimecoinService _timecoinService = TimecoinService.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final UserModel _sampleUser = UserModel(
    id: '1',
    fullName: 'Abu Bakar',
    email: 'AbuBakar@example.com',
    password: 'hashed_password_here',
    age: 28,
    gender: 'Male',
    location: 'New York, USA',
    phoneNumber: '+1234567890',
    portfolioLink: 'https://portfolio.abu-bakar.com',
    verified: true,
    bio: 'Passionate developer and skill exchange enthusiast',
    profilePic: 'https://i.pravatar.cc/150?img=68',
    education: 'BS Computer Science',
    offeringSkills: ['Flutter', 'Dart', 'UI/UX Design'],
    pastExperience: '5 years of experience in mobile app development',
    timeCoins: 50,
    subscriptionPackage: 'Premium',
    ratings: 4.8,
    status: 'active',
    username: 'AbuBakar',
    posts: 12,
    donations: 5,
    connections: 24,
    linkedin: 'linkedin.com/in/AbuBakar',
    github: 'github.com/AbuBakar',
    twitter: '@AbuBakar',
  );

  final List<Recommendation> _recommendations = [
    Recommendation(
      id: '1',
      name: 'Sarah Jenkins',
      profileImage: 'https://i.pravatar.cc/300?img=47',
      isVerified: true,
      rating: 4.9,
      status: 'Replies in 1h',
      matchPercentage: 98,
      offers: ['UI Design', 'Figma', 'Research'],
      needs: ['Python', 'React'],
      exchangeType: ExchangeType.skillExchange,
    ),
    Recommendation(
      id: '2',
      name: 'David Chen',
      profileImage: 'https://i.pravatar.cc/300?img=12',
      isVerified: false,
      rating: 4.7,
      status: 'Online Now',
      matchPercentage: 85,
      offers: ['Python', 'Django'],
      needs: ['UX Design', 'English'],
      exchangeType: ExchangeType.skillExchange,
    ),
    Recommendation(
      id: '3',
      name: 'Elena Rodriguez',
      profileImage: 'https://i.pravatar.cc/300?img=33',
      isVerified: true,
      rating: 5.0,
      status: 'Replies in 5m',
      matchPercentage: 0,
      isTopRated: true,
      offers: ['Marketing', 'SEO'],
      needs: ['Webflow'],
      exchangeType: ExchangeType.timecoinExchange,
      timecoinCost: 8,
    ),
    Recommendation(
      id: '4',
      name: 'Michael Thomp',
      profileImage: 'https://i.pravatar.cc/300?img=20',
      isVerified: true,
      rating: 4.8,
      status: 'Replies in 2h',
      matchPercentage: 92,
      offers: ['JavaScript', 'Node.js'],
      needs: [],
      exchangeType: ExchangeType.timecoinExchange,
      timecoinCost: 6,
    ),
  ];

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  List<Recommendation> get _filteredRecommendations {
    if (_searchQuery.isEmpty) {
      return _recommendations;
    }
    return _recommendations.where((recommendation) {
      final nameMatch =
          recommendation.name.toLowerCase().contains(_searchQuery);
      final offersMatch = recommendation.offers
          .any((skill) => skill.toLowerCase().contains(_searchQuery));
      final needsMatch = recommendation.needs
          .any((skill) => skill.toLowerCase().contains(_searchQuery));
      return nameMatch || offersMatch || needsMatch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      drawer: HomeDrawer(
        user: _sampleUser,
        timecoinBalance: _timecoinService.getBalance(),
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onPushScreen: (screen) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ).then((_) {
            setState(() {}); // Refresh balance etc. when returning
          });
        },
        onLogout: () => _logout(context),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        titleSpacing: 0,
        title: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase().trim();
              });
            },
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimecoinScreen()),
              ).then((_) {
                setState(() {});
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/timecoin.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _timecoinService.getBalance().toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart),
            label: "Offers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeBodyScreen(
          recommendations: _filteredRecommendations,
          searchQuery: _searchQuery,
          onBalanceUpdate: () => setState(() {}),
        );
      case 1:
        return const ChatInboxScreen();
      case 2:
        return const NewOfferScreen();
      case 3:
        return const MyOffersScreen();
      case 4:
        return ProfileScreen(user: _sampleUser, isCurrentUser: true);
      default:
        return HomeBodyScreen(
          recommendations: _filteredRecommendations,
          searchQuery: _searchQuery,
          onBalanceUpdate: () => setState(() {}),
        );
    }
  }
}
