import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../constants/app_constants.dart';

class SobrietyCounterCard extends StatelessWidget {
  const SobrietyCounterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final stats = provider.sobrietyStats;

        return Container(
          margin: const EdgeInsets.only(top: AppConstants.paddingLarge),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppConstants.purpleGradient,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusXLarge),
              ),
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  const Text(
                    'Days Sober',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  Text(
                    stats?.days.toString() ?? '0',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeDisplay,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Removed the SizedBox and Text widget below this line
                  // const SizedBox(height: AppConstants.paddingSmall),
                  //
                  // Text(
                  //   stats != null
                  //       ? '${stats.days} day${stats.days != 1 ? 's' : ''}'
                  //       : '0 days',
                  //   style: TextStyle(
                  //     fontSize: AppConstants.fontSizeLarge,
                  //     color: Colors.white.withOpacity(0.9),
                  //   ),
                  // ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  if (!provider.hasSoberDate)
                    ElevatedButton(
                      onPressed: () => _showDatePicker(context, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      child: const Text('Set Sobriety Date'),
                    )
                  else
                    OutlinedButton(
                      onPressed: () => _showDatePicker(context, provider),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Change Date'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker(
      BuildContext context, AppStateProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: provider.userProfile?.soberDate ?? DateTime.now(),
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

    if (picked != null) {
      await provider.updateSoberDate(picked);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sobriety date updated!'),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    }
  }
}
