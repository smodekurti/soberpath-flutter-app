// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';
import '../models/sobriety_models.dart';
import '../utils/responsive_helpers.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dailyCostController =
      TextEditingController(text: '15');

  int _currentPage = 0;
  DateTime? _selectedSoberDate;
  String _selectedSubstance = 'alcohol';
  UsageFrequency _selectedUsageFrequency = UsageFrequency.occasionally;
  bool _isLoading = false;

  final List<String> _substanceOptions = [
    'alcohol',
    'tobacco',
    'cannabis',
    'caffeine',
    'other'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _dailyCostController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppConstants.animationMedium,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<AppStateProvider>(context, listen: false);
      await provider.createUserProfile(
        name: _nameController.text.trim(),
        soberDate: _selectedSoberDate,
        substanceType: _selectedSubstance,
        dailyCost: double.tryParse(_dailyCostController.text) ?? 15.0,
        usageFrequency: _selectedUsageFrequency,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to create profile. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.dangerRed,
      ),
    );
  }

  Future<void> _selectSoberDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedSoberDate) {
      setState(() {
        _selectedSoberDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = screenHeight > 800;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppConstants.purpleGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  // Header - Fixed height
                  Container(
                    height: isLargeScreen ? 80 : 70,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelpers.getResponsivePadding(
                          context, AppConstants.paddingLarge),
                      vertical: ResponsiveHelpers.getResponsivePadding(
                          context, AppConstants.paddingMedium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 48,
                          child: _currentPage > 0
                              ? IconButton(
                                  onPressed: _previousPage,
                                  icon: const Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                )
                              : null,
                        ),
                        Expanded(
                          child: SafeText(
                            'Setup Your Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelpers.getResponsiveFontSize(
                                  context, AppConstants.fontSizeXLarge),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // Progress Indicator - Fixed height
                  Container(
                    height: 20,
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelpers.getResponsivePadding(
                            context, AppConstants.paddingLarge)),
                    child: Row(
                      children: List.generate(3, (index) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: index < 2 ? AppConstants.paddingSmall : 0,
                            ),
                            decoration: BoxDecoration(
                              color: index <= _currentPage
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Content - Flexible height with proper constraints
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight:
                            constraints.maxHeight - (isLargeScreen ? 180 : 160),
                      ),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: [
                          _buildWelcomePage(constraints),
                          _buildPersonalInfoPage(constraints),
                          _buildSobrietyDetailsPage(constraints),
                        ],
                      ),
                    ),
                  ),

                  // Navigation Button - Fixed height
                  Container(
                    height: isLargeScreen ? 90 : 70,
                    padding: EdgeInsets.all(
                        ResponsiveHelpers.getResponsivePadding(
                            context, AppConstants.paddingLarge)),
                    child: SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _nextPage,
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusLarge),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppConstants.primaryPurple,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _currentPage == 2
                                        ? 'Start Your Journey'
                                        : 'Continue',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelpers
                                          .getResponsiveFontSize(context, 14.0),
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.primaryPurple,
                                      height: 1.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
          context, AppConstants.paddingMedium)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight - 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.favorite,
                size: 50,
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),
            SafeText(
              'Welcome to SoberPath',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeXXLarge),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),
            SafeText(
              'Your personal companion for recovery and sobriety tracking. Let\'s set up your profile to get started.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                color: Colors.white.withValues(alpha: .9),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),
            _buildFeatureList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    final features = [
      'Track your sobriety milestones',
      'Daily mood and craving check-ins',
      'Monitor your progress and savings',
      'Access support resources 24/7',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelpers.getResponsivePadding(
                  context, AppConstants.paddingSmall)),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                  width: ResponsiveHelpers.getResponsivePadding(
                      context, AppConstants.paddingMedium)),
              Expanded(
                child: SafeText(
                  feature,
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeMedium),
                    color: Colors.white.withValues(alpha: .9),
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPersonalInfoPage(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
          context, AppConstants.paddingMedium)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight - 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),
            SafeText(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeXXLarge),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            SafeText(
              'This information helps us personalize your experience.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                color: Colors.white.withValues(alpha: .9),
              ),
              maxLines: 3,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            // Name Input
            SafeText(
              'What should we call you?',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Enter your name',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            // Substance Type Selection
            AutoSizeText(
              'What substance are you recovering from?',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeMedium),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 3,
              minFontSize: 12,
              maxFontSize: AppConstants.fontSizeMedium,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedSubstance,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                ),
                items: _substanceOptions.map((substance) {
                  return DropdownMenuItem(
                    value: substance,
                    child: SafeText(
                      substance[0].toUpperCase() + substance.substring(1),
                      style: const TextStyle(color: Colors.black),
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSubstance = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSobrietyDetailsPage(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelpers.getResponsivePadding(
          context, AppConstants.paddingMedium)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight - 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),
            SafeText(
              'Sobriety Details',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeXXLarge),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            SafeText(
              'Help us track your progress and savings.',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeMedium),
                color: Colors.white.withValues(alpha: .9),
              ),
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            // Sobriety Date
            AutoSizeText(
              'When did you start your sobriety journey?',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              minFontSize: 14,
              maxFontSize: AppConstants.fontSizeLarge,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            GestureDetector(
              onTap: _selectSoberDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingLarge,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusLarge),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SafeText(
                        _selectedSoberDate != null
                            ? '${_selectedSoberDate!.day}/${_selectedSoberDate!.month}/${_selectedSoberDate!.year}'
                            : 'Select date (optional)',
                        style: TextStyle(
                          color: _selectedSoberDate != null
                              ? Colors.black
                              : Colors.grey[600],
                          fontSize: ResponsiveHelpers.getResponsiveFontSize(
                              context, AppConstants.fontSizeMedium),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            // Usage Frequency
            SafeText(
              'How often did you use?',
              style: TextStyle(
                fontSize: ResponsiveHelpers.getResponsiveFontSize(
                    context, AppConstants.fontSizeLarge),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: DropdownButtonFormField<UsageFrequency>(
                value: _selectedUsageFrequency,
                isExpanded: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                    vertical: AppConstants.paddingMedium,
                  ),
                ),
                items: UsageFrequency.values.map((frequency) {
                  return DropdownMenuItem(
                    value: frequency,
                    child: SafeText(
                      frequency.label,
                      style: const TextStyle(color: Colors.black),
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedUsageFrequency = value;
                    });
                  }
                },
              ),
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            // Daily Cost
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeText(
                  'How much did you spend per day on the days you actually used?',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeLarge),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 4),
                SafeText(
                  '(optional)',
                  style: TextStyle(
                    fontSize: ResponsiveHelpers.getResponsiveFontSize(
                        context, AppConstants.fontSizeSmall),
                    color: Colors.white.withValues(alpha: .7),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingMedium)),
            TextField(
              controller: _dailyCostController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                hintText: 'Enter daily cost',
                prefixText: '\$ ',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            SizedBox(
                height: ResponsiveHelpers.getResponsivePadding(
                    context, AppConstants.paddingLarge)),

            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .1),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusLarge),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: SafeText(
                      'We\'ll calculate your savings based on your usage frequency and daily spending.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .9),
                        fontSize: ResponsiveHelpers.getResponsiveFontSize(
                            context, AppConstants.fontSizeMedium),
                      ),
                      maxLines: 4,
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
