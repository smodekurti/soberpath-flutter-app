import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../config/theme_extensions.dart';
import '../utils/responsive_helpers.dart' hide SafeText;

class SobrietyCounterCard extends StatelessWidget {
  const SobrietyCounterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, provider, child) {
        final stats = provider.sobrietyStats;

        return Container(
          margin: EdgeInsets.only(top: context.spacing.large),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.colors.primary, context.colors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(context.borders.large),
              ),
              padding: EdgeInsets.all(context.spacing.large),
              child: Column(
                children: [
                  Text(
                    'Days Sober',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.headlineSmall),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: context.spacing.medium),

                  Text(
                    stats?.days.toString() ?? '0',
                    style: TextStyle(
                      fontSize: ResponsiveHelpers.getResponsiveFontSize(
                          context, context.typography.displayLarge),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Removed the SizedBox and Text widget below this line
                  // const SizedBox(height: context.spacing.small),
                  //
                  // Text(
                  //   stats != null
                  //       ? '${stats.days} day${stats.days != 1 ? 's' : ''}'
                  //       : '0 days',
                  //   style: TextStyle(
                  //     fontSize: context.typography.titleLarge,
                  //     color: Colors.white.withOpacity(0.9),
                  //   ),
                  // ),

                  SizedBox(height: context.spacing.large),

                  if (!provider.hasSoberDate)
                    ElevatedButton(
                      onPressed: () => _showDatePicker(context, provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1),
                      ),
                      child: const Text('Set Sobriety Date', maxLines: 1, overflow: TextOverflow.ellipsis),
                    )
                  else
                    OutlinedButton(
                      onPressed: () => _showDatePicker(context, provider),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text('Change Date',
                          style: TextStyle(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
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
            colorScheme: ColorScheme.light(
              primary: context.colors.primary,
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
          SnackBar(
            content: const Text('Sobriety date updated!'),
            backgroundColor: context.colors.secondary,
          ),
        );
      }
    }
  }
}
