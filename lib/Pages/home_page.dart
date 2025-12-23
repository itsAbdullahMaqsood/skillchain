import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/Pages/chat_inbox.dart';
import 'package:skillchain/Pages/login_page.dart';
import 'package:skillchain/Pages/my_offers.dart';
import 'package:skillchain/Pages/profile_page.dart';
import 'package:skillchain/Pages/timecoin_screen.dart';
import 'package:skillchain/models/user.dart';
import 'package:skillchain/models/recommendation.dart';
import 'package:skillchain/models/exchange_type.dart';
import 'package:skillchain/services/timecoin_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TimecoinService _timecoinService = TimecoinService.instance;
  ExchangeType _selectedExchangeType = ExchangeType.skillExchange;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample user for profile
  final UserModel _sampleUser = UserModel(
    // Required fields
    id: '1',
    fullName: 'Abu Bakar',
    email: 'AbuBakar@example.com',
    password: 'hashed_password_here', // In real app, this would be hashed
    age: 28,
    gender: 'Male',
    location: 'New York, USA',
    phoneNumber: '+1234567890',
    portfolioLink: 'https://portfolio.abu-bakar.com',
    verified: true,
    // Optional fields
    bio: 'Passionate developer and skill exchange enthusiast',
    profilePic: 'https://i.pravatar.cc/150?img=68',
    education: 'BS Computer Science',
    offeringSkills: ['Flutter', 'Dart', 'UI/UX Design'],
    pastExperience: '5 years of experience in mobile app development',
    timeCoins: 50,
    subscriptionPackage: 'Premium',
    ratings: 4.8,
    status: 'active',
    // Legacy fields
    username: 'AbuBakar',
    posts: 12,
    donations: 5,
    connections: 24,
    linkedin: 'linkedin.com/in/AbuBakar',
    github: 'github.com/AbuBakar',
    twitter: '@AbuBakar',
  );

  // Sample recommendations
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
      (route) => false, // Remove all previous routes
    );
  }

  List<Recommendation> get _filteredRecommendations {
    if (_searchQuery.isEmpty) {
      return _recommendations;
    }

    return _recommendations.where((recommendation) {
      // Search by name
      final nameMatch = recommendation.name.toLowerCase().contains(
        _searchQuery,
      );

      // Search by skills offered
      final offersMatch = recommendation.offers.any(
        (skill) => skill.toLowerCase().contains(_searchQuery),
      );

      // Search by skills needed
      final needsMatch = recommendation.needs.any(
        (skill) => skill.toLowerCase().contains(_searchQuery),
      );

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
      drawer: buildDrawer(context),

      /// 🔝 App Bar
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
                setState(() {}); // Refresh balance display
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

      /// 🧠 Body
      body: _getBody(),

      /// 🔻 Bottom Navigation
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
        return _buildHomeBody();
      case 1:
        return _buildChatBody();
      case 2:
        return _buildNewOfferBody();
      case 3:
        return _buildExploreBody();
      case 4:
        return _buildProfileBody();
      default:
        return _buildHomeBody();
    }
  }

  Widget _buildHomeBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          const Text(
            "Skill Chain",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 4),

          /// Subtitle
          Text(
            "Find your perfect skill exchange partner",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 16),

          /// Search + Filter
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        "Search skills or people",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Text("Best Match"),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Top Recommendations Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Top Recommendations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Recommendation Cards
          Expanded(
            child: _filteredRecommendations.isEmpty && _searchQuery.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No results found",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Try searching with different keywords",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredRecommendations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _RecommendationCard(
                        recommendation: _filteredRecommendations[index],
                        onBalanceUpdate: () {
                          setState(() {}); // Refresh balance display
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBody() {
    return const ChatInboxScreen();
  }

  Widget _buildNewOfferBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create New Offer",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Share your skills and find what you need",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),

          // Title Field
          const Text(
            "Title",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "e.g., Looking for Python Developer",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 20),

          // Description Field
          const Text(
            "Description",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Describe what you're looking for or offering...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 20),

          // Skills I Offer Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Skills I Offer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Add skills (e.g., UI Design, Figma, React)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Skills I Need Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.purple.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Skills I Need",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Add skills you need (e.g., Python, Django)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Exchange Type Selection
          const Text(
            "Exchange Type",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                RadioListTile<ExchangeType>(
                  title: const Text("Skill Exchange"),
                  subtitle: const Text(
                    "Exchange skills with others (no timecoins)",
                  ),
                  value: ExchangeType.skillExchange,
                  groupValue: _selectedExchangeType,
                  onChanged: (value) {
                    setState(() {
                      _selectedExchangeType = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ExchangeType>(
                  title: const Text("Timecoin Exchange"),
                  subtitle: const Text("Charge timecoins for your skills"),
                  value: ExchangeType.timecoinExchange,
                  groupValue: _selectedExchangeType,
                  onChanged: (value) {
                    setState(() {
                      _selectedExchangeType = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timecoin Cost Field (only for timecoin exchange)
          if (_selectedExchangeType == ExchangeType.timecoinExchange) ...[
            const Text(
              "Timecoin Cost",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter timecoin cost (e.g., 5, 8, 10)",
                prefixIcon: const Icon(Icons.monetization_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Duration/Time Field
          const Text(
            "Duration",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "e.g., 2 hours, 1 week, Ongoing",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 30),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Handle offer creation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Offer created successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Create Offer",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExploreBody() {
    return MyOffersScreen();
  }

  Widget _buildProfileBody() {
    return ProfileScreen(user: _sampleUser, isCurrentUser: true);
  }

  Drawer buildDrawer(BuildContext context) {
    final timecoinBalance = _timecoinService.getBalance();

    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Enhanced Drawer Header with Blue Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade600,
                    Colors.blue.shade500,
                  ],
                ),
              ),
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: const AssetImage(
                          "assets/images/profile.png",
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
                                  _sampleUser.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (_sampleUser.verified)
                                  Icon(
                                    Icons.verified,
                                    color: Colors.amber.shade300,
                                    size: 20,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _sampleUser.email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Timecoin Balance Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
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
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$timecoinBalance',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick Stats Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    icon: Icons.people_outline,
                    value: '${_sampleUser.connections ?? 0}',
                    label: 'Connections',
                  ),
                  Container(width: 1, height: 40, color: Colors.blue.shade200),
                  _buildStatItem(
                    context,
                    icon: Icons.star_outline,
                    value: _sampleUser.ratings.toStringAsFixed(1),
                    label: 'Rating',
                  ),
                  Container(width: 1, height: 40, color: Colors.blue.shade200),
                  _buildStatItem(
                    context,
                    icon: Icons.work_outline,
                    value: '${_sampleUser.posts ?? 0}',
                    label: 'Offers',
                  ),
                ],
              ),
            ),

            // Main Menu Items
            _buildDrawerItem(
              context,
              icon: Icons.home_outlined,
              title: 'Home',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inbox_outlined,
              title: 'My Offers',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOffersScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.monetization_on_outlined,
              title: 'Timecoins',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimecoinScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'Messages',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              badge: '3', // Example badge count
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications feature coming soon!'),
                  ),
                );
              },
            ),

            const Divider(height: 1),

            _buildDrawerItem(
              context,
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 4;
                });
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help & Support feature coming soon!'),
                  ),
                );
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('About Skill Chain'),
                    content: const Text(
                      'Skill Chain v1.0.0\n\n'
                      'Connect, learn, and exchange skills with a global community.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(height: 1),

            // Logout
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              textColor: Colors.red.shade700,
              iconColor: Colors.red.shade700,
              onTap: () {
                Navigator.pop(context);
                _logout(context);
              },
            ),

            const SizedBox(height: 20),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Skill Chain © 2024',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.blue.shade700, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.blue.shade700, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  final VoidCallback? onBalanceUpdate;

  const _RecommendationCard({
    required this.recommendation,
    this.onBalanceUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Profile, Name, Rating, Match Badge
          Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(recommendation.profileImage),
              ),
              const SizedBox(width: 12),
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          recommendation.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (recommendation.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          recommendation.rating.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          recommendation.status,
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
              // Match Badge or Top Rated Badge
              if (recommendation.isTopRated)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Top Rated',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.blue.shade700),
                      const SizedBox(width: 4),
                      Text(
                        '${recommendation.matchPercentage}% Match',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // OFFERS Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'OFFERS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (recommendation.exchangeType ==
                        ExchangeType.timecoinExchange &&
                    recommendation.timecoinCost != null)
                  // Show timecoin cost for timecoin exchanges
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/timecoin.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'timecoins: ${recommendation.timecoinCost}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  )
                else
                  // Show skills for skill exchanges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recommendation.offers.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // NEEDS Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.purple.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'NEEDS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recommendation.needs.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Exchange Type Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      recommendation.exchangeType == ExchangeType.skillExchange
                      ? Colors.green.shade50
                      : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      recommendation.exchangeType == ExchangeType.skillExchange
                          ? Icons.swap_horiz
                          : Icons.monetization_on,
                      size: 14,
                      color:
                          recommendation.exchangeType ==
                              ExchangeType.skillExchange
                          ? Colors.green.shade700
                          : Colors.blue.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      recommendation.exchangeType == ExchangeType.skillExchange
                          ? 'Skill Exchange'
                          : 'Timecoin Exchange',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            recommendation.exchangeType ==
                                ExchangeType.skillExchange
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (recommendation.exchangeType ==
                        ExchangeType.skillExchange) {
                      // Skill Exchange - No payment needed
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Request Skill Exchange"),
                          content: Text(
                            "You'll exchange your skills with ${recommendation.name}.\n\n"
                            "This is a skill-for-skill exchange - no timecoins required!",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Skill exchange requested with ${recommendation.name}!",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: const Text("Confirm"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Timecoin Exchange - Payment required
                      final timecoinService = TimecoinService.instance;
                      final sessionCost = recommendation.timecoinCost ?? 5;

                      if (timecoinService.getBalance() >= sessionCost) {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Request Session"),
                            content: Text(
                              "This session will cost $sessionCost timecoins.\n\n"
                              "Current balance: ${timecoinService.getBalance()} timecoins\n"
                              "After payment: ${timecoinService.getBalance() - sessionCost} timecoins\n\n"
                              "Do you want to proceed?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final success = timecoinService
                                      .spendTimecoins(
                                        sessionCost,
                                        "Session with ${recommendation.name}",
                                        relatedUserId: recommendation.id,
                                      );
                                  Navigator.pop(context);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Session requested! ${sessionCost} timecoins deducted.",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    onBalanceUpdate?.call();
                                  }
                                },
                                child: const Text("Confirm"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Insufficient balance
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Insufficient Timecoins"),
                            content: Text(
                              "You need $sessionCost timecoins to request this session.\n\n"
                              "Current balance: ${timecoinService.getBalance()} timecoins\n\n"
                              "Would you like to purchase more timecoins?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TimecoinScreen(),
                                    ),
                                  ).then((_) => onBalanceUpdate?.call());
                                },
                                child: const Text("Buy Timecoins"),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        recommendation.exchangeType ==
                            ExchangeType.skillExchange
                        ? Colors.green
                        : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recommendation.exchangeType ==
                                ExchangeType.skillExchange
                            ? 'Request Skill Exchange'
                            : 'Request Session',
                      ),
                      if (recommendation.exchangeType ==
                              ExchangeType.timecoinExchange &&
                          recommendation.timecoinCost != null) ...[
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/images/timecoin.svg',
                          width: 16,
                          height: 16,
                          // colorFilter: const ColorFilter.mode(
                          //   Colors.black,
                          //   BlendMode.srcIn,
                          // ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}
