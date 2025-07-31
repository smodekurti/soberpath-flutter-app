import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/sobriety_counter_card.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/daily_checkin_card.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          if (provider.isLoading && !provider.hasUserProfile) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryPurple),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: AppConstants.primaryPurple,
            child: CustomScrollView(
              slivers: [
                // App Header with gradient background
                const SliverToBoxAdapter(
                  child: AppHeader(),
                ),

                // Main Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppConstants.paddingLarge,
                    0,
                    AppConstants.paddingLarge,
                    AppConstants.paddingLarge,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Sobriety Counter Card
                      const SobrietyCounterCard(),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Daily Quote Card
                      const DailyQuoteCard(),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Enhanced Milestones Card
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.paddingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with achievements count
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppConstants.lightBlue,
                                          borderRadius: BorderRadius.circular(
                                              AppConstants.borderRadiusSmall),
                                        ),
                                        child: const Icon(
                                          Icons.emoji_events_outlined,
                                          color: AppConstants.blueAccent,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: AppConstants.paddingMedium),
                                      const Text(
                                        'Milestones',
                                        style: TextStyle(
                                          fontSize: AppConstants.fontSizeMedium,
                                          color: AppConstants.textGray,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppConstants.paddingSmall,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppConstants.blueAccent.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                                    ),
                                    child: Text(
                                      '${provider.achievedMilestonesCount} unlocked',
                                      style: const TextStyle(
                                        fontSize: AppConstants.fontSizeSmall,
                                        color: AppConstants.blueAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: AppConstants.paddingLarge),
                              
                              // Next milestone section
                              if (provider.nextMilestone != null) ...[
                                Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: AppConstants.blueAccent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: AppConstants.paddingSmall),
                                    const Text(
                                      'Next Goal',
                                      style: TextStyle(
                                        fontSize: AppConstants.fontSizeSmall,
                                        color: AppConstants.textGray,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppConstants.paddingSmall),
                                
                                // Next milestone info
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${provider.nextMilestone!.days} Days',
                                            style: const TextStyle(
                                              fontSize: AppConstants.fontSizeXLarge,
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.blueAccent,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            provider.nextMilestone!.benefit,
                                            style: const TextStyle(
                                              fontSize: AppConstants.fontSizeSmall,
                                              color: AppConstants.textGray,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(width: AppConstants.paddingMedium),
                                    
                                    // Days remaining
                                    Container(
                                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                                      decoration: BoxDecoration(
                                        color: AppConstants.primaryPurple.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${provider.getDaysUntilMilestone(provider.nextMilestone!.days)}',
                                            style: const TextStyle(
                                              fontSize: AppConstants.fontSizeXLarge,
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.primaryPurple,
                                            ),
                                          ),
                                          Text(
                                            'days to go',
                                            style: TextStyle(
                                              fontSize: AppConstants.fontSizeSmall,
                                              color: AppConstants.primaryPurple.withValues(alpha: 0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppConstants.paddingMedium),
                                
                                // Progress bar
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Progress',
                                          style: TextStyle(
                                            fontSize: AppConstants.fontSizeSmall,
                                            color: AppConstants.textGray.withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${(provider.getMilestoneProgress(provider.nextMilestone!.days) * 100).toInt()}%',
                                          style: const TextStyle(
                                            fontSize: AppConstants.fontSizeSmall,
                                            color: AppConstants.blueAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: provider.getMilestoneProgress(provider.nextMilestone!.days),
                                        backgroundColor: AppConstants.borderGray,
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.blueAccent),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                // All milestones achieved
                                Container(
                                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                                  decoration: BoxDecoration(
                                    color: AppConstants.successGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.celebration,
                                        color: AppConstants.successGreen,
                                        size: 32,
                                      ),
                                      const SizedBox(height: AppConstants.paddingSmall),
                                      const Text(
                                        'All Milestones Achieved!',
                                        style: TextStyle(
                                          fontSize: AppConstants.fontSizeLarge,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstants.successGreen,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Congratulations on your incredible journey!',
                                        style: TextStyle(
                                          fontSize: AppConstants.fontSizeSmall,
                                          color: AppConstants.successGreen.withValues(alpha: 0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Daily Check-in Card (if user has sober date)
                      if (provider.hasSoberDate) ...[
                        const DailyCheckInCard(),
                        const SizedBox(height: AppConstants.paddingLarge),
                      ],
                      
                      // Motivation Section
                      _buildMotivationSection(provider),
                      
                      const SizedBox(height: AppConstants.paddingXLarge),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMotivationSection(AppStateProvider provider) {
    if (!provider.hasSoberDate) return const SizedBox.shrink();

    final stats = provider.sobrietyStats!;
    final nextMilestone = provider.nextMilestone;

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
                    Icons.auto_awesome,
                    color: AppConstants.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Keep Going!',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            if (nextMilestone != null) ...[
              Text(
                'You\'re ${provider.getDaysUntilMilestone(nextMilestone.days)} days away from your ${nextMilestone.days}-day milestone!',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  color: AppConstants.textDark,
                ),
              ),
              
              const SizedBox(height: AppConstants.paddingMedium),
              
              // Progress bar for next milestone
              LinearProgressIndicator(
                value: provider.getMilestoneProgress(nextMilestone.days),
                backgroundColor: AppConstants.borderGray,
                valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryPurple),
                minHeight: 6,
              ),
              
              const SizedBox(height: AppConstants.paddingSmall),
              
              Text(
                '${(provider.getMilestoneProgress(nextMilestone.days) * 100).toInt()}% complete',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              const Text(
                'Amazing! You\'ve achieved all major milestones. Keep up the incredible work!',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  color: AppConstants.successGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Achievement summary
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.lightGreen,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: AppConstants.successGreen,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stats.days} days strong',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.successGreen,
                          ),
                        ),
                        Text(
                          '${provider.achievedMilestonesCount} milestones achieved',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
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

}