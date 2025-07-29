import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/sobriety_counter_card.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/stats_cards.dart';
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
                      
                      // Stats Cards (Money Saved & Milestones)
                      const StatsCards(),
                      
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