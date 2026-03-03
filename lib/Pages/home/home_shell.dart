import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillchain/Pages/chat/chat_inbox.dart';
import 'package:skillchain/Pages/login/login_page.dart';
import 'package:skillchain/Pages/offers/open_offers.dart';
import 'package:skillchain/Pages/profile_page.dart';
import 'package:skillchain/Pages/timecoin/timecoin_screen.dart';
import 'package:skillchain/Pages/home/home_body_screen.dart';
import 'package:skillchain/Pages/offers/new_offer_screen.dart';
import 'package:skillchain/Widgets/home_drawer.dart';
import 'package:skillchain/models/user.dart';
import 'package:skillchain/models/skill_post.dart';
import 'package:skillchain/services/auth_service.dart';
import 'package:skillchain/services/timecoin_service.dart';
import 'package:skillchain/services/skill_post_service.dart';

enum SortMode { bestMatch, newestFirst, oldestFirst }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  final TimecoinService _timecoinService = TimecoinService.instance;
  final SkillPostService _skillPostService = SkillPostService();
  String _searchQuery = '';
  SortMode _sortMode = SortMode.bestMatch;

  // Feed state
  List<SkillPost> _posts = [];
  bool _isLoadingInitial = false;
  bool _isFetchingMore = false;
  bool _isFetching = false;
  bool _hasMore = true;
  int _offset = 0;
  String? _feedError;
  String _activeSearch = '';
  static const int _pageLimit = 10;
  static const String _feedStatus = 'active';

  UserModel? _currentUser;
  final Map<String, SkillPost> _postsById = {};
  final AuthService _authService = AuthService();

  UserModel get _userForDrawer =>
      _currentUser ??
      UserModel(
        id: '',
        fullName: 'Loading...',
        email: '',
        password: '',
        age: 0,
        gender: '',
        location: '',
        phoneNumber: '',
        portfolioLink: '',
        verified: false,
      );

  @override
  void initState() {
    super.initState();
    _fetchPosts(isInitial: true);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    if (mounted) setState(() => _currentUser = user);
  }

  Future<void> _fetchPosts({bool isInitial = false}) async {
    if (_isFetching) return;
    if (!isInitial && !_hasMore) return;
    _isFetching = true;

    if (isInitial) {
      _offset = 0;
      _postsById.clear();
    }

    setState(() {
      _isLoadingInitial = isInitial;
      _isFetchingMore = !isInitial;
      _feedError = isInitial ? null : _feedError;
    });

    final requestOffset = _offset;

    try {
      final result = await _skillPostService.getSkillPosts(
        limit: _pageLimit,
        offset: requestOffset,
        status: _feedStatus,
        search: _activeSearch.isNotEmpty ? _activeSearch : null,
      );
      if (!mounted) return;

      int addedCount = 0;
      for (final post in result.posts) {
        if (!post.isExpired && !_postsById.containsKey(post.id)) {
          _postsById[post.id] = post;
          addedCount++;
        }
      }

      final nextOffset = requestOffset + result.posts.length;
      final moreAvailable =
          result.hasMore && result.posts.isNotEmpty && addedCount > 0;

      debugPrint(
        '[Feed] offset=$requestOffset fetched=${result.posts.length} '
        'new=$addedCount total=${_postsById.length} '
        'nextOffset=$nextOffset hasMore=$moreAvailable',
      );

      setState(() {
        _posts = _sortPosts(_postsById.values.toList());
        _offset = nextOffset;
        _hasMore = moreAvailable;
        _isLoadingInitial = false;
        _isFetchingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingInitial = false;
        _isFetchingMore = false;
        if (isInitial) _feedError = e.toString();
      });
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onRefresh() async {
    _hasMore = true;
    await _fetchPosts(isInitial: true);
  }

  void _onBidStatusChanged(String postId, bool hasUserBid) {
    final existing = _postsById[postId];
    if (existing != null) {
      _postsById[postId] = existing.copyWith(hasUserBid: hasUserBid);
      setState(() {
        _posts = _sortPosts(_postsById.values.toList());
      });
    }
  }

  void _onSearchChanged(String value) {
    final trimmed = value.trim();
    if (trimmed == _activeSearch) return;
    _searchQuery = value.toLowerCase().trim();
    _activeSearch = trimmed;
    _hasMore = true;
    _fetchPosts(isInitial: true);
  }

  List<SkillPost> _sortPosts(List<SkillPost> posts) {
    switch (_sortMode) {
      case SortMode.bestMatch:
        posts.sort((a, b) {
          if (a.matchesMySkills && !b.matchesMySkills) return -1;
          if (!a.matchesMySkills && b.matchesMySkills) return 1;
          final aDate = a.createdAt ?? DateTime(2000);
          final bDate = b.createdAt ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });
      case SortMode.newestFirst:
        posts.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(2000);
          final bDate = b.createdAt ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });
      case SortMode.oldestFirst:
        posts.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(2000);
          final bDate = b.createdAt ?? DateTime(2000);
          return aDate.compareTo(bDate);
        });
    }
    return posts;
  }

  void _onSortChanged(SortMode mode) {
    if (mode == _sortMode) return;
    setState(() {
      _sortMode = mode;
      _posts = _sortPosts(_postsById.values.toList());
    });
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex > 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
      endDrawer: HomeDrawer(
        user: _userForDrawer,
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
            setState(() {});
          });
        },
        onLogout: () => _logout(context),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 110,
        leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TimecoinScreen()),
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
        centerTitle: true,
        titleSpacing: 0,
        title: const SizedBox(
          width: double.infinity,
          child: Text(
            'Skill Chain',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: 0.3,
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.black),
                  onPressed: () {},
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ],
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
      ),
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return HomeBodyScreen(
          posts: _posts,
          searchQuery: _searchQuery,
          isLoadingInitial: _isLoadingInitial,
          isFetchingMore: _isFetchingMore,
          hasMore: _hasMore,
          feedError: _feedError,
          onFetchMore: () => _fetchPosts(),
          onRefresh: _onRefresh,
          onBalanceUpdate: () => setState(() {}),
          onSearchSubmitted: _onSearchChanged,
          sortMode: _sortMode,
          onSortChanged: _onSortChanged,
          onBidStatusChanged: _onBidStatusChanged,
        );
      case 1:
        return const ChatInboxScreen();
      case 2:
        return const NewOfferScreen();
      case 3:
        return const MyOffersScreen();
      case 4:
        return _currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : ProfileScreen(
                user: _currentUser!,
                isCurrentUser: true,
                onProfileUpdated: (u) => setState(() => _currentUser = u),
              );
      default:
        return HomeBodyScreen(
          posts: _posts,
          searchQuery: _searchQuery,
          isLoadingInitial: _isLoadingInitial,
          isFetchingMore: _isFetchingMore,
          hasMore: _hasMore,
          feedError: _feedError,
          onFetchMore: () => _fetchPosts(),
          onRefresh: _onRefresh,
          onBalanceUpdate: () => setState(() {}),
          onSearchSubmitted: _onSearchChanged,
          sortMode: _sortMode,
          onSortChanged: _onSortChanged,
          onBidStatusChanged: _onBidStatusChanged,
        );
    }
  }
}
