import 'package:flutter/material.dart';
import 'package:skillchain/models/skill_post.dart';
import 'package:skillchain/Pages/home/home_shell.dart';
import 'package:skillchain/Widgets/recommendation_card.dart';

class HomeBodyScreen extends StatefulWidget {
  final List<SkillPost> posts;
  final String searchQuery;
  final bool isLoadingInitial;
  final bool isFetchingMore;
  final bool hasMore;
  final String? feedError;
  final VoidCallback onFetchMore;
  final Future<void> Function() onRefresh;
  final VoidCallback onBalanceUpdate;
  final ValueChanged<String> onSearchSubmitted;
  final SortMode sortMode;
  final ValueChanged<SortMode> onSortChanged;

  const HomeBodyScreen({
    super.key,
    required this.posts,
    required this.searchQuery,
    required this.isLoadingInitial,
    required this.isFetchingMore,
    required this.hasMore,
    required this.feedError,
    required this.onFetchMore,
    required this.onRefresh,
    required this.onBalanceUpdate,
    required this.onSearchSubmitted,
    required this.sortMode,
    required this.onSortChanged,
  });

  @override
  State<HomeBodyScreen> createState() => _HomeBodyScreenState();
}

class _HomeBodyScreenState extends State<HomeBodyScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  double _headerFade = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.searchQuery.isNotEmpty) {
      _searchController.text = widget.searchQuery;
    }
  }

  void _submitSearch() {
    final text = _searchController.text.trim();
    FocusScope.of(context).unfocus();
    widget.onSearchSubmitted(text);
  }

  @override
  void didUpdateWidget(covariant HomeBodyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery &&
        widget.searchQuery != _searchController.text.trim().toLowerCase()) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final raw = (1.0 - (_scrollController.offset / 60.0)).clamp(0.0, 1.0);
      final rounded = (raw * 20).roundToDouble() / 20;
      if (rounded != _headerFade) {
        setState(() => _headerFade = rounded);
      }
    }

    if (widget.isFetchingMore || !widget.hasMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      widget.onFetchMore();
    }
  }

  static String _sortLabel(SortMode mode) {
    switch (mode) {
      case SortMode.bestMatch:
        return 'Best Match';
      case SortMode.newestFirst:
        return 'Newest First';
      case SortMode.oldestFirst:
        return 'Oldest First';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Opacity(
              opacity: _headerFade,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  "Find your perfect skill exchange partner",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchRowDelegate(
              child: _buildSearchRow(),
              backgroundColor: bg,
            ),
          ),
          SliverToBoxAdapter(
            child: Opacity(
              opacity: _headerFade,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Text(
                  "Top Recommendations",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          ..._buildContentSlivers(),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _submitSearch(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Search skills or people",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearchSubmitted('');
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.blue.shade700,
                      ),
                      onPressed: _submitSearch,
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 10),
        PopupMenuButton<SortMode>(
          onSelected: widget.onSortChanged,
          itemBuilder: (_) => const [
            PopupMenuItem(value: SortMode.bestMatch, child: Text('Best Match')),
            PopupMenuItem(
              value: SortMode.newestFirst,
              child: Text('Newest First'),
            ),
            PopupMenuItem(
              value: SortMode.oldestFirst,
              child: Text('Oldest First'),
            ),
          ],
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _sortLabel(widget.sortMode),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildContentSlivers() {
    if (widget.isLoadingInitial) {
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, _) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSkeletonCard(),
              ),
              childCount: 4,
            ),
          ),
        ),
      ];
    }

    if (widget.feedError != null && widget.posts.isEmpty) {
      return [
        SliverFillRemaining(hasScrollBody: false, child: _buildErrorState()),
      ];
    }

    final items = widget.posts;

    if (items.isEmpty && widget.searchQuery.isNotEmpty) {
      return [
        SliverFillRemaining(hasScrollBody: false, child: _buildSearchEmpty()),
      ];
    }

    if (items.isEmpty) {
      return [
        SliverFillRemaining(hasScrollBody: false, child: _buildEmptyState()),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index < items.length) {
              final post = items[index];
              return Padding(
                key: ValueKey(post.id),
                padding: const EdgeInsets.only(bottom: 16),
                child: RecommendationCard(
                  post: post,
                  onBalanceUpdate: widget.onBalanceUpdate,
                ),
              );
            }
            return _buildBottomLoader();
          }, childCount: items.length + (widget.isFetchingMore ? 1 : 0)),
        ),
      ),
    ];
  }

  Widget _buildSkeletonCard() {
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
            children: [
              _shimmerBox(56, 56, radius: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(14, 140),
                    const SizedBox(height: 8),
                    _shimmerBox(12, 100),
                  ],
                ),
              ),
              _shimmerBox(24, 80, radius: 12),
            ],
          ),
          const SizedBox(height: 16),
          _shimmerBox(60, double.infinity, radius: 12),
          const SizedBox(height: 12),
          _shimmerBox(60, double.infinity, radius: 12),
          const SizedBox(height: 16),
          _shimmerBox(36, double.infinity, radius: 8),
        ],
      ),
    );
  }

  Widget _shimmerBox(double height, double width, {double radius = 4}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildBottomLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "Couldn't load posts",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "Check your connection and try again",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No posts yet",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "Be the first to post a skill exchange!",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching with different keywords",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _SearchRowDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color backgroundColor;

  _SearchRowDelegate({required this.child, required this.backgroundColor});

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _SearchRowDelegate oldDelegate) => true;
}
