import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart' as AppTheme;

class SpendHeaderCard extends StatefulWidget {
  const SpendHeaderCard({
    required this.totalSpend,
    required this.growthPercentage,
    required this.budget,
    super.key,
  });

  final double totalSpend;
  final double growthPercentage;
  final double budget;

  @override
  State<SpendHeaderCard> createState() => _SpendHeaderCardState();
}

class _SpendHeaderCardState extends State<SpendHeaderCard>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _numberController;

  late Animation<double> _slideUp;
  late Animation<double> _fadeIn;
  late Animation<double> _shimmer;
  late Animation<double> _countUp;
  late Animation<double> _arcProgress;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _numberController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );
    _shimmer = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _countUp = Tween<double>(begin: 0, end: widget.totalSpend).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.easeOutExpo),
    );
    _arcProgress = Tween<double>(
      begin: 0,
      end: (widget.totalSpend / widget.budget).clamp(0, 1),
    ).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      _entryController.forward();
      _numberController.forward();
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _shimmerController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge(
            [_entryController, _shimmerController, _numberController]),
        builder: (context, _) => Opacity(
          opacity: _fadeIn.value,
          child: Transform.translate(
            offset: Offset(0, _slideUp.value),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.paddingLarge,
                0,
                AppConstants.paddingLarge,
                0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Subtle golden shimmer
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment(_shimmer.value - 1, -0.5),
                            end: Alignment(_shimmer.value + 1, 0.5),
                            colors: [
                              Colors.transparent,
                              AppTheme.primaryColor.withValues(alpha: 0.04),
                              Colors.transparent,
                            ],
                          ).createShader(bounds),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: label + period badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL SPENT',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryColor,
                                  letterSpacing: 2,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceHighlight,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'May 2025',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Main amount row + arc indicator
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Animated number
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: '₹',
                                            style: TextStyle(
                                              fontFamily: 'DMSerifDisplay',
                                              fontSize: 24,
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: _formatLargeNumber(
                                                _countUp.value),
                                            style: const TextStyle(
                                              fontFamily: 'DMSerifDisplay',
                                              fontSize: 42,
                                              color: AppTheme.textPrimary,
                                              fontWeight: FontWeight.w400,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Growth pill
                                    Column(
                                      children: [
                                        _buildGrowthPill(),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'vs ₹${_formatLargeNumber(87380)} last month',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textTertiary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Arc progress indicator
                              _buildArcIndicator(),
                            ],
                          ),

                          const SizedBox(height: AppConstants.paddingLarge),

                          // Budget progress bar
                          _buildBudgetBar(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildGrowthPill() => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.accentGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                size: 12,
                color: AppTheme.accentGreen,
              ),
              Text(
                '+${widget.growthPercentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildArcIndicator() {
    final ratio = _arcProgress.value;
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(80, 80),
            painter: _ArcPainter(progress: ratio),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Text(
                'of budget',
                style: TextStyle(
                  fontSize: 9,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBar() {
    (widget.totalSpend / widget.budget).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget: ₹${_formatLargeNumber(widget.budget)}',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '₹${_formatLargeNumber(widget.budget - widget.totalSpend)} left',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.accentGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.surfaceHighlight,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: _arcProgress.value,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentGreen,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatLargeNumber(double value) {
    if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    const strokeWidth = 5.0;

    // Track
    final trackPaint = Paint()
      ..color = AppTheme.surfaceHighlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.primaryColor, AppTheme.accentGreen],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}
