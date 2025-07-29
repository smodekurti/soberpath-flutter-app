import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

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
                        const Text(
                          'Support',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeTitle,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'Get help when you need it',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            color: Colors.white.withOpacity(0.9),
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
                // Crisis Support Section
                _buildCrisisSupportCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Recovery Resources Section
                _buildRecoveryResourcesCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Coping Strategies Section
                _buildCopingStrategiesCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Helpful Apps Section
                _buildHelpfulAppsCard(),
                
                const SizedBox(height: AppConstants.paddingLarge),
                
                // Inspirational Content
                _buildInspirationalContentCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisSupportCard() {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.lightRed,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
          border: Border.all(color: AppConstants.dangerRed.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConstants.dangerRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emergency,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Crisis Support',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.dangerRed,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            const Text(
              'If you\'re in crisis, reach out immediately:',
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                color: AppConstants.dangerRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...AppConstants.crisisSupport.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildCrisisContactItem(entry.key, entry.value),
              );
            }).toList(),
            
            const SizedBox(height: AppConstants.paddingMedium),
            
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.dangerRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppConstants.dangerRed,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  const Expanded(
                    child: Text(
                      'Remember: You are not alone. Crisis support is available 24/7.',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.dangerRed,
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

  Widget _buildCrisisContactItem(String title, String contact) {
    return GestureDetector(
      onTap: () => _handleContactTap(contact),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: AppConstants.dangerRed.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              contact.contains('Text') ? Icons.message : Icons.phone,
              color: AppConstants.dangerRed,
              size: 20,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textDark,
                    ),
                  ),
                  Text(
                    contact,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.dangerRed,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppConstants.dangerRed,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryResourcesCard() {
    final resources = [
      {
        'title': 'Alcoholics Anonymous',
        'description': 'Find local AA meetings and support',
        'icon': Icons.people,
        'color': AppConstants.blueAccent,
      },
      {
        'title': 'SMART Recovery',
        'description': 'Self-management and recovery training',
        'icon': Icons.psychology,
        'color': AppConstants.successGreen,
      },
      {
        'title': 'Narcotics Anonymous',
        'description': 'Support for substance recovery',
        'icon': Icons.groups,
        'color': AppConstants.primaryPurple,
      },
      {
        'title': 'Online Support Groups',
        'description': '24/7 chat and forum support',
        'icon': Icons.forum,
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
                    Icons.support_agent,
                    color: AppConstants.successGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Recovery Resources',
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
                  resource['title'] as String,
                  resource['description'] as String,
                  resource['icon'] as IconData,
                  resource['color'] as Color,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopingStrategiesCard() {
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
                    Icons.lightbulb,
                    color: AppConstants.blueAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Coping Strategies',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...AppConstants.copingStrategies.map((strategy) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildCopingStrategyItem(
                  strategy['title']!,
                  strategy['description']!,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCopingStrategyItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppConstants.backgroundGray,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.textDark,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            description,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textGray,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulAppsCard() {
    final apps = [
      {
        'name': 'Headspace',
        'description': 'Meditation and mindfulness',
        'category': 'Meditation',
      },
      {
        'name': 'Calm',
        'description': 'Sleep stories and relaxation',
        'category': 'Wellness',
      },
      {
        'name': 'I Am Sober',
        'description': 'Sobriety tracking and community',
        'category': 'Recovery',
      },
      {
        'name': 'Quit Genius',
        'description': 'Cognitive behavioral therapy for addiction',
        'category': 'Therapy',
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
                    Icons.apps,
                    color: AppConstants.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Helpful Apps',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.paddingLarge),
            
            ...apps.map((app) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
                child: _buildAppItem(
                  app['name']!,
                  app['description']!,
                  app['category']!,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppItem(String name, String description, String category) {
    return Container(
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
            child: const Icon(
              Icons.phone_android,
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
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
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
                        category,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }

  Widget _buildInspirationalContentCard() {
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
                    Icons.auto_awesome,
                    color: AppConstants.warningYellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                const Text(
                  'Stay Inspired',
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
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryPurple.withOpacity(0.1),
                    AppConstants.primaryPurple.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Column(
                children: [
                  const Text(
                    '"The strongest people are not those who show strength in front of us, but those who win battles we know nothing about."',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontStyle: FontStyle.italic,
                      color: AppConstants.primaryPurple,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      // Could navigate to a quotes/inspiration section
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Get New Quote'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryPurple,
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

  void _handleContactTap(String contact) {
    if (contact.contains('988')) {
      _makePhoneCall('tel:988');
    } else if (contact.contains('741741')) {
      _sendSMS('741741', 'HOME');
    } else if (contact.contains('1-800-662-4357')) {
      _makePhoneCall('tel:18006624357');
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _sendSMS(String phoneNumber, String message) async {
    final uri = Uri.parse('sms:$phoneNumber?body=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}