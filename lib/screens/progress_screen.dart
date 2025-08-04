import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../models/sobriety_models.dart';
import '../utils/responsive_helpers.dart';

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
                        padding: const EdgeInsets.all(AppConstants.paddingLarge),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SafeText(
                              'Progress',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTitle,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            SafeText(
                              'Track your milestones',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeLarge,
                                color: Colors.white.withValues(alpha: .9),
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
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Milestones Section
                    _buildMilestonesSection(provider),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
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
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.lightYellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: AppConstants.warningYellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: SafeText(
                    'Milestones & Achievements',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Display milestones if available, otherwise show placeholder
            if (provider.milestones.isNotEmpty)
              ...provider.milestones.map((milestone) => Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildMilestoneItem(milestone, provider),
              )).toList()
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
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: milestone.achieved 
            ? AppConstants.lightGreen 
            : AppConstants.backgroundGray,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: milestone.achieved 
              ? AppConstants.successGreen 
              : AppConstants.borderGray,
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
                      ? AppConstants.successGreen 
                      : AppConstants.borderGray,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  milestone.achieved ? Icons.check : Icons.flag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      '${milestone.days} Day${milestone.days != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                        color: milestone.achieved 
                            ? AppConstants.successGreen 
                            : AppConstants.textDark,
                      ),
                      maxLines: 1,
                    ),
                    if (milestone.achieved && milestone.achievedDate != null)
                      SafeText(
                        'Achieved on ${milestone.achievedDate!.day}/${milestone.achievedDate!.month}/${milestone.achievedDate!.year}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.successGreen,
                        ),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              if (milestone.achieved)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.successGreen,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: const SafeText(
                    'Achieved!',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          SafeText(
            milestone.benefit,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: milestone.achieved 
                  ? AppConstants.successGreen 
                  : AppConstants.textGray,
              height: 1.4,
            ),
            maxLines: 3,
          ),
          
          if (!milestone.achieved && stats != null) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeText(
                  'Progress',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                  maxLines: 1,
                ),
                SafeText(
                  '${stats.days} / ${milestone.days} days',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textGray,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingSmall),
            
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppConstants.borderGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryPurple),
              minHeight: 6,
            ),
            
            const SizedBox(height: AppConstants.paddingSmall),
            
            SafeText(
              '$daysUntil days to go',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.primaryPurple,
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
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppConstants.backgroundGray,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppConstants.borderGray),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: AppConstants.textGray,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          SafeText(
            'No milestones available',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.w600,
              color: AppConstants.textGray,
            ),
            maxLines: 1,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          SafeText(
            'Set your sobriety date to track milestones',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textGray,
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
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.lightPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppConstants.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: SafeText(
                    'Progress Analytics',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
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
                      _buildStatRow('Progress Score', '${((stats['milestonesAchieved'] ?? 0) * 10 + (stats['totalCheckIns'] ?? 0)).toString()}'),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryPurple),
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
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SafeText(
              label,
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textGray,
              ),
              maxLines: 2,
            ),
          ),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            flex: 1,
            child: SafeText(
              value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryPurple,
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