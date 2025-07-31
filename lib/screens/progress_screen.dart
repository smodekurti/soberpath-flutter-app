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
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTitle,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              'Track your milestones',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeLarge,
                                color: Colors.white.withValues(alpha: .9),
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
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Overall Progress Card
                    if (provider.hasSoberDate) ...[
                      _buildOverallProgressCard(provider),
                      const SizedBox(height: AppConstants.paddingLarge),
                    ],

                    // Milestones Section
                    _buildMilestonesSection(provider),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // Health Benefits Timeline
                    if (provider.hasSoberDate) ...[
                      _buildHealthBenefitsSection(provider),
                      const SizedBox(height: AppConstants.paddingLarge),
                    ],
                    
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

  Widget _buildOverallProgressCard(AppStateProvider provider) {
    final stats = provider.sobrietyStats!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Journey So Far',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            Row(
              children: [
                Expanded(
                  child: _buildProgressStat('Days', stats.days.toString(), AppConstants.primaryPurple),
                ),
                Expanded(
                  child: _buildProgressStat('Weeks', stats.weeks.toString(), AppConstants.successGreen),
                ),
                Expanded(
                  child: _buildProgressStat('Months', stats.months.toString(), AppConstants.blueAccent),
                ),
                if (stats.years > 0)
                  Expanded(
                    child: _buildProgressStat('Years', stats.years.toString(), AppConstants.warningYellow),
                  ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Money saved progress
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.successGreen.withValues(alpha: .1),
                    AppConstants.successGreen.withValues(alpha: .05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.successGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.savings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Money Saved',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.textGray,
                          ),
                        ),
                        Text(
                          '\$${provider.moneySaved.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeXXLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: AppConstants.fontSizeXXLarge,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            color: AppConstants.textGray,
          ),
        ),
      ],
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
                  child: AutoSizeText(
                    'Milestones & Achievements',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(context, AppConstants.fontSizeXLarge),
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                    maxFontSize: AppConstants.fontSizeXLarge,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...provider.milestones.map((milestone) => Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
              child: _buildMilestoneItem(milestone, provider),
            )).toList(),
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
                    AutoSizeText(
                      '${milestone.days} Day${milestone.days != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: ResponsiveHelpers.getResponsiveFontSize(context, AppConstants.fontSizeXLarge),
                        fontWeight: FontWeight.bold,
                        color: milestone.achieved 
                            ? AppConstants.successGreen 
                            : AppConstants.textDark,
                      ),
                      maxLines: 1,
                      minFontSize: 14,
                      maxFontSize: AppConstants.fontSizeXLarge,
                    ),
                    if (milestone.achieved && milestone.achievedDate != null)
                      AutoSizeText(
                        'Achieved on ${milestone.achievedDate!.day}/${milestone.achievedDate!.month}/${milestone.achievedDate!.year}',
                        style: TextStyle(
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(context, AppConstants.fontSizeSmall),
                          color: AppConstants.successGreen,
                        ),
                        maxLines: 1,
                        minFontSize: 10,
                        maxFontSize: AppConstants.fontSizeSmall,
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
                  child: const Text(
                    'Achieved!',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          AutoSizeText(
            milestone.benefit,
            style: TextStyle(
              fontSize: ResponsiveHelpers.getResponsiveFontSize(context, AppConstants.fontSizeMedium),
              color: milestone.achieved 
                  ? AppConstants.successGreen 
                  : AppConstants.textGray,
              height: 1.4,
            ),
            maxLines: 3,
            minFontSize: 12,
            maxFontSize: AppConstants.fontSizeMedium,
          ),
          
          if (!milestone.achieved && stats != null) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
                Text(
                  '${stats.days} / ${milestone.days} days',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textGray,
                  ),
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
            
            Text(
              '$daysUntil days to go',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHealthBenefitsSection(AppStateProvider provider) {
    final stats = provider.sobrietyStats!;
    
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
                    color: AppConstants.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: AutoSizeText(
                    'Health Benefits Timeline',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(context, AppConstants.fontSizeXLarge),
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                    maxFontSize: AppConstants.fontSizeXLarge,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...AppConstants.healthBenefits.entries.map((entry) {
              final days = entry.key;
              final benefit = entry.value;
              final achieved = stats.days >= days;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: achieved 
                            ? AppConstants.successGreen 
                            : AppConstants.borderGray,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        achieved ? Icons.check : Icons.schedule,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$days day${days != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: achieved 
                                  ? AppConstants.successGreen 
                                  : AppConstants.textDark,
                            ),
                          ),
                          Text(
                            benefit,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: achieved 
                                  ? AppConstants.successGreen 
                                  : AppConstants.textGray,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
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
                    color: AppConstants.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppConstants.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Your Statistics',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
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
                      _buildStatRow('Total Check-ins', '${stats['totalCheckIns'] ?? 0}'),
                      _buildStatRow('Average Mood', '${(stats['averageMood'] ?? 0.0).toStringAsFixed(1)}/10'),
                      _buildStatRow('Average Cravings', '${(stats['averageCraving'] ?? 0.0).toStringAsFixed(1)}/10'),
                      _buildStatRow('Milestones Achieved', '${stats['milestonesAchieved'] ?? 0}'),
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
          Text(
            label,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              color: AppConstants.textGray,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}