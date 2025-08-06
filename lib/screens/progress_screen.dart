import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../models/sobriety_models.dart';
import '../widgets/safe_text.dart';
import '../utils/responsive_helpers.dart' show ResponsiveHelpers;

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
      backgroundColor: context.colors.surface,
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          final achievedMilestones = provider.milestones.where((m) => m.achieved).length;

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
                                  'Your Progress',
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
                                    '$achievedMilestones Milestones Achieved',
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
                                    'Track your journey and celebrate achievements',
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
              _buildSectionHeader('Achievements', Icons.emoji_events),
              _buildMilestoneGrid(provider),
              // Simple Analytics Section
              _buildSimpleAnalytics(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.spacing.large, context.spacing.large, context.spacing.large, context.spacing.medium),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary, size: 24),
            SizedBox(width: context.spacing.medium),
            Expanded(
              child: SafeText(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneGrid(AppStateProvider provider) {
    final milestones = provider.milestones;
    if (milestones.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Center(
            child: SafeText(
              'No milestones to show yet.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 16),
                color: context.colors.onSurfaceVariant,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(context.spacing.large),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return _buildMilestoneCard(milestones[index]);
          },
          childCount: milestones.length,
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    return GestureDetector(
      onTap: () {
        // Add haptic feedback for milestone interaction
        if (milestone.achieved) {
          HapticFeedback.lightImpact();
          _showMilestoneDetails(milestone);
        } else {
          HapticFeedback.selectionClick();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: milestone.achieved ? 8.0 : context.borders.small.toDouble(),
          color: milestone.achieved ? context.colors.successLight : context.colors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.borders.medium),
            side: milestone.achieved 
                ? BorderSide(color: context.colors.success.withValues(alpha: 0.3), width: 2)
                : BorderSide.none,
          ),
          child: Padding(
            padding: EdgeInsets.all(context.spacing.small),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    milestone.achieved ? Icons.check_circle : Icons.flag,
                    key: ValueKey(milestone.achieved),
                    color: milestone.achieved ? context.colors.success : context.colors.onSurfaceVariant,
                    size: context.spacing.large,
                  ),
                ),
                SizedBox(height: context.spacing.small),
                AutoSizeText(
                  '${milestone.days} Days',
                  style: TextStyle(
                    fontSize: context.typography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: milestone.achieved ? context.colors.success : context.colors.onSurface,
                  ),
                  maxLines: 1,
                  minFontSize: context.typography.bodySmall,
                  maxFontSize: context.typography.titleLarge,
                ),
                SizedBox(height: context.spacing.small),
                Flexible(
                  child: SafeText(
                    milestone.benefit,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: milestone.achieved ? context.colors.success : context.colors.onSurfaceVariant,
                      fontSize: context.typography.bodySmall,
                      height: 1.2,
                    ),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMilestoneDetails(Milestone milestone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borders.large),
        ),
        title: Row(
          children: [
            Icon(
              Icons.celebration,
              color: context.colors.success,
              size: context.spacing.large,
            ),
            SizedBox(width: context.spacing.medium),
            SafeText(
              'Milestone Achieved!',
              style: TextStyle(
                fontSize: context.typography.titleLarge,
                fontWeight: FontWeight.bold,
                color: context.colors.success,
              ),
              maxLines: 1,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeText(
              '${milestone.days} Days Sober',
              style: TextStyle(
                fontSize: context.typography.headlineSmall,
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
              maxLines: 1,
            ),
            SizedBox(height: context.spacing.medium),
            SafeText(
              milestone.benefit,
              style: TextStyle(
                fontSize: context.typography.bodyLarge,
                color: context.colors.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 5,
            ),
            SizedBox(height: context.spacing.large),
            SafeText(
              'Congratulations on reaching this important milestone in your recovery journey!',
              style: TextStyle(
                fontSize: context.typography.bodyMedium,
                color: context.colors.success,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
            child: SafeText(
              'Close',
              style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleAnalytics(AppStateProvider provider) {
    final checkIns = provider.dailyCheckIns;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(context.spacing.medium),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(context.borders.large),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(context.spacing.large),
              child: Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: context.colors.primary,
                    size: context.spacing.large,
                  ),
                  SizedBox(width: context.spacing.medium),
                  SafeText(
                    'Analytics',
                    style: TextStyle(
                      fontSize: context.typography.titleLarge,
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            
            // Stats Grid
            if (checkIns.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.spacing.large),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: context.spacing.medium,
                  mainAxisSpacing: context.spacing.medium,
                  childAspectRatio: 1.8,
                  children: [
                    _buildStatCard(
                      'Total Check-ins',
                      checkIns.length.toString(),
                      Icons.check_circle,
                      context.colors.primary,
                    ),
                    _buildStatCard(
                      'Avg Mood',
                      _calculateAverageMood(checkIns).toStringAsFixed(1),
                      Icons.mood,
                      context.colors.secondary,
                    ),
                    _buildStatCard(
                      'Avg Cravings',
                      _calculateAverageCravings(checkIns).toStringAsFixed(1),
                      Icons.trending_down,
                      context.colors.error,
                    ),
                    _buildStatCard(
                      'Recent Streak',
                      '${_calculateStreak(checkIns)} days',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: EdgeInsets.all(context.spacing.large),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 48,
                        color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      SizedBox(height: context.spacing.medium),
                      SafeText(
                        'No data available yet',
                        style: TextStyle(
                          fontSize: context.typography.bodyMedium,
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(height: context.spacing.small),
                      SafeText(
                        'Start tracking your mood and cravings to see analytics',
                        style: TextStyle(
                          fontSize: context.typography.bodySmall,
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: context.spacing.medium),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(context.spacing.small),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.borders.medium),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: context.spacing.medium,
          ),
          SizedBox(height: context.spacing.small / 2),
          Flexible(
            child: AutoSizeText(
              value,
              style: TextStyle(
                fontSize: context.typography.titleMedium,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              minFontSize: context.typography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: context.spacing.small / 4),
          Flexible(
            child: SafeText(
              title,
              style: TextStyle(
                fontSize: context.typography.bodySmall,
                color: context.colors.onSurfaceVariant,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAverageMood(List<DailyCheckIn> checkIns) {
    if (checkIns.isEmpty) return 0.0;
    final sum = checkIns.map((e) => e.mood).reduce((a, b) => a + b);
    return sum / checkIns.length;
  }

  double _calculateAverageCravings(List<DailyCheckIn> checkIns) {
    if (checkIns.isEmpty) return 0.0;
    final sum = checkIns.map((e) => e.cravingLevel).reduce((a, b) => a + b);
    return sum / checkIns.length;
  }

  int _calculateStreak(List<DailyCheckIn> checkIns) {
    if (checkIns.isEmpty) return 0;
    
    // Sort by date descending
    final sortedCheckIns = checkIns.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (final checkIn in sortedCheckIns) {
      final daysDifference = currentDate.difference(checkIn.date).inDays;
      if (daysDifference <= streak + 1) {
        streak++;
        currentDate = checkIn.date;
      } else {
        break;
      }
    }
    
    return streak;
  }

  // Remove unused _buildStatistics method since we now use simple analytics
  /*
  Widget _buildStatistics(AppStateProvider provider) {
    final checkIns = provider.dailyCheckIns;
    if (checkIns.length < 2) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Center(
            child: SafeText(
              'Not enough data for charts yet.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 16),
                color: context.colors.onSurfaceVariant,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        _buildChartCard('Mood Over Time', _buildLineChart(checkIns, (c) => c.mood, context.colors.success)),
        _buildChartCard('Cravings Over Time', _buildLineChart(checkIns, (c) => c.cravingLevel, context.colors.warning)),
      ]),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing.large, vertical: context.spacing.small),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.borders.medium)),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeText(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelpers.getResponsiveFontSize(context, 18),
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
                maxLines: 2,
              ),
              SizedBox(height: context.spacing.large),
              SizedBox(height: 200, child: chart),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<DailyCheckIn> checkIns, int Function(DailyCheckIn) getValue, Color color) {
    final spots = checkIns.asMap().entries.map((e) => FlSpot(e.key.toDouble(), getValue(e.value).toDouble())).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: color.withValues(alpha: 0.3)),
          ),
        ],
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: 0,
        maxY: 10,
      ),
    );
  }
  */
}