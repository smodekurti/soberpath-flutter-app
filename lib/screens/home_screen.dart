import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../config/theme_extensions.dart';
import '../services/app_state_provider.dart';
import '../widgets/daily_quote_card.dart';
import '../widgets/daily_checkin_card.dart';
import '../models/sobriety_models.dart';

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
      backgroundColor: context.colors.background,
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
            key: const ValueKey('home_refresh_indicator'),
            onRefresh: _refreshData,
            color: context.colors.primary,
            backgroundColor: context.colors.surface,
            child: CustomScrollView(
              key: const ValueKey('home_scroll_view'),
              slivers: [
                _buildHeader(context, provider),
                SliverPadding(
                  padding: EdgeInsets.all(context.spacing.large),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (provider.hasSoberDate)
                        const DailyCheckInCard(key: ValueKey('daily_checkin_card')),
                      SizedBox(key: const ValueKey('spacer_1'), height: context.spacing.large),
                      if (provider.hasSoberDate)
                        Container(
                          key: const ValueKey('milestone_card_container'),
                          child: _buildNextMilestoneCard(context, provider),
                        ),
                      SizedBox(key: const ValueKey('spacer_2'), height: context.spacing.large),
                      const DailyQuoteCard(key: ValueKey('daily_quote_card')),
                      SizedBox(key: const ValueKey('spacer_3'), height: context.spacing.large * 2),
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

  Widget _buildHeader(BuildContext context, AppStateProvider provider) {
    final user = provider.userProfile;
    final stats = provider.sobrietyStats;

    return SliverAppBar(
      expandedHeight: 220,
      floating: true,
      pinned: false,
      snap: true,
      backgroundColor: context.colors.background,
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
                children: [
                  Text(
                    'Welcome back, ${user?.name ?? 'friend'}!',
                    style: TextStyle(
                      fontSize: context.typography.headlineSmall,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: context.spacing.small),
                  Text(
                    'Your journey, one day at a time.',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const Spacer(),
                  if (stats != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(context, '${stats.days}', 'Days'),
                        _buildStat(context, '${stats.weeks}', 'Weeks'),
                        _buildStat(context, '${stats.months}', 'Months'),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: context.typography.headlineMedium,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: context.typography.bodyMedium,
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNextMilestoneCard(BuildContext context, AppStateProvider provider) {
    final nextMilestone = provider.nextMilestone;

    if (nextMilestone == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.borders.medium),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.large),
          child: Row(
            children: [
              Icon(Icons.celebration, color: context.colors.success, size: 32),
              SizedBox(width: context.spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Milestones Achieved!',
                      style: TextStyle(
                        fontSize: context.typography.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    ),
                    SizedBox(height: context.spacing.small),
                    Text(
                      'Congratulations on your incredible journey!',
                      style: TextStyle(
                        fontSize: context.typography.bodyMedium,
                        color: context.colors.onSurface.withValues(alpha: 0.8),
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

    final progress = provider.getMilestoneProgress(nextMilestone.days);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.borders.medium),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Next Goal: ${nextMilestone.days} Days',
              style: TextStyle(
                fontSize: context.typography.titleLarge,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: context.spacing.small),
            Text(
              nextMilestone.benefit,
              style: TextStyle(
                fontSize: context.typography.bodyMedium,
                color: context.colors.onSurface.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
            ),
            SizedBox(height: context.spacing.large),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: context.colors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.secondary),
                    ),
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: context.typography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: context.colors.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.medium),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${provider.getDaysUntilMilestone(nextMilestone.days)} days to go!',
                style: TextStyle(
                  fontSize: context.typography.bodyMedium,
                  fontWeight: FontWeight.w500,
                  color: context.colors.onSurface.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}