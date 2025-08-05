import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_extensions.dart';

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
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          // Custom Header
          Container(
            decoration: BoxDecoration(
              gradient: context.colors.primaryGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Title Section
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.spacing.large,
                      context.spacing.large,
                      context.spacing.large,
                      context.spacing.medium,
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
                            SizedBox(width: context.spacing.medium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Help & Connect',
                                    style: TextStyle(
                                      fontSize: context.typography.titleLarge,
                                      fontWeight: context.typography.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Support when you need it most',
                                    style: TextStyle(
                                      fontSize: context.typography.bodyMedium,
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
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacing.large,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.borders.large),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(context.borders.large),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                      labelStyle: TextStyle(
                        fontSize: context.typography.bodyMedium,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: context.typography.bodyMedium,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sos, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Crisis Support',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          height: 44,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people, size: 18),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Find Meetings',
                                  style: TextStyle(
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
                  SizedBox(height: context.spacing.large),
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
      padding: EdgeInsets.all(context.spacing.large),
      child: Column(
        children: [
          // Emergency Crisis Support
          _buildCrisisSupportCard(),
          
          SizedBox(height: context.spacing.large),
          
          // Recovery Resources
          _buildRecoveryResourcesCard(),
          
          SizedBox(height: context.spacing.large),
          
          // Professional Help
          _buildProfessionalHelpCard(),
          
          SizedBox(height: context.spacing.large),
          
          // Community Support
          _buildCommunitySupportCard(),
        ],
      ),
    );
  }

  Widget _buildMeetingsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing.large),
      child: Column(
        children: [
          // Quick Meeting Finder
          _buildQuickMeetingFinderCard(),
          
          SizedBox(height: context.spacing.large),
          
          // Online Meetings
          _buildOnlineMeetingsCard(),
          
          SizedBox(height: context.spacing.large),
          
          // Meeting Resources
          _buildMeetingResourcesCard(),
          
          SizedBox(height: context.spacing.large),
          
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
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.emergency,
                    color: context.colors.error,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Emergency Crisis Support',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'National Suicide Prevention Lifeline',
              '988',
              'Available 24/7 for crisis support',
              () => _makePhoneCall('988'),
              Icons.phone,
              context.colors.error,
            ),
            _buildSupportItem(
              'Crisis Text Line',
              'Text HOME to 741741',
              'Free 24/7 crisis support via text',
              () => _sendText('741741', 'HOME'),
              Icons.message,
              context.colors.secondary,
            ),
            _buildSupportItem(
              'SAMHSA National Helpline',
              '1-800-662-4357',
              'Treatment referral and information service',
              () => _makePhoneCall('1-800-662-4357'),
              Icons.support_agent,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryResourcesCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.library_books,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Recovery Resources',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'AA (Alcoholics Anonymous)',
              'aa.org',
              'Find meetings and resources',
              () => _launchUrl('https://www.aa.org'),
              Icons.group,
              context.colors.primary,
            ),
            _buildSupportItem(
              'NA (Narcotics Anonymous)',
              'na.org',
              'Recovery from drug addiction',
              () => _launchUrl('https://www.na.org'),
              Icons.healing,
              context.colors.primary,
            ),
            _buildSupportItem(
              'SMART Recovery',
              'smartrecovery.org',
              'Self-management and recovery training',
              () => _launchUrl('https://www.smartrecovery.org'),
              Icons.psychology,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelpCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medical_services,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Professional Help',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'Find Treatment Facilities',
              'SAMHSA Treatment Locator',
              'Locate treatment facilities near you',
              () => _launchUrl('https://findtreatment.samhsa.gov'),
              Icons.location_on,
              context.colors.primary,
            ),
            _buildSupportItem(
              'Psychology Today',
              'Find Therapists & Counselors',
              'Connect with mental health professionals',
              () => _launchUrl('https://www.psychologytoday.com/us/therapists'),
              Icons.person_search,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitySupportCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Community Support',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'Reddit Recovery Communities',
              'r/stopdrinking, r/leaves, r/addiction',
              'Connect with others in recovery',
              () => _launchUrl('https://www.reddit.com/r/stopdrinking'),
              Icons.forum,
              context.colors.secondary,
            ),
            _buildSupportItem(
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

  // Meeting Cards
  Widget _buildQuickMeetingFinderCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.search,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Find Local Meetings',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'AA Meeting Guide',
              'Official AA meeting finder app',
              'Find in-person and online AA meetings',
              () => _launchUrl('https://meetingguide.org/'),
              Icons.location_on,
              context.colors.primary,
            ),
            _buildSupportItem(
              'NA Meeting Search',
              'Find Narcotics Anonymous meetings',
              'Locate NA meetings worldwide',
              () => _launchUrl('https://www.na.org/meetingsearch/'),
              Icons.search,
              context.colors.primary,
            ),
            _buildSupportItem(
              'SMART Recovery Meetings',
              'Find SMART Recovery meetings',
              'Self-management recovery meetings',
              () => _launchUrl('https://www.smartrecovery.org/meetings/'),
              Icons.psychology,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineMeetingsCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.video_call,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Online Meetings',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'AA Online Intergroup',
              '24/7 online AA meetings',
              'Join meetings from anywhere',
              () => _launchUrl('https://aa-intergroup.org/'),
              Icons.video_call,
              context.colors.primary,
            ),
            _buildSupportItem(
              'In The Rooms',
              'Virtual recovery meetings',
              'Multiple recovery programs online',
              () => _launchUrl('https://www.intherooms.com'),
              Icons.people,
              context.colors.primary,
            ),
            _buildSupportItem(
              'Recovery Dharma Online',
              'Buddhist approach to recovery',
              'Mindfulness-based recovery meetings',
              () => _launchUrl('https://recoverydharma.online/'),
              Icons.self_improvement,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingResourcesCard() {
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
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.library_books,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Meeting Resources',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            _buildSupportItem(
              'First Meeting Guide',
              'What to expect at your first meeting',
              'Tips for newcomers',
              () => _showFirstMeetingDialog(),
              Icons.help_outline,
              context.colors.secondary,
            ),
            _buildSupportItem(
              'Meeting Etiquette',
              'How to behave in meetings',
              'Respectful participation guidelines',
              () => _showMeetingEtiquetteDialog(),
              Icons.handshake,
              context.colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingTipsCard() {
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
                    color: context.colors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb_outline,
                    color: context.colors.secondary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Expanded(
                  child: Text(
                    'Meeting Tips',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.spacing.large),
            Text(
              '💡 Try different meetings to find the right fit\n'
              '🤝 You don\'t have to share if you\'re not ready\n'
              '📱 Arrive early to get comfortable\n'
              '🔄 "Keep coming back" - consistency helps\n'
              '👥 Consider getting a sponsor when ready\n'
              '📝 Bring a notebook for insights',
              style: TextStyle(
                fontSize: context.typography.bodyMedium,
                color: context.colors.onSurface,
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
      margin: EdgeInsets.only(bottom: context.spacing.medium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.borders.medium),
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
          borderRadius: BorderRadius.circular(context.borders.medium),
          child: Padding(
            padding: EdgeInsets.all(context.spacing.large),
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
                SizedBox(width: context.spacing.large),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: context.typography.titleMedium,
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: context.typography.bodyMedium,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.onSurfaceVariant,
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
