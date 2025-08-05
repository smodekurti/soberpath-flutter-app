import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;
import '../widgets/safe_text.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
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
                        SafeText(
                          'Support',
                          style: context.textTheme.headlineLarge!.copyWith(
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                        SizedBox(height: context.spacing.small),
                        SafeText(
                          'Resources for your recovery journey',
                          style: context.textTheme.titleMedium!.copyWith(
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
                // Crisis Support Section
                _buildCrisisSupportCard(context),
                
                SizedBox(height: context.spacing.large),
                
                // Recovery Resources Section
                _buildRecoveryResourcesCard(context),
                
                SizedBox(height: context.spacing.large),
                
                // Professional Help Section
                _buildProfessionalHelpCard(context),
                
                SizedBox(height: context.spacing.large),
                
                // Community Support Section
                _buildCommunitySupportCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisSupportCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlexibleRow(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.errorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.emergency,
                    color: context.colors.error,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Flexible(
                  child: SafeText(
                    'Crisis Support',
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              context,
              'National Suicide Prevention Lifeline',
              '988',
              'Call or text 988 for crisis support',
              () => _launchUrl('tel:988'),
              Icons.phone,
              context.colors.error,
            ),
            _buildSupportItem(
              context,
              'Crisis Text Line',
              'Text HOME to 741741',
              'Free 24/7 crisis counseling',
              () => _launchUrl('sms:741741'),
              Icons.sms,
              context.colors.secondary,
            ),
            _buildSupportItem(
              context,
              'SAMHSA National Helpline',
              '1-800-662-HELP',
              'Treatment referral and information service',
              () => _launchUrl('tel:18006624357'),
              Icons.support_agent,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryResourcesCard(BuildContext context) {
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
                    color: context.colors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.library_books,
                    color: context.colors.success,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                SafeText(
                  'Recovery Resources',
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              context,
              'AA (Alcoholics Anonymous)',
              'aa.org',
              'Find AA meetings and resources',
              () => _launchUrl('https://www.aa.org'),
              Icons.group,
              context.colors.primary,
            ),
            _buildSupportItem(
              context,
              'NA (Narcotics Anonymous)',
              'na.org',
              'Recovery from drug addiction',
              () => _launchUrl('https://www.na.org'),
              Icons.healing,
              context.colors.success,
            ),
            _buildSupportItem(
              context,
              'SMART Recovery',
              'smartrecovery.org',
              'Self-Management And Recovery Training',
              () => _launchUrl('https://www.smartrecovery.org'),
              Icons.psychology,
              context.colors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelpCard(BuildContext context) {
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
                    color: context.colors.infoLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: context.colors.info,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                SafeText(
                  'Professional Help',
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              context,
              'Find Treatment Facilities',
              'SAMHSA Treatment Locator',
              'Search for treatment facilities near you',
              () => _launchUrl('https://findtreatment.samhsa.gov'),
              Icons.location_on,
              context.colors.secondary,
            ),
            _buildSupportItem(
              context,
              'Psychology Today Therapist Directory',
              'Find therapists specializing in addiction',
              'Search for therapists by specialty and location',
              () => _launchUrl('https://www.psychologytoday.com/us/therapists/addiction'),
              Icons.person_search,
              context.colors.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitySupportCard(BuildContext context) {
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                SafeText(
                  'Community Support',
                  style: context.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              context,
              'Reddit Recovery Communities',
              'r/stopdrinking, r/leaves, r/addiction',
              'Online forums for peer support',
              () => _launchUrl('https://www.reddit.com/r/stopdrinking'),
              Icons.forum,
              context.colors.secondary,
            ),
            _buildSupportItem(
              context,
              'In The Rooms',
              'Online Recovery Meetings',
              'Virtual support group meetings',
              () => _launchUrl('https://www.intherooms.com'),
              Icons.video_call,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(BuildContext context, String title, String subtitle, String description, VoidCallback onTap, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.borders.small),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.medium),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              SizedBox(width: context.spacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      title,
                      style: context.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                      maxLines: 1,
                    ),
                    SafeText(
                      subtitle,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: context.spacing.small),
                    SafeText(
                      description,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colors.onSurfaceVariant.withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: context.colors.onSurfaceVariant.withValues(alpha: 0.8),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
