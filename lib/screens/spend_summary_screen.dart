import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart' as AppTheme;
import '../data/mock_data.dart';
import '../widgets/category_list.dart';
import '../widgets/section_title.dart';
import '../widgets/spend_header_card.dart';
import '../widgets/transaction_tile.dart';

class SpendSummaryScreen extends StatefulWidget {
  const SpendSummaryScreen({super.key});

  @override
  State<SpendSummaryScreen> createState() => _SpendSummaryScreenState();
}

class _SpendSummaryScreenState extends State<SpendSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _appBarController;
  late Animation<double> _appBarFade;

  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _showLoadingEffect = false;
  int _itemsToShow = 10;

  @override
  void initState() {
    super.initState();

    _appBarController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    _appBarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeOut),
    );

    _appBarController.forward();

    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 20;
      if (scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    });
  }

  @override
  void dispose() {
    _appBarController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = getCategories();
    final transactions = getTransactions();
    final totalSpend = getTotalMonthlySpend();
    final growth = getMonthlyGrowthPercentage();
    final budget = getMonthlyBudget();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom SliverAppBar
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,
                backgroundColor: AppTheme.backgroundDark,
                elevation: 0,
                expandedHeight: 72,
                flexibleSpace: FadeTransition(
                  opacity: _appBarFade,
                  child: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gold dot logo
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryLight,
                                AppTheme.primaryColor,
                                AppTheme.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.currency_rupee_rounded,
                            color: Color(0xFF0D0D0F),
                            size: 15,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Spendly',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 22,
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    background: Container(color: AppTheme.backgroundDark),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildActionButton(
                      icon: Icons.search_rounded,
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _buildNotificationButton(),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    SpendHeaderCard(
                      totalSpend: totalSpend,
                      growthPercentage: growth,
                      budget: budget,
                    ),

                    const SizedBox(height: 24),

                    // Categories
                    SectionTitle(
                      title: 'Categories',
                      subtitle: '${categories.length} active',
                      onSeeAll: () {},
                    ),

                    CategoryList(categories: categories),

                    const SizedBox(height: 8),

                    // Transactions header with count badge
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Transactions',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 20,
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Text(
                                  'This month',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              '${transactions.length} items',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Transactions
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100, top: 8),
                      itemCount: _itemsToShow < transactions.length
                          ? _itemsToShow + 1 // +1 for "Load More" button
                          : transactions
                              .length, // ← key fix: cap at actual list size
                      itemBuilder: (context, index) {
                        // Show "Load More" button as the last item
                        if (index == _itemsToShow &&
                            _itemsToShow < transactions.length) {
                          return _buildMoreButton();
                        }

                        // Hard guard — never read past the end of the list
                        if (index >= transactions.length) {
                          return const SizedBox.shrink();
                        }

                        final tx = transactions[index];
                        final showSeparator = index == 0 ||
                            _isDifferentDay(
                                transactions[index - 1].date, tx.date);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showSeparator)
                              _buildDateSeparator(tx.date, index),
                            TransactionTile(
                              transaction: tx,
                              animationDelayIndex: index,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Loading overlay
          if (_showLoadingEffect)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading more transactions...',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),

      // FAB
      floatingActionButton: _buildFAB(context),
    );
  }

  bool _isDifferentDay(DateTime a, DateTime b) =>
      DateTime(a.year, a.month, a.day) != DateTime(b.year, b.month, b.day);

  Widget _buildMoreButton() => GestureDetector(
        onTap: () {
          setState(() {
            _showLoadingEffect = true;
            _itemsToShow += 10;
          });

          // Show loading effect for 0.5 seconds
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() => _showLoadingEffect = false);
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Load More Transactions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildDateSeparator(DateTime date, int index) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDay = DateTime(date.year, date.month, date.day);

    String label;
    if (txDay == today) {
      label = 'Today';
    } else if (txDay == today.subtract(const Duration(days: 1))) {
      label = 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      label = '${date.day} ${months[date.month - 1]}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textTertiary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.dividerColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Icon(icon, size: 18, color: AppTheme.textSecondary),
        ),
      );

  Widget _buildNotificationButton() => GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 18,
                color: AppTheme.textSecondary,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppTheme.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
}

Widget _buildFAB(BuildContext context) => GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showAddTransactionSheet(context);
      },
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primaryLight, AppTheme.primaryDark],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Color(0xFF0D0D0F),
          size: 28,
        ),
      ),
    );

void _showAddTransactionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.surfaceElevated,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Add Transaction',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Record a new expense quickly',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _fabOption(
                    Icons.fastfood_rounded, 'Food', const Color(0xFFFF6B6B)),
                const SizedBox(width: 12),
                _fabOption(
                    Icons.flight_rounded, 'Travel', const Color(0xFF4ECDC4)),
                const SizedBox(width: 12),
                _fabOption(Icons.shopping_bag_rounded, 'Shopping',
                    const Color(0xFFD4AF37)),
                const SizedBox(width: 12),
                _fabOption(
                    Icons.more_horiz_rounded, 'More', AppTheme.textSecondary),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

Widget _fabOption(IconData icon, String label, Color color) => Container(
      constraints: const BoxConstraints(minWidth: 70, maxWidth: 90),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
