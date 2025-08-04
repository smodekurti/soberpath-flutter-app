import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
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
      backgroundColor: AppConstants.backgroundGray,
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppConstants.purpleGradient,
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Journal',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTitle,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              'Your daily reflections',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeLarge,
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
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                sliver: provider.dailyCheckIns.isEmpty
                    ? SliverToBoxAdapter(child: _buildEmptyState(provider))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final checkIn = provider.dailyCheckIns[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppConstants.paddingMedium,
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
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.lightPurple,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.book_outlined,
                size: 40,
                color: AppConstants.primaryPurple,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            const Text(
              'No journal entries yet',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            const Text(
              'Start your daily check-ins to build your journal history. Your reflections will appear here.',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textGray,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
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
                    const SnackBar(
                      content: Text(
                          'You have already completed your check-in for today.'),
                      backgroundColor: AppConstants.warningYellow,
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
              context, AppConstants.paddingLarge),
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
                          context, AppConstants.fontSizeXLarge),
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ),
                SizedBox(
                    width: ResponsiveHelpers.getResponsivePadding(
                        context, AppConstants.paddingSmall)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelpers.getResponsivePadding(
                        context, AppConstants.paddingMedium),
                    vertical: ResponsiveHelpers.getResponsivePadding(
                        context, AppConstants.paddingSmall),
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.lightPurple,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Text(
                    DateFormat('MMM d').format(checkIn.date),
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, AppConstants.fontSizeSmall),
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryPurple,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

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
                        context, AppConstants.paddingLarge)),
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
                      context, AppConstants.paddingLarge)),

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
                          context, AppConstants.paddingLarge),
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundGray,
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.format_quote,
                              color: AppConstants.primaryPurple,
                              size: 20,
                            ),
                            SizedBox(
                                width: ResponsiveHelpers.getResponsivePadding(
                                    context, AppConstants.paddingSmall)),
                            Text(
                              'Daily Reflection',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveHelpers.getResponsiveFontSize(
                                        context, AppConstants.fontSizeMedium),
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryPurple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveHelpers.getResponsivePadding(
                                context, AppConstants.paddingMedium)),
                        Text(
                          checkIn.reflection,
                          style: TextStyle(
                            fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                context, AppConstants.fontSizeLarge),
                            color: AppConstants.textDark,
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
                      context, AppConstants.paddingLarge)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  ResponsiveHelpers.getResponsivePadding(
                      context, AppConstants.paddingLarge),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundGray,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Text(
                  'No reflection recorded for this day.',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeMedium),
                    color: AppConstants.textGray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            // Entry timestamp
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),

            Text(
              'Recorded at ${DateFormat('h:mm a').format(checkIn.createdAt)}',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeSmall),
                color: AppConstants.textGray,
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
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            '$value/10',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
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
    if (mood <= 3) return AppConstants.dangerRed;
    if (mood <= 6) return AppConstants.warningYellow;
    return AppConstants.successGreen;
  }

  IconData _getCravingIcon(int craving) {
    if (craving <= 3) return Icons.mood;
    if (craving <= 6) return Icons.warning_amber;
    return Icons.crisis_alert;
  }

  Color _getCravingColor(int craving) {
    if (craving <= 3) return AppConstants.successGreen;
    if (craving <= 6) return AppConstants.warningYellow;
    return AppConstants.dangerRed;
  }
}
