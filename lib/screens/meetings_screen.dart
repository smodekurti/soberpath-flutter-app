import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:soberpath_app/constants/app_constants.dart';
import 'package:soberpath_app/widgets/safe_text.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;

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
                        Text(
                          'Meetings',
                          style: TextStyle(
                            fontSize: context.typography.headlineMedium,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: context.spacing.small),
                        Text(
                          'Find support groups near you',
                          style: TextStyle(
                            fontSize: context.typography.titleMedium,
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
            padding: EdgeInsets.all(context.spacing.large),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Meeting Type Filter
                _buildMeetingTypeFilter(),
                
                SizedBox(height: context.spacing.large),
                
                // Find Meetings Card
                _buildFindMeetingsCard(),
                
                SizedBox(height: context.spacing.large),
                
                // Online Meetings Section
                _buildOnlineMeetingsCard(),
                
                SizedBox(height: context.spacing.large),
                
                // Meeting Resources
                _buildMeetingResourcesCard(),
                
                SizedBox(height: context.spacing.large),
                
                // Virtual Meeting Tips
                _buildVirtualMeetingTipsCard(),
                
                SizedBox(height: context.spacing.large),
                
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
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meeting Type',
              style: TextStyle(
                fontSize: context.typography.titleLarge,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            
            SizedBox(height: context.spacing.medium),
            
            Wrap(
              spacing: context.spacing.small,
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
                  selectedColor: context.colors.primary.withValues(alpha: 0.2),
                  checkmarkColor: context.colors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? context.colors.primary : context.colors.onSurfaceVariant,
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
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.secondaryLight,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.location_on,
                size: 40,
                color: context.colors.secondary,
              ),
            ),
            
            SizedBox(height: context.spacing.large),
            
            Text(
              'Find Local Meetings',
              style: TextStyle(
                fontSize: context.typography.headlineSmall,
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            
            SizedBox(height: context.spacing.medium),
            
            Text(
              'Connect with your local recovery community. Find in-person meetings in your area.',
              style: TextStyle(
                fontSize: context.typography.titleMedium,
                color: context.colors.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: context.spacing.large),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _findLocalMeetings,
                icon: const Icon(Icons.search),
                label: const Text('Find Meetings Near Me'),
              ),
            ),
            
            SizedBox(height: context.spacing.medium),
            
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
        'color': context.colors.secondary,
      },
      {
        'title': 'NA Online Meetings',
        'description': 'Narcotics Anonymous virtual meetings',
        'url': 'https://virtual-na.org/meetings/',
        'icon': Icons.video_call,
        'color': context.colors.success,
      },
      {
        'title': 'SMART Recovery Online',
        'description': 'Self-management recovery meetings',
        'url': 'https://www.smartrecovery.org/community/',
        'icon': Icons.psychology,
        'color': context.colors.primary,
      },
      {
        'title': 'In The Rooms',
        'description': 'Recovery social network and meetings',
        'url': 'https://www.intherooms.com/',
        'icon': Icons.group,
        'color': context.colors.warning,
      },
    ];

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
                    color: context.colors.success.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.computer,
                    color: context.colors.success,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Text(
                  'Online Meetings',
                  style: TextStyle(
                    fontSize: context.typography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            ...onlineMeetings.map((meeting) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.spacing.small),
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
        padding: EdgeInsets.all(context.spacing.medium),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(context.borders.medium),
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
            SizedBox(width: context.spacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeText(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.titleLarge),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.spacing.small),
                  SafeText(
                    description,
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.bodyLarge),
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
                    Icons.library_books,
                    color: context.colors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Text(
                  'Meeting Resources',
                  style: TextStyle(
                    fontSize: context.typography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            ...resources.map((resource) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.spacing.small),
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
        padding: EdgeInsets.all(context.spacing.medium),
        decoration: BoxDecoration(
          color: context.colors.background,
          borderRadius: BorderRadius.circular(context.spacing.medium),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getResourceIcon(type),
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: context.spacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: context.typography.titleMedium,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: context.spacing.small),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.spacing.small,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          borderRadius: BorderRadius.circular(context.spacing.small),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: context.typography.bodySmall,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.spacing.small),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: context.typography.bodyLarge,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.spacing.small),
            Icon(
              Icons.launch,
              color: context.colors.primary,
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
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.warningLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tips_and_updates,
                    color: context.colors.warning,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Text(
                  'Virtual Meeting Tips',
                  style: TextStyle(
                    fontSize: context.typography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            ...tips.map((tip) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.spacing.small),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: context.colors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.spacing.medium),
                    Expanded(
                      child: Text(
                        tip,
                        style: TextStyle(
                          fontSize: context.typography.bodyMedium,
                          color: context.colors.onSurface,
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
        padding: EdgeInsets.all(context.spacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.success.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.checklist,
                    color: context.colors.success,
                    size: 20,
                  ),
                ),
                SizedBox(width: context.spacing.medium),
                Text(
                  'First Meeting?',
                  style: TextStyle(
                    fontSize: context.typography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: context.spacing.large),
            
            Container(
              padding: EdgeInsets.all(context.spacing.large),
              decoration: BoxDecoration(
                color: context.colors.success.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(context.borders.medium),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What to Expect',
                    style: TextStyle(
                      fontSize: context.typography.titleMedium,
                      fontWeight: FontWeight.bold,
                      color: context.colors.success,
                    ),
                  ),
                  
                  SizedBox(height: context.spacing.medium),
                  
                  Text(
                    '• Meetings typically last 60-90 minutes\n'
                    '• You can just listen - sharing is optional\n'
                    '• Everyone is welcome, regardless of where you are in recovery\n'
                    '• Confidentiality is maintained\n'
                    '• No fees or dues required\n'
                    '• Arrive a few minutes early to introduce yourself',
                    style: TextStyle(
                      fontSize: context.typography.bodyLarge,
                      color: context.colors.success,
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: context.spacing.large),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _showFirstMeetingDialog();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.success,
                          ),
                          child: const Text('Learn More'),
                        ),
                      ),
                      SizedBox(width: context.spacing.medium),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showMeetingEtiquetteDialog();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.colors.success,
                            side: BorderSide(color: context.colors.success),
                          ),
                          child: const Text('Meeting Etiquette'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: context.spacing.large),
            
            // Emergency Support Info
            Container(
              padding: EdgeInsets.all(context.spacing.medium),
              decoration: BoxDecoration(
                color: context.colors.secondaryLight,
                borderRadius: BorderRadius.circular(context.borders.medium),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.colors.secondary,
                    size: 20,
                  ),
                  SizedBox(width: context.spacing.medium),
                  Expanded(
                    child: Text(
                      'Remember: If you\'re in crisis, seek immediate help. Visit the Support tab for emergency resources.',
                      style: TextStyle(
                        fontSize: context.typography.bodyMedium,
                        color: context.colors.secondary,
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
          SnackBar(
            content: const Text('Could not open the link'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }
}