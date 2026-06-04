import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart' as AppTheme;
import '../models/category_model.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.index,
    super.key,
  });

  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _selectController;
  late AnimationController _entryController;
  late AnimationController _progressController;

  late Animation<double> _scaleAnim;
  late Animation<double> _entryAnim;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _selectController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    _entryController = AnimationController(
      duration: AppConstants.animationMedium,
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _selectController, curve: Curves.easeOutBack),
    );
    _entryAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
    );
    _progressAnim = Tween<double>(begin: 0, end: widget.category.spendRatio)
        .animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    Future.delayed(
      Duration(milliseconds: widget.index * 80 + 200),
      () {
        if (mounted) {
          _entryController.forward();
          _progressController.forward();
        }
      },
    );
  }

  @override
  void didUpdateWidget(CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _selectController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _selectController.reverse();
    }
  }

  @override
  void dispose() {
    _selectController.dispose();
    _entryController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: Listenable.merge(
          [_entryController, _selectController, _progressController]),
      builder: (context, _) => Opacity(
          opacity: _entryAnim.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _entryAnim.value)),
            child: ScaleTransition(
              scale: _scaleAnim,
              child: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 115,
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? widget.category.color.withValues(alpha: 0.12)
                        : AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    border: Border.all(
                      color: widget.isSelected
                          ? widget.category.color.withValues(alpha: 0.6)
                          : AppTheme.borderColor,
                      width: widget.isSelected ? 1.5 : 1,
                    ),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: widget.category.color.withValues(alpha: 0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.category.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.category.icon,
                          color: widget.category.color,
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Name
                      Text(
                        widget.category.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Amount
                      Text(
                        _formatAmount(widget.category.amountSpent),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: widget.category.color,
                          fontFamily: 'DMSerifDisplay',
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Mini progress bar
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _progressAnim.value,
                              minHeight: 3,
                              backgroundColor:
                                  AppTheme.surfaceHighlight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.category.color),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(widget.category.spendRatio * 100).toStringAsFixed(0)}% of budget',
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppTheme.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
}