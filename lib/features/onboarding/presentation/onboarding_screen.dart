import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/design_system/components/fb_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _slides = [
    (
      Icons.savings,
      'Save together, grow together',
      'Join savings circles with classmates and build financial habits.',
    ),
    (
      Icons.credit_score,
      'Loans in minutes, not days',
      'Apply for micro-loans backed by your savings history.',
    ),
    (
      Icons.verified_user,
      'Your financial future starts here',
      'Build a verifiable financial identity that travels with you.',
    ),
  ];

  Future<void> _next() async {
    if (_page < 2) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await const FlutterSecureStorage().write(
        key: 'onboarding_seen',
        value: 'true',
      );
      if (mounted) context.go('/auth/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () async {
                  await const FlutterSecureStorage().write(
                    key: 'onboarding_seen',
                    value: 'true',
                  );
                  if (context.mounted) context.go('/auth/login');
                },
                child: Text(
                  'Skip',
                  style: AppTextStyles.labelMedium.copyWith(color: gray500),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.all(sp32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: primary100,
                            borderRadius: radius24,
                          ),
                          child: Icon(s.$1, size: 60, color: primary500),
                        ),
                        const SizedBox(height: sp32),
                        Text(
                          s.$2,
                          style: AppTextStyles.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: sp12),
                        Text(
                          s.$3,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: gray500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(sp24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: sp4),
                        width: _page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? primary500 : gray300,
                          borderRadius: radiusPill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: sp24),
                  FBButton(
                    label: _page == 2 ? 'Get Started' : 'Next',
                    onPressed: _next,
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
