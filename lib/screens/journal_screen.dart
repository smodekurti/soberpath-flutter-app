import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../models/sobriety_models.dart';
import '../utils/responsive_helpers.dart'; // Import responsive helpers

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
          return CustomScrollView(
            slivers: [
              // Collapsible header
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                pinned: true,
                backgroundColor: context.colors.primary,
                title: const Text('Journal'),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: context.colors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(context.spacing.large),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Show only the subtitle - main title now comes from SliverAppBar.title
                            Text(
                              'Your daily reflections',
                              style: TextStyle(
                                fontSize: context.typography.titleLarge,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(context.spacing.large),
                sliver: provider.dailyCheckIns.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState(provider))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final checkIn = provider.dailyCheckIns[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: context.spacing.medium,
                              ),
                              child: _buildJournalEntry(checkIn),
                            );
                          },
                          childCount: provider.dailyCheckIns.length,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppStateProvider provider) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.extraLarge),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.primaryLight,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.book_outlined,
                size: 40,
                color: context.colors.primary,
              ),
            ),
            SizedBox(height: context.spacing.large),
            Text(
              'No journal entries yet',
              style: TextStyle(
                fontSize: context.typography.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: context.spacing.medium),
            Text(
              'Start your daily check-ins to build your journal history. Your reflections will appear here.',
              style: TextStyle(
                fontSize: context.typography.titleLarge,
                color: context.colors.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.large),
            ElevatedButton.icon(
              onPressed: () {
                // Check if a check-in already exists for today
                final now = DateTime.now();
                final todayCheckIn = provider.dailyCheckIns.any((checkIn) =>
                    checkIn.date.year == now.year &&
                    checkIn.date.month == now.month &&
                    checkIn.date.day == now.day);

                if (todayCheckIn) {
                  // Show a message if a check-in already exists
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'You have already completed your check-in for today.'),
                      backgroundColor: context.colors.warning,
                    ),
                  );
                  return; // Don't navigate
                }
                // Navigate back to home screen for check-in
                Navigator.pushNamed(context, '/checkIn');
              },
              icon: const Icon(Icons.add),
              label: const Text('Start Daily Check-in'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalEntry(DailyCheckIn checkIn) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelpers.getResponsivePadding(
              context, context.spacing.large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMMM d, y').format(checkIn.date),
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.headlineSmall),
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                SizedBox(
                    width: ResponsiveHelpers.getResponsivePadding(
                        context, context.spacing.small)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelpers.getResponsivePadding(
                        context, context.spacing.medium),
                    vertical: ResponsiveHelpers.getResponsivePadding(
                        context, context.spacing.small),
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(context.borders.medium),
                  ),
                  child: Text(
                    DateFormat('MMM d').format(checkIn.date),
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.bodySmall),
                      fontWeight: FontWeight.w600,
                      color: context.colors.primary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, context.spacing.large)),

            // Mood and Craving Indicators
            Row(
              children: [
                Expanded(
                  child: _buildMoodIndicator(
                    'Mood',
                    checkIn.mood,
                    _getMoodIcon(checkIn.mood),
                    _getMoodColor(checkIn.mood),
                  ),
                ),
                SizedBox(
                    width: ResponsiveHelpers.getResponsivePadding(
                        context, context.spacing.large)),
                Expanded(
                  child: _buildMoodIndicator(
                    'Cravings',
                    checkIn.cravingLevel,
                    _getCravingIcon(checkIn.cravingLevel),
                    _getCravingColor(checkIn.cravingLevel),
                  ),
                ),
              ],
            ),

            if (checkIn.reflection.isNotEmpty) ...[
              SizedBox(
                  height: ResponsiveHelpers.getResponsivePadding(
                      context, context.spacing.large)),

              // Reflection Content
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.3, // Limit height
                ),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      ResponsiveHelpers.getResponsivePadding(
                          context, context.spacing.large),
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(
                          context.borders.medium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: context.colors.primary,
                              size: 20,
                            ),
                            SizedBox(
                                width: ResponsiveHelpers.getResponsivePadding(
                                    context, context.spacing.small)),
                            Text(
                              'Daily Reflection',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelpers.getResponsiveFontSize(
                                        context, context.typography.bodyLarge),
                                fontWeight: FontWeight.w600,
                                color: context.colors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveHelpers.getResponsivePadding(
                                context, context.spacing.medium)),
                        Text(
                          checkIn.reflection,
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, context.typography.titleMedium),
                            color: context.colors.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                  height: ResponsiveHelpers.getResponsivePadding(
                      context, context.spacing.large)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  ResponsiveHelpers.getResponsivePadding(
                      context, context.spacing.large),
                ),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(context.borders.medium),
                ),
                child: Text(
                  'No reflection recorded for this day.',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, context.typography.bodyMedium),
                    color: context.colors.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            // Entry timestamp
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, context.spacing.medium)),

            Text(
              'Recorded at ${DateFormat('h:mm a').format(checkIn.createdAt)}',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, context.typography.bodySmall),
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIndicator(
      String label, int value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(context.spacing.medium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.borders.medium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: context.spacing.small),
          Text(
            label,
            style: TextStyle(
              fontSize: context.typography.bodyMedium,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            '$value/10',
            style: TextStyle(
              fontSize: context.typography.titleMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(int mood) {
    if (mood <= 3) return Icons.sentiment_very_dissatisfied;
    if (mood <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_very_satisfied;
  }

  Color _getMoodColor(int mood) {
    if (mood <= 3) return context.colors.error;
    if (mood <= 6) return context.colors.warning;
    return context.colors.success;
  }

  IconData _getCravingIcon(int craving) {
    if (craving <= 3) return Icons.mood;
    if (craving <= 6) return Icons.warning_amber;
    return Icons.crisis_alert;
  }

  Color _getCravingColor(int craving) {
    if (craving <= 3) return context.colors.success;
    if (craving <= 6) return context.colors.warning;
    return context.colors.error;
  }
}
