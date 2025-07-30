import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: AppConstants.lightBlue,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
            border: const Border(
              left: BorderSide(
                color: AppConstants.blueAccent,
                width: 4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.blueAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: const Icon(
                      Icons.format_quote,
                      color: AppConstants.blueAccent,
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: AppConstants.paddingMedium),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.todaysQuote,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontStyle: FontStyle.italic,
                            color: AppConstants.blueAccent,
                            height: 1.4,
                          ),
                          maxLines: null, // Allow unlimited lines
                          overflow: TextOverflow.visible, // Ensure text doesn't get cut off
                        ),
                        
                        const SizedBox(height: AppConstants.paddingSmall),
                        
                        Text(
                          'Daily Inspiration',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.blueAccent.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}