import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../models/sobriety_models.dart';

import '../widgets/safe_text.dart';

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
          return CustomScrollView(
            slivers: [
              // Collapsible header
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                pinned: true,
                backgroundColor: context.colors.primary,
                title: const Text('Progress'),
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
                            SafeText(
                              'Track your milestones',
                              style: TextStyle(
                                fontSize: context.typography.titleLarge,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
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
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Milestones Section
                    _buildMilestonesSection(provider),
                    
                    SizedBox(height: context.spacing.large),
                    
                    // Statistics Card
                    _buildStatisticsCard(provider),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMilestonesSection(AppStateProvider provider) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(context.borders.small),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    color: context.colors.secondary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Milestones & Achievements',
                    style: TextStyle(
                      fontSize: context.typography.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            // Display milestones if available, otherwise show placeholder
            if (provider.milestones.isNotEmpty)
              ...provider.milestones.map((milestone) => Padding(
                padding: EdgeInsets.only(bottom: context.spacing.medium),
                child: _buildMilestoneItem(milestone, provider),
              ))
            else
              _buildMilestonePlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneItem(Milestone milestone, AppStateProvider provider) {
    final stats = provider.sobrietyStats;
    final progress = stats != null ? provider.getMilestoneProgress(milestone.days) : 0.0;
    final daysUntil = stats != null ? provider.getDaysUntilMilestone(milestone.days) : milestone.days;

    return Container(
      padding: EdgeInsets.all(context.spacing.large),
      decoration: BoxDecoration(
        color: milestone.achieved 
            ? context.colors.successLight 
            : context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.borders.medium),
        border: Border.all(
          color: milestone.achieved 
              ? context.colors.success 
              : context.colors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: milestone.achieved 
                      ? context.colors.success 
                      : context.colors.outline,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  milestone.achieved ? Icons.check : Icons.flag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: context.spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      '${milestone.days} Day${milestone.days != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: context.typography.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: milestone.achieved 
                            ? context.colors.success 
                            : context.colors.onSurface,
                      ),
                      maxLines: 1,
                    ),
                    if (milestone.achieved && milestone.achievedDate != null)
                      SafeText(
                        'Achieved on ${milestone.achievedDate!.day}/${milestone.achievedDate!.month}/${milestone.achievedDate!.year}',
                        style: TextStyle(
                          fontSize: context.typography.bodySmall,
                          color: context.colors.success,
                        ),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              if (milestone.achieved)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.medium,
                    vertical: context.spacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.success,
                    borderRadius: BorderRadius.circular(context.borders.medium),
                  ),
                  child: SafeText(
                    'Achieved!',
                    style: TextStyle(
                      fontSize: context.typography.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
          
          SizedBox(height: context.spacing.medium),
          
          SafeText(
            milestone.benefit,
            style: TextStyle(
              fontSize: context.typography.bodyMedium,
              color: milestone.achieved 
                  ? context.colors.success 
                  : context.colors.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 3,
          ),
          
          if (!milestone.achieved && stats != null) ...[
            SizedBox(height: context.spacing.medium),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeText(
                  'Progress',
                  style: TextStyle(
                    fontSize: context.typography.bodyMedium,
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                  maxLines: 1,
                ),
                SafeText(
                  '${stats.days} / ${milestone.days} days',
                  style: TextStyle(
                    fontSize: context.typography.bodyMedium,
                    color: context.colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.small),
            
            LinearProgressIndicator(
              value: progress,
              backgroundColor: context.colors.outline,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
              minHeight: 6,
            ),
            
            SizedBox(height: context.spacing.small),
            
            SafeText(
              '$daysUntil days to go',
              style: TextStyle(
                fontSize: context.typography.bodySmall,
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMilestonePlaceholder() {
    return Container(
      padding: EdgeInsets.all(context.spacing.large),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(context.borders.medium),
        border: Border.all(color: context.colors.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: context.colors.onSurfaceVariant,
          ),
          SizedBox(height: context.spacing.medium),
          SafeText(
            'No milestones available',
            style: TextStyle(
              fontSize: context.typography.titleMedium,
              fontWeight: FontWeight.w600,
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 1,
          ),
          SizedBox(height: context.spacing.small),
          SafeText(
            'Set your sobriety date to track milestones',
            style: TextStyle(
              fontSize: context.typography.bodyMedium,
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(AppStateProvider provider) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.primaryLight,
                    borderRadius: BorderRadius.circular(context.borders.small),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: SafeText(
                    'Progress Analytics',
                    style: TextStyle(
                      fontSize: context.typography.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            FutureBuilder<Map<String, dynamic>>(
              future: provider.getStatistics(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      _buildStatRow('Check-in Streak', '${stats['checkInStreak'] ?? 0} days'),
                      _buildStatRow('Best Mood Week', '${(stats['bestMoodWeek'] ?? 0.0).toStringAsFixed(1)}/10'),
                      _buildStatRow('Lowest Craving Day', '${(stats['lowestCravingDay'] ?? 0.0).toStringAsFixed(1)}/10'),
                      _buildStatRow('Progress Score', ((stats['milestonesAchieved'] ?? 0) * 10 + (stats['totalCheckIns'] ?? 0)).toString()),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.medium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SafeText(
              label,
              style: TextStyle(
                fontSize: context.typography.titleMedium,
                color: context.colors.onSurfaceVariant,
              ),
              maxLines: 2,
            ),
          ),
          SizedBox(width: context.spacing.small),
          Expanded(
            flex: 1,
            child: SafeText(
              value,
              style: TextStyle(
                fontSize: context.typography.titleMedium,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}