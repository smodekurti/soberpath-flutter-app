import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../models/sobriety_models.dart';
import '../widgets/safe_text.dart';
import '../utils/responsive_helpers.dart' show ResponsiveHelpers;

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<AppStateProvider>(context, listen: false);
    await provider.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          final checkIns = provider.dailyCheckIns;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: context.spacing.large * 6,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: context.colors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.spacing.medium,
                          context.spacing.small,
                          context.spacing.medium,
                          context.spacing.small,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title row
                            SizedBox(
                              height: context.spacing.large * 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SafeText(
                                  'Journal',
                                  style: TextStyle(
                                    fontSize: context.typography.titleLarge,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            // Bottom content
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoSizeText(
                                    '${checkIns.length} Entries',
                                    style: TextStyle(
                                      fontSize: context.typography.headlineSmall,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    minFontSize: context.typography.titleMedium,
                                    maxFontSize: context.typography.headlineMedium,
                                  ),
                                  SizedBox(height: context.spacing.small),
                                  SafeText(
                                    'Your timeline of reflections and progress',
                                    style: TextStyle(
                                      fontSize: context.typography.bodyMedium,
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (checkIns.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyState(context, provider))
              else
                _buildTimeline(checkIns),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimeline(List<DailyCheckIn> checkIns) {
    return SliverPadding(
      padding: EdgeInsets.all(context.spacing.large),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final checkIn = checkIns[index];
            return Padding(
              padding: EdgeInsets.only(bottom: context.spacing.large),
              child: Center(
                child: _buildJournalEntry(checkIn),
              ),
            );
          },
          childCount: checkIns.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppStateProvider provider) {
    return Container(
      padding: EdgeInsets.all(context.spacing.extraLarge),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, size: 80, color: context.colors.primaryLight),
            SizedBox(height: context.spacing.large),
            AutoSizeText(
              'Start Your Journey',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
              maxLines: 2,
              minFontSize: 18,
              maxFontSize: 28,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.medium),
            SafeText(
              'Begin your daily check-ins to track your progress and reflect on your journey.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 16),
                color: context.colors.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            SizedBox(height: context.spacing.large),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/checkIn'),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Start First Check-in'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalEntry(DailyCheckIn checkIn) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borders.medium),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeText(
                DateFormat('EEEE, MMMM d, y').format(checkIn.date),
                style: TextStyle(
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
                maxLines: 2,
              ),
              SizedBox(height: context.spacing.medium),
              Row(
                children: [
                  Expanded(child: _buildMoodIndicator('Mood', checkIn.mood, _getMoodIcon(checkIn.mood), _getMoodColor(checkIn.mood))),
                  SizedBox(width: context.spacing.medium),
                  Expanded(child: _buildMoodIndicator('Cravings', checkIn.cravingLevel, _getCravingIcon(checkIn.cravingLevel), _getCravingColor(checkIn.cravingLevel))),
                ],
              ),
              if (checkIn.reflection.isNotEmpty) ...[
                SizedBox(height: context.spacing.large),
                _buildReflection(checkIn.reflection),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReflection(String reflection) {
    return Container(
      padding: EdgeInsets.all(context.spacing.medium),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.borders.small),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeText(
            'Daily Reflection',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
              fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 16),
            ),
            maxLines: 1,
          ),
          SizedBox(height: context.spacing.small),
          SafeText(
            reflection,
            style: TextStyle(
              color: context.colors.onSurfaceVariant,
              fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 14),
              height: 1.4,
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodIndicator(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: context.spacing.small),
        SafeText(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.colors.onSurfaceVariant,
            fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 14),
          ),
          maxLines: 1,
        ),
        SafeText(
          '$value/10',
          style: TextStyle(
            fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 16),
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  IconData _getMoodIcon(int mood) {
    if (mood <= 3) return Icons.sentiment_very_dissatisfied;
    if (mood <= 7) return Icons.sentiment_neutral;
    return Icons.sentiment_very_satisfied;
  }

  Color _getMoodColor(int mood) {
    if (mood <= 3) return context.colors.error;
    if (mood <= 7) return context.colors.warning;
    return context.colors.success;
  }

  IconData _getCravingIcon(int craving) {
    if (craving <= 3) return Icons.smoke_free;
    if (craving <= 7) return Icons.smoking_rooms;
    return Icons.whatshot;
  }

  Color _getCravingColor(int craving) {
    if (craving <= 3) return context.colors.success;
    if (craving <= 7) return context.colors.warning;
    return context.colors.error;
  }
}
