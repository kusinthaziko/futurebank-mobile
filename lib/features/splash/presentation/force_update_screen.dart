import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class ForceUpdateScreen extends StatelessWidget {
  final String storeUrl;
  const ForceUpdateScreen({super.key, required this.storeUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary700, primary500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: radius16,
                ),
                child: const Center(child: Text('f', style: TextStyle(
                  fontFamily: 'ClashDisplay', fontSize: 40,
                  fontWeight: FontWeight.w700, color: Colors.white,
                ))),
              ),
              const SizedBox(height: sp32),
              Text('Update Required',
                  style: AppTextStyles.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: sp12),
              Text(
                'A new version of futureBank is available. '
                'Please update to continue using the app.',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: sp32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(storeUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary500,
                    foregroundColor: white,
                    padding: const EdgeInsets.symmetric(vertical: sp16),
                    shape: RoundedRectangleBorder(borderRadius: radiusPill),
                  ),
                  child: Text('Update Now', style: AppTextStyles.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
