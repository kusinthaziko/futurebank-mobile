import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';

class KycScreen extends ConsumerStatefulWidget {
  const KycScreen({super.key});
  @override
  ConsumerState<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends ConsumerState<KycScreen> {
  String _docType = 'student_card';
  XFile? _image;
  bool _loading = false;
  bool _submitted = false;

  static const _docTypes = [
    ('student_card', 'Student Card', Icons.badge),
    ('national_id', 'National ID', Icons.credit_card),
    ('passport', 'Passport', Icons.book),
  ];

  Future<void> _pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _image = img);
  }

  Future<void> _submit() async {
    if (_image == null) return;
    setState(() => _loading = true);
    // TODO: upload to Cloudinary then submit KYC via GraphQL
    await Future.delayed(const Duration(seconds: 1));
    setState(() { _loading = false; _submitted = true; });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSubmitted();
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Identity')),
      body: Padding(
        padding: const EdgeInsets.all(sp24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('We need to verify your identity to unlock transactions.',
              style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
          const SizedBox(height: sp24),
          Text('Document Type', style: AppTextStyles.labelLarge),
          const SizedBox(height: sp12),
          ..._docTypes.map((d) => RadioListTile<String>(
            value: d.$1, groupValue: _docType,
            onChanged: (v) => setState(() => _docType = v!),
            title: Text(d.$2, style: AppTextStyles.bodyMedium),
            secondary: Icon(d.$3, color: primary500),
            contentPadding: EdgeInsets.zero,
          )),
          const SizedBox(height: sp24),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity, height: 160,
              decoration: BoxDecoration(
                color: primary100, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary300)),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(_image!.path, fit: BoxFit.cover))
                  : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.upload_file, size: 40, color: primary500),
                      const SizedBox(height: sp8),
                      Text('Tap to upload document',
                          style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
                    ]),
            ),
          ),
          const Spacer(),
          FBButton(
            label: 'Submit for Verification',
            onPressed: _image != null ? _submit : null,
            loading: _loading,
          ),
          const SizedBox(height: sp12),
          FBButton(
            label: 'Skip for now',
            variant: FBButtonVariant.ghost,
            onPressed: () => context.go('/home'),
          ),
        ]),
      ),
    );
  }

  Widget _buildSubmitted() => Scaffold(
    body: Center(child: Padding(
      padding: const EdgeInsets.all(sp32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.check_circle, color: success500, size: 80),
        const SizedBox(height: sp16),
        Text('Under Review', style: AppTextStyles.titleLarge),
        const SizedBox(height: sp8),
        Text('We\'ll notify you once verified (usually within 24 hours).',
            style: AppTextStyles.bodyMedium.copyWith(color: gray500),
            textAlign: TextAlign.center),
        const SizedBox(height: sp32),
        FBButton(label: 'Go to Dashboard', onPressed: () => context.go('/home')),
      ]),
    )),
  );
}
