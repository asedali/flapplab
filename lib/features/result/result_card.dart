import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/models/material_result.dart';
import '../../scan/scan_provider.dart';

/// Rich result card displayed in chat after scan completion
/// Shows material info, parameters, AI insight, and action buttons
class MaterialResultCard extends ConsumerWidget {
  final MaterialResult result;
  final bool isInChat;

  const MaterialResultCard({
    super.key,
    required this.result,
    this.isInChat = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: isInChat ? 0 : 16),
      child: Card(
        color: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with material name and confidence
              _buildHeader(context),

              const Divider(height: 1, color: AppTheme.surfaceLight),

              // Parameter bars
              _buildParameters(),

              const Divider(height: 1, color: AppTheme.surfaceLight),

              // Nutrition summary
              _buildNutritionSummary(),

              const Divider(height: 1, color: AppTheme.surfaceLight),

              // AI Insight bubble
              _buildAIInsight(),

              const Divider(height: 1, color: AppTheme.surfaceLight),

              // Action buttons
              _buildActions(context, ref),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Material icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.eco,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // Name and confidence
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getConfidenceColor(result.confidence)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getConfidenceColor(result.confidence),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${AppFormatters.percent(result.confidence)} Confidence',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getConfidenceColor(result.confidence),
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
        ],
      ),
    );
  }

  Widget _buildParameters() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analysis Parameters',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...result.parameters.entries.map((entry) => _buildParameterBar(
                entry.key,
                entry.value,
              )),
        ],
      ),
    );
  }

  Widget _buildParameterBar(String name, double value) {
    final color = _getParameterColor(value);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppFormatters.formatParameterName(name),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                AppFormatters.percent(value),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppTheme.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem('Calories', '${result.calories}', AppTheme.accentPink),
          _buildNutritionItem('Protein', '${result.protein}g', AppTheme.successColor),
          _buildNutritionItem('Carbs', '${result.carbs}g', AppTheme.warningColor),
          _buildNutritionItem('Fat', '${result.fat}g', AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsight() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 18,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                result.aiInsight,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                AppHaptics.light();
                // TODO: Implement save to history
              },
              icon: const Icon(Icons.save_alt, size: 18),
              label: const Text('Save'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(color: AppTheme.surfaceLight),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                AppHaptics.light();
                // TODO: Implement share
              },
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.textPrimary,
                side: const BorderSide(color: AppTheme.surfaceLight),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                AppHaptics.light();
                context.push('/health-sync');
              },
              icon: const Icon(Icons.favorite_outline, size: 18),
              label: const Text('Sync'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return AppTheme.successColor;
    if (confidence >= 0.7) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  Color _getParameterColor(double value) {
    if (value >= 0.8) return AppTheme.successColor;
    if (value >= 0.6) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
