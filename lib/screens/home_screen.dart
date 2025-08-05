import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_extensions.dart';
import '../services/app_state_provider.dart';
import '../widgets/app_header.dart';
import '../config/app_config.dart';

import '../widgets/sobriety_counter_card.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/daily_checkin_card.dart';

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
      backgroundColor: context.colors.surface,
      body: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasUserProfile) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: context.colors.primary,
            child: CustomScrollView(
              slivers: [
                // Collapsible App Header
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  pinned: true,
                  backgroundColor: context.colors.primary,
                  // Title will only show when collapsed
                  title: Text(AppConfig.info.name),
                  // Don't show title text in FlexibleSpaceBar to avoid duplication
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: context.colors.primaryGradient,
                      ),
                      // Use AppHeader without modification to preserve its functionality
                      child: const SafeArea(
                        bottom: false,
                        child: AppHeader(),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    context.spacing.large,
                    0,
                    context.spacing.large,
                    context.spacing.large,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Sobriety Counter Card
                      const SobrietyCounterCard(),
                      
                      SizedBox(height: context.spacing.large),
                      
                      // Daily Quote Card
                      const DailyQuoteCard(),
                      
                      SizedBox(height: context.spacing.large),
                      
                      // Enhanced Milestones Card
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(context.spacing.large),
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
                                          color: context.colors.secondary.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(context.borders.small),
                                        ),
                                        child: Icon(
                                          Icons.emoji_events_outlined,
                                          color: context.colors.secondary,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: context.spacing.medium),
                                      Text(
                                        'Milestones',
                                        style: TextStyle(
                                          fontSize: context.typography.bodyMedium,
                                          color: context.colors.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.spacing.small,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.colors.secondary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(context.borders.small),
                                    ),
                                    child: Text(
                                      '${provider.achievedMilestonesCount} unlocked',
                                      style: TextStyle(
                                        fontSize: context.typography.bodySmall,
                                        color: context.colors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: context.spacing.large),
                              
                              // Next milestone section
                              if (provider.nextMilestone != null) ...[
                                Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: context.colors.secondary,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    SizedBox(width: context.spacing.small),
                                    Text(
                                      'Next Goal',
                                      style: TextStyle(
                                        fontSize: context.typography.bodySmall,
                                        color: context.colors.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: context.spacing.small),
                                
                                // Next milestone info
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${provider.nextMilestone!.days} Days',
                                            style: TextStyle(
                                              fontSize: context.typography.titleLarge,
                                              fontWeight: FontWeight.bold,
                                              color: context.colors.secondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            provider.nextMilestone!.benefit,
                                            style: TextStyle(
                                              fontSize: context.typography.bodySmall,
                                              color: context.colors.onSurfaceVariant,
                                              height: 1.3,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    SizedBox(width: context.spacing.medium),
                                    
                                    // Days remaining
                                    Container(
                                      padding: EdgeInsets.all(context.spacing.medium),
                                      decoration: BoxDecoration(
                                        color: context.colors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(context.borders.medium),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${provider.getDaysUntilMilestone(provider.nextMilestone!.days)}',
                                            style: TextStyle(
                                              fontSize: context.typography.titleLarge,
                                              fontWeight: FontWeight.bold,
                                              color: context.colors.primary,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            'days to go',
                                            style: TextStyle(
                                              fontSize: context.typography.bodySmall,
                                              color: context.colors.primary.withValues(alpha: 0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: context.spacing.medium),
                                
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
                                            fontSize: context.typography.bodySmall,
                                            color: context.colors.onSurfaceVariant.withValues(alpha: 0.8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${(provider.getMilestoneProgress(provider.nextMilestone!.days) * 100).toInt()}%',
                                          style: TextStyle(
                                            fontSize: context.typography.bodySmall,
                                            color: context.colors.secondary,
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
                                        backgroundColor: context.colors.outline,
                                        valueColor: AlwaysStoppedAnimation<Color>(context.colors.secondary),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                // All milestones achieved
                                Container(
                                  padding: EdgeInsets.all(context.spacing.large),
                                  decoration: BoxDecoration(
                                    color: context.colors.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(context.borders.medium),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.celebration,
                                        color: context.colors.success,
                                        size: 32,
                                      ),
                                      SizedBox(height: context.spacing.small),
                                      Text(
                                        'All Milestones Achieved!',
                                        style: TextStyle(
                                          fontSize: context.typography.titleMedium,
                                          fontWeight: FontWeight.bold,
                                          color: context.colors.success,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Congratulations on your incredible journey!',
                                        style: TextStyle(
                                          fontSize: context.typography.bodySmall,
                                          color: context.colors.success.withValues(alpha: 0.8),
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
                      
                      SizedBox(height: context.spacing.large),
                      
                      // Daily Check-in Card (if user has sober date)
                      if (provider.hasSoberDate) ...[
                        const DailyCheckInCard(),
                        SizedBox(height: context.spacing.large),
                      ],
                      
                      // Motivation Section
                      _buildMotivationSection(provider),
                      
                      SizedBox(height: context.spacing.large * 2),
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
                    Icons.auto_awesome,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Keep Going!',
                  style: TextStyle(
                    fontSize: context.typography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.medium),
            
            if (nextMilestone != null) ...[
              Text(
                'You\'re ${provider.getDaysUntilMilestone(nextMilestone.days)} days away from your ${nextMilestone.days}-day milestone!',
                style: TextStyle(
                  fontSize: context.typography.titleMedium,
                  color: context.colors.onSurface,
                ),
              ),
              
              SizedBox(height: context.spacing.medium),
              
              // Progress bar for next milestone
              LinearProgressIndicator(
                value: provider.getMilestoneProgress(nextMilestone.days),
                backgroundColor: context.colors.outline,
                valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                minHeight: 6,
              ),
              
              SizedBox(height: context.spacing.small),
              
              Text(
                '${(provider.getMilestoneProgress(nextMilestone.days) * 100).toInt()}% complete',
                style: TextStyle(
                  fontSize: context.typography.bodyMedium,
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              Text(
                'Amazing! You\'ve achieved all major milestones. Keep up the incredible work!',
                style: TextStyle(
                  fontSize: context.typography.titleMedium,
                  color: context.colors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            
            SizedBox(height: context.spacing.large),
            
            // Achievement summary
            Container(
              padding: EdgeInsets.all(context.spacing.medium),
              decoration: BoxDecoration(
                color: context.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(context.borders.medium),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: context.colors.success,
                  ),
                  SizedBox(width: context.spacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stats.days} days strong',
                          style: TextStyle(
                            fontSize: context.typography.titleMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.success,
                          ),
                        ),
                        Text(
                          '${provider.achievedMilestonesCount} milestones achieved',
                          style: TextStyle(
                            fontSize: context.typography.bodyMedium,
                            color: context.colors.success,
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