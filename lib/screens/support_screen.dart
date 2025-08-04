import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
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
                          'Support',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeTitle,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        SafeText(
                          'Resources for your recovery journey',
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
                // Crisis Support Section
                _buildCrisisSupportCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Recovery Resources Section
                _buildRecoveryResourcesCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Professional Help Section
                _buildProfessionalHelpCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Community Support Section
                _buildCommunitySupportCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisSupportCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlexibleRow(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.lightRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emergency,
                    color: AppConstants.dangerRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Flexible(
                  child: SafeText(
                    'Crisis Support',
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
            _buildSupportItem(
              'National Suicide Prevention Lifeline',
              '988',
              'Available 24/7 for crisis support',
              () => _makePhoneCall('988'),
              Icons.phone,
              AppConstants.dangerRed,
            ),
            _buildSupportItem(
              'Crisis Text Line',
              'Text HOME to 741741',
              'Free 24/7 crisis support via text',
              () => _sendText('741741', 'HOME'),
              Icons.message,
              AppConstants.warningYellow,
            ),
            _buildSupportItem(
              'SAMHSA National Helpline',
              '1-800-662-4357',
              'Treatment referral and information service',
              () => _makePhoneCall('1-800-662-4357'),
              Icons.support_agent,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryResourcesCard() {
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
                    Icons.library_books,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                SafeText(
                  'Recovery Resources',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'AA (Alcoholics Anonymous)',
              'aa.org',
              'Find meetings and resources',
              () => _launchUrl('https://www.aa.org'),
              Icons.group,
              AppConstants.primaryPurple,
            ),
            _buildSupportItem(
              'NA (Narcotics Anonymous)',
              'na.org',
              'Recovery from drug addiction',
              () => _launchUrl('https://www.na.org'),
              Icons.healing,
              AppConstants.successGreen,
            ),
            _buildSupportItem(
              'SMART Recovery',
              'smartrecovery.org',
              'Self-management and recovery training',
              () => _launchUrl('https://www.smartrecovery.org'),
              Icons.psychology,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelpCard() {
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
                    Icons.medical_services,
                    color: AppConstants.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                SafeText(
                  'Professional Help',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'Find Treatment Facilities',
              'SAMHSA Treatment Locator',
              'Locate treatment facilities near you',
              () => _launchUrl('https://findtreatment.samhsa.gov'),
              Icons.location_on,
              AppConstants.primaryPurple,
            ),
            _buildSupportItem(
              'Psychology Today',
              'Find Therapists & Counselors',
              'Connect with mental health professionals',
              () => _launchUrl('https://www.psychologytoday.com/us/therapists'),
              Icons.person_search,
              AppConstants.successGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitySupportCard() {
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
                    Icons.people,
                    color: AppConstants.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                SafeText(
                  'Community Support',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'Reddit Recovery Communities',
              'r/stopdrinking, r/leaves, r/addiction',
              'Connect with others in recovery',
              () => _launchUrl('https://www.reddit.com/r/stopdrinking'),
              Icons.forum,
              AppConstants.warningYellow,
            ),
            _buildSupportItem(
              'In The Rooms',
              'Online Recovery Meetings',
              'Virtual support group meetings',
              () => _launchUrl('https://www.intherooms.com'),
              Icons.video_call,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(
    String title,
    String subtitle,
    String description,
    VoidCallback onTap,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeText(
                      title,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textDark,
                      ),
                      maxLines: 2,
                    ),
                    SafeText(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                        color: color,
                      ),
                      maxLines: 2,
                    ),
                    SafeText(
                      description,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textGray,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                color: AppConstants.textGray,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendText(String phoneNumber, String message) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber, queryParameters: {'body': message});
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    }
  }
}
