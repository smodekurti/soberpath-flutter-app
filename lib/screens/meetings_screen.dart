import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../utils/responsive_helpers.dart';

class MeetingsScreen extends StatefulWidget {
  const MeetingsScreen({super.key});

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  String _selectedMeetingType = 'All';
  final List<String> _meetingTypes = ['All', 'AA', 'NA', 'Smart Recovery', 'Online'];

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
                        const Text(
                          'Meetings',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeTitle,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Find support groups near you',
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
                // Meeting Type Filter
                _buildMeetingTypeFilter(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Find Meetings Card
                _buildFindMeetingsCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Online Meetings Section
                _buildOnlineMeetingsCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Meeting Resources
                _buildMeetingResourcesCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Virtual Meeting Tips
                _buildVirtualMeetingTipsCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Meeting Preparation
                _buildMeetingPreparationCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingTypeFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meeting Type',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            Wrap(
              spacing: AppConstants.paddingSmall,
              children: _meetingTypes.map((type) {
                final isSelected = _selectedMeetingType == type;
                return FilterChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedMeetingType = type;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: AppConstants.primaryPurple.withValues(alpha: .2),
                  checkmarkColor: AppConstants.primaryPurple,
                  labelStyle: TextStyle(
                    color: isSelected ? AppConstants.primaryPurple : AppConstants.textGray,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindMeetingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppConstants.lightBlue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.location_on,
                size: 40,
                color: AppConstants.blueAccent,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            const Text(
              'Find Local Meetings',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXXLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.textDark,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            const Text(
              'Connect with your local recovery community. Find in-person meetings in your area.',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.textGray,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _findLocalMeetings,
                icon: const Icon(Icons.search),
                label: const Text('Find Meetings Near Me'),
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            OutlinedButton.icon(
              onPressed: _openMeetingGuide,
              icon: const Icon(Icons.map),
              label: const Text('Open Meeting Guide App'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineMeetingsCard() {
    final onlineMeetings = [
      {
        'title': 'AA Online Meetings',
        'description': '24/7 Alcoholics Anonymous meetings',
        'url': 'https://aa-intergroup.org/meetings',
        'icon': Icons.laptop,
        'color': AppConstants.blueAccent,
      },
      {
        'title': 'NA Online Meetings',
        'description': 'Narcotics Anonymous virtual meetings',
        'url': 'https://virtual-na.org/meetings/',
        'icon': Icons.video_call,
        'color': AppConstants.successGreen,
      },
      {
        'title': 'SMART Recovery Online',
        'description': 'Self-management recovery meetings',
        'url': 'https://www.smartrecovery.org/community/',
        'icon': Icons.psychology,
        'color': AppConstants.primaryPurple,
      },
      {
        'title': 'In The Rooms',
        'description': 'Recovery social network and meetings',
        'url': 'https://www.intherooms.com/',
        'icon': Icons.group,
        'color': AppConstants.warningYellow,
      },
    ];

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
                    Icons.computer,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Online Meetings',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...onlineMeetings.map((meeting) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildOnlineMeetingItem(
                  meeting['title'] as String,
                  meeting['description'] as String,
                  meeting['url'] as String,
                  meeting['icon'] as IconData,
                  meeting['color'] as Color,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineMeetingItem(String title, String description, String url, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: color.withValues(alpha: .3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
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
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, AppConstants.fontSizeLarge),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  SafeText(
                    description,
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, AppConstants.fontSizeMedium),
                      color: color,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.launch,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingResourcesCard() {
    final resources = [
      {
        'title': 'AA Meeting Guide',
        'description': 'Official AA meeting finder app',
        'type': 'Mobile App',
        'url': 'https://meetingguide.org/',
      },
      {
        'title': 'NA Meeting Search',
        'description': 'Find Narcotics Anonymous meetings',
        'type': 'Website',
        'url': 'https://www.na.org/meetingsearch/',
      },
      {
        'title': 'Meeting Maker',
        'description': 'Print meeting schedules and directories',
        'type': 'Tool',
        'url': 'https://www.meetingmaker.org/',
      },
      {
        'title': 'Recovery Dharma',
        'description': 'Buddhist-inspired recovery meetings',
        'type': 'Alternative',
        'url': 'https://recoverydharma.community/',
      },
    ];

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
                const Text(
                  'Meeting Resources',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...resources.map((resource) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildResourceItem(
                  resource['title']!,
                  resource['description']!,
                  resource['type']!,
                  resource['url']!,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String title, String description, String type, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppConstants.backgroundGray,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getResourceIcon(type),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryPurple,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: AppConstants.textGray,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            const Icon(
              Icons.launch,
              color: AppConstants.primaryPurple,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVirtualMeetingTipsCard() {
    final tips = [
      'Test your audio and video before joining',
      'Find a quiet, private space for the meeting',
      'Have a pen and paper ready for notes',
      'Keep your phone on silent',
      'Be patient with technical difficulties',
      'Follow the same etiquette as in-person meetings',
      'Mute yourself when not speaking',
      'Use the chat feature respectfully',
    ];

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
                    Icons.tips_and_updates,
                    color: AppConstants.warningYellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Virtual Meeting Tips',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: AppConstants.warningYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          color: AppConstants.textDark,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingPreparationCard() {
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
                    Icons.checklist,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'First Meeting?',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppConstants.lightGreen,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What to Expect',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.successGreen,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingMedium),
                  
                  const Text(
                    '• Meetings typically last 60-90 minutes\n'
                    '• You can just listen - sharing is optional\n'
                    '• Everyone is welcome, regardless of where you are in recovery\n'
                    '• Confidentiality is maintained\n'
                    '• No fees or dues required\n'
                    '• Arrive a few minutes early to introduce yourself',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: AppConstants.successGreen,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showFirstMeetingDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.successGreen,
                          ),
                          child: const Text('Learn More'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showMeetingEtiquetteDialog();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.successGreen,
                            side: const BorderSide(color: AppConstants.successGreen),
                          ),
                          child: const Text('Meeting Etiquette'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            // Emergency Support Info
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.lightBlue,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppConstants.blueAccent,
                    size: 20,
                  ),
                  SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Text(
                      'Remember: If you\'re in crisis, seek immediate help. Visit the Support tab for emergency resources.',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.blueAccent,
                        fontWeight: FontWeight.w500,
                      ),
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

  IconData _getResourceIcon(String type) {
    switch (type) {
      case 'Mobile App':
        return Icons.phone_android;
      case 'Website':
        return Icons.web;
      case 'Tool':
        return Icons.build;
      case 'Alternative':
        return Icons.explore;
      default:
        return Icons.info;
    }
  }

  void _findLocalMeetings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Find Local Meetings'),
          content: const Text(
            'To find meetings in your area, we recommend using the official meeting finder apps or websites for each organization:\n\n'
            '• AA: Use the Meeting Guide app or aa.org\n'
            '• NA: Visit na.org meeting search\n'
            '• SMART Recovery: Visit smartrecovery.org\n'
            '• Crystal Meth Anonymous: Visit crystalmeth.org\n\n'
            'Would you like to visit the AA Meeting Guide website?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _launchURL('https://www.aa.org/find-aa/local-aa');
              },
              child: const Text('Visit AA.org'),
            ),
          ],
        );
      },
    );
  }

  void _openMeetingGuide() {
    _launchURL('https://meetingguide.org/');
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
              'The recovery community is welcoming and supportive.\n\n'
              'Common phrases you might hear:\n'
              '• "Keep coming back" - encouragement to attend regularly\n'
              '• "One day at a time" - focus on today\n'
              '• "It works if you work it" - recovery requires effort\n'
              '• "Progress, not perfection" - small steps count',
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
                  '• Don\'t discuss what others shared outside\n\n',
                  style: TextStyle(height: 1.4),
                ),
                Text(
                  'Virtual Meeting Etiquette:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '• Test your technology beforehand\n'
                  '• Mute yourself when not speaking\n'
                  '• Use good lighting and stable internet\n'
                  '• Dress appropriately\n'
                  '• Minimize distractions in your background\n'
                  '• Use the chat feature appropriately\n'
                  '• Be patient with technical difficulties',
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the link'),
            backgroundColor: AppConstants.dangerRed,
          ),
        );
      }
    }
  }
}