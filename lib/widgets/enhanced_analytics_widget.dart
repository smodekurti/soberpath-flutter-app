import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../widgets/safe_text.dart';
import '../models/sobriety_models.dart';

class EnhancedAnalyticsWidget extends StatefulWidget {
  const EnhancedAnalyticsWidget({super.key});

  @override
  State<EnhancedAnalyticsWidget> createState() => _EnhancedAnalyticsWidgetState();
}

class _EnhancedAnalyticsWidgetState extends State<EnhancedAnalyticsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTimeRange = 0; // 0: Week, 1: Month, 2: 3 Months

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.all(context.spacing.medium),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(context.borders.large),
            boxShadow: [
              BoxShadow(
                color: context.colors.shadow.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with time range selector
              _buildHeader(context),
              
              // Tab bar for different chart types
              _buildTabBar(context),
              
              // Chart content
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMoodChart(context, provider),
                    _buildCravingChart(context, provider),
                    _buildProgressOverview(context, provider),
                  ],
                ),
              ),
              
              SizedBox(height: context.spacing.medium),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spacing.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          _buildTimeRangeSelector(context),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context) {
    final options = ['7D', '30D', '90D'];
    
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.borders.medium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = _selectedTimeRange == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeRange = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing.medium,
                vertical: context.spacing.small,
              ),
              decoration: BoxDecoration(
                color: isSelected 
                    ? context.colors.primary 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(context.borders.medium),
              ),
              child: SafeText(
                option,
                style: TextStyle(
                  fontSize: context.typography.bodySmall,
                  fontWeight: FontWeight.w600,
                  color: isSelected 
                      ? context.colors.onPrimary
                      : context.colors.onSurfaceVariant,
                ),
                maxLines: 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing.large),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(context.borders.medium),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(context.borders.medium),
        ),
        labelColor: context.colors.onPrimary,
        unselectedLabelColor: context.colors.onSurfaceVariant,
        labelStyle: TextStyle(
          fontSize: context.typography.bodyMedium,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: context.typography.bodyMedium,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Mood'),
          Tab(text: 'Cravings'),
          Tab(text: 'Overview'),
        ],
      ),
    );
  }

  Widget _buildMoodChart(BuildContext context, AppStateProvider provider) {
    final data = _getMoodChartData(provider);
    
    if (data.isEmpty) {
      return _buildEmptyState(context, 'No mood data available');
    }

    return Padding(
      padding: EdgeInsets.all(context.spacing.large),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.colors.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return SafeText(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: context.typography.bodySmall,
                      color: context.colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return SafeText(
                      DateFormat('M/d').format(data[index].date),
                      style: TextStyle(
                        fontSize: context.typography.bodySmall,
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.mood.toDouble());
              }).toList(),
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  context.colors.primary,
                  context.colors.secondary,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: context.colors.primary,
                    strokeWidth: 2,
                    strokeColor: context.colors.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    context.colors.primary.withValues(alpha: 0.3),
                    context.colors.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCravingChart(BuildContext context, AppStateProvider provider) {
    final data = _getCravingChartData(provider);
    
    if (data.isEmpty) {
      return _buildEmptyState(context, 'No craving data available');
    }

    return Padding(
      padding: EdgeInsets.all(context.spacing.large),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: context.colors.outline.withValues(alpha: 0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return SafeText(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: context.typography.bodySmall,
                      color: context.colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return SafeText(
                      DateFormat('M/d').format(data[index].date),
                      style: TextStyle(
                        fontSize: context.typography.bodySmall,
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                    );
                  }
                  return const SizedBox.shrink();
                },
                reservedSize: 30,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.cravingLevel.toDouble());
              }).toList(),
              isCurved: true,
              color: context.colors.error,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: context.colors.error,
                    strokeWidth: 2,
                    strokeColor: context.colors.surface,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    context.colors.error.withValues(alpha: 0.3),
                    context.colors.error.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context, AppStateProvider provider) {
    final stats = _getProgressStats(provider);
    
    return Padding(
      padding: EdgeInsets.all(context.spacing.large),
      child: Column(
        children: [
          // Stats grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: context.spacing.medium,
              mainAxisSpacing: context.spacing.medium,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  context,
                  'Avg Mood',
                  stats['avgMood']?.toStringAsFixed(1) ?? '0.0',
                  Icons.mood,
                  context.colors.primary,
                ),
                _buildStatCard(
                  context,
                  'Avg Cravings',
                  stats['avgCravings']?.toStringAsFixed(1) ?? '0.0',
                  Icons.trending_down,
                  context.colors.error,
                ),
                _buildStatCard(
                  context,
                  'Check-ins',
                  stats['totalCheckIns']?.toString() ?? '0',
                  Icons.check_circle,
                  context.colors.secondary,
                ),
                _buildStatCard(
                  context,
                  'Streak',
                  '${stats['currentStreak'] ?? 0} days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(context.spacing.medium),
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
        children: [
          Icon(
            icon,
            color: color,
            size: context.spacing.large,
          ),
          SizedBox(height: context.spacing.small),
          SafeText(
            value,
            style: TextStyle(
              fontSize: context.typography.titleLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
          ),
          SizedBox(height: context.spacing.small / 2),
          SafeText(
            title,
            style: TextStyle(
              fontSize: context.typography.bodySmall,
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: context.spacing.medium),
          SafeText(
            message,
            style: TextStyle(
              fontSize: context.typography.bodyMedium,
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  List<DailyCheckIn> _getMoodChartData(AppStateProvider provider) {
    final now = DateTime.now();
    final days = _selectedTimeRange == 0 ? 7 : (_selectedTimeRange == 1 ? 30 : 90);
    final startDate = now.subtract(Duration(days: days));
    
    return provider.dailyCheckIns
        .where((checkIn) => checkIn.date.isAfter(startDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<DailyCheckIn> _getCravingChartData(AppStateProvider provider) {
    return _getMoodChartData(provider); // Same data source, different visualization
  }

  Map<String, double> _getProgressStats(AppStateProvider provider) {
    final data = _getMoodChartData(provider);
    
    if (data.isEmpty) {
      return {
        'avgMood': 0.0,
        'avgCravings': 0.0,
        'totalCheckIns': 0.0,
        'currentStreak': 0.0,
      };
    }

    final avgMood = data.map((e) => e.mood).reduce((a, b) => a + b) / data.length;
    final avgCravings = data.map((e) => e.cravingLevel).reduce((a, b) => a + b) / data.length;
    
    // Calculate current streak
    int streak = 0;
    final sortedData = data.reversed.toList();
    for (final checkIn in sortedData) {
      if (checkIn.date.difference(DateTime.now()).inDays.abs() <= streak + 1) {
        streak++;
      } else {
        break;
      }
    }

    return {
      'avgMood': avgMood,
      'avgCravings': avgCravings,
      'totalCheckIns': data.length.toDouble(),
      'currentStreak': streak.toDouble(),
    };
  }
}
