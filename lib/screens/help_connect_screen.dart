import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class HelpConnectScreen extends StatefulWidget {
  const HelpConnectScreen({super.key});

  @override
  State<HelpConnectScreen> createState() => _HelpConnectScreenState();
}

class _HelpConnectScreenState extends State<HelpConnectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundGray,
      body: Column(
        children: [
          // Custom Header
          Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.purpleGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.paddingLarge,
                      AppConstants.paddingLarge,
                      AppConstants.paddingLarge,
                      AppConstants.paddingMedium,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.help_center,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Help & Connect',
                                    style: TextStyle(
                                      fontSize: AppConstants.fontSizeTitle,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Support when you need it most',
                                    style: TextStyle(
                                      fontSize: AppConstants.fontSizeMedium,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Tab Bar
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                      labelStyle: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        const Tab(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.sos, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Crisis Support',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Tab(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.people, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Find Meetings',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Crisis Support Tab
                _buildCrisisSupportTab(),
                // Meetings Tab
                _buildMeetingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisSupportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Emergency Crisis Support
          _buildCrisisSupportCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Recovery Resources
          _buildRecoveryResourcesCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Professional Help
          _buildProfessionalHelpCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Community Support
          _buildCommunitySupportCard(),
        ],
      ),
    );
  }

  Widget _buildMeetingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Quick Meeting Finder
          _buildQuickMeetingFinderCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Online Meetings
          _buildOnlineMeetingsCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Meeting Resources
          _buildMeetingResourcesCard(),
          
          const SizedBox(height: AppConstants.paddingLarge),
          
          // Meeting Preparation Tips
          _buildMeetingTipsCard(),
        ],
      ),
    );
  }

  // Crisis Support Cards
  Widget _buildCrisisSupportCard() {
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
                const Expanded(
                  child: Text(
                    'Emergency Crisis Support',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                const Expanded(
                  child: Text(
                    'Recovery Resources',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                const Expanded(
                  child: Text(
                    'Professional Help',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                const Expanded(
                  child: Text(
                    'Community Support',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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

  // Meeting Cards
  Widget _buildQuickMeetingFinderCard() {
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
                    Icons.search,
                    color: AppConstants.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Expanded(
                  child: Text(
                    'Find Local Meetings',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'AA Meeting Guide',
              'Official AA meeting finder app',
              'Find in-person and online AA meetings',
              () => _launchUrl('https://meetingguide.org/'),
              Icons.location_on,
              AppConstants.primaryPurple,
            ),
            _buildSupportItem(
              'NA Meeting Search',
              'Find Narcotics Anonymous meetings',
              'Locate NA meetings worldwide',
              () => _launchUrl('https://www.na.org/meetingsearch/'),
              Icons.search,
              AppConstants.successGreen,
            ),
            _buildSupportItem(
              'SMART Recovery Meetings',
              'Find SMART Recovery meetings',
              'Self-management recovery meetings',
              () => _launchUrl('https://www.smartrecovery.org/meetings/'),
              Icons.psychology,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineMeetingsCard() {
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
                    Icons.video_call,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Expanded(
                  child: Text(
                    'Online Meetings',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'AA Online Intergroup',
              '24/7 online AA meetings',
              'Join meetings from anywhere',
              () => _launchUrl('https://aa-intergroup.org/'),
              Icons.video_call,
              AppConstants.primaryPurple,
            ),
            _buildSupportItem(
              'In The Rooms',
              'Virtual recovery meetings',
              'Multiple recovery programs online',
              () => _launchUrl('https://www.intherooms.com'),
              Icons.people,
              AppConstants.successGreen,
            ),
            _buildSupportItem(
              'Recovery Dharma Online',
              'Buddhist approach to recovery',
              'Mindfulness-based recovery meetings',
              () => _launchUrl('https://recoverydharma.online/'),
              Icons.self_improvement,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingResourcesCard() {
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
                    Icons.library_books,
                    color: AppConstants.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Expanded(
                  child: Text(
                    'Meeting Resources',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            _buildSupportItem(
              'First Meeting Guide',
              'What to expect at your first meeting',
              'Tips for newcomers',
              () => _showFirstMeetingDialog(),
              Icons.help_outline,
              AppConstants.warningYellow,
            ),
            _buildSupportItem(
              'Meeting Etiquette',
              'How to behave in meetings',
              'Respectful participation guidelines',
              () => _showMeetingEtiquetteDialog(),
              Icons.handshake,
              AppConstants.blueAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTipsCard() {
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
                    Icons.lightbulb_outline,
                    color: AppConstants.warningYellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Expanded(
                  child: Text(
                    'Meeting Tips',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            const Text(
              '💡 Try different meetings to find the right fit\n'
              '🤝 You don\'t have to share if you\'re not ready\n'
              '📱 Arrive early to get comfortable\n'
              '🔄 "Keep coming back" - consistency helps\n'
              '👥 Consider getting a sponsor when ready\n'
              '📝 Bring a notebook for insights',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textDark,
                height: 1.5,
              ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingLarge),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textDark,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textGray,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundGray,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConstants.textGray,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
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

  void _showFirstMeetingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your First Meeting'),
          content: const SingleChildScrollView(
            child: Text(
              'Going to your first recovery meeting can feel intimidating, but remember:\n\n'
              '🤝 Everyone there has been where you are\n'
              '🤐 You don\'t have to say anything if you don\'t want to\n'
              '🚪 It\'s okay to leave if you feel uncomfortable\n'
              '🔄 Try different meetings to find the right fit\n'
              '👥 You can bring a supportive friend or family member\n'
              '💪 Take your time - there\'s no pressure\n\n'
              'Most importantly, you\'re taking a brave step toward recovery. '
              'The recovery community is welcoming and supportive.',
              style: TextStyle(height: 1.4),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _showMeetingEtiquetteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meeting Etiquette'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Meeting Etiquette:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '• Arrive on time or a few minutes early\n'
                  '• Turn off or silence your phone\n'
                  '• Listen respectfully when others share\n'
                  '• Don\'t interrupt or give advice\n'
                  '• Keep sharing to the time limit\n'
                  '• Avoid cross-talk or direct responses\n'
                  '• Respect anonymity - first names only\n'
                  '• Don\'t discuss what others shared outside',
                  style: TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Understood'),
            ),
          ],
        );
      },
    );
  }
}
