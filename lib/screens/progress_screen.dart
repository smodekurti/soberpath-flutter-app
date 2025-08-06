import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
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
              _buildSectionHeader('Analytics', Icons.analytics),
              _buildStatistics(provider),
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
    return Card(
      elevation: context.borders.small.toDouble(),
      color: milestone.achieved ? context.colors.successLight : context.colors.surfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.borders.medium)),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.small),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              milestone.achieved ? Icons.check_circle : Icons.flag,
              color: milestone.achieved ? context.colors.success : context.colors.onSurfaceVariant,
              size: context.spacing.large,
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
    );
  }

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
}