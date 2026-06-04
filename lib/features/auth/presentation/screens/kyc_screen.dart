import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../data/cloudinary_service.dart';
import '../../data/graphql/auth_mutations.dart';
import '../../../../core/design_system/components/fb_button.dart';
import '../../../../core/design_system/tokens/colors.dart';
import '../../../../core/design_system/tokens/dimensions.dart';
import '../../../../core/design_system/tokens/typography.dart';
import '../../../../core/widgets/error_view.dart';

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
  String? _error;

  static const _docTypes = [
    ('student_card', 'Student Card', Icons.badge),
    ('national_id', 'National ID', Icons.credit_card),
    ('passport', 'Passport', Icons.book),
  ];

  static const _kycLevels = [
    ('Level 0 — View Only', 'Browse the app, see your financial health score.'),
    ('Level 1 — Basic Access',
        'Send money within your institution, join savings circles.'),
    ('Level 2 — Full Access',
        'Withdraw, apply for loans, and use all features.'),
  ];

  Future<void> _pickImage(ImageSource source) async {
    final img = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (img != null) setState(() => _image = img);
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(sp16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: primary500),
                title: const Text('Take Photo'),
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: primary500),
                title: const Text('Choose from Gallery'),
                onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_image == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final publicId = await CloudinaryService.uploadImage(_image!.path);
      if (publicId == null) throw Exception('Failed to upload image to Cloudinary');
      await AuthMutations.submitKYC(
        ref,
        documentType: _docType,
        cloudinaryPublicId: publicId,
      );
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      setState(() => _error = ErrorView.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSubmitted();
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Identity')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(sp24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why KYC?', style: AppTextStyles.titleLarge),
            const SizedBox(height: sp8),
            Text('We need to verify your identity to prevent fraud and '
                'unlock higher transaction limits.',
                style: AppTextStyles.bodyMedium.copyWith(color: gray500)),
            const SizedBox(height: sp16),
            ..._kycLevels.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: sp12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8, height: 8, margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                        color: primary500, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: sp12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.$1, style: AppTextStyles.labelLarge),
                        Text(l.$2,
                            style: AppTextStyles.caption.copyWith(color: gray500)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: sp16),
            const Text('Document Type', style: AppTextStyles.labelLarge),
            const SizedBox(height: sp12),
            Wrap(
              spacing: sp8,
              runSpacing: sp8,
              children: _docTypes.map((d) => ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(d.$3, size: 18, color: _docType == d.$1 ? white : primary500),
                      const SizedBox(width: sp8),
                    Text(d.$2),
                  ],
                ),
                selected: _docType == d.$1,
                selectedColor: primary500,
                labelStyle: TextStyle(
                  color: _docType == d.$1 ? white : gray700,
                ),
                onSelected: (_) => setState(() => _docType = d.$1),
              )).toList(),
            ),
            const SizedBox(height: sp24),
            GestureDetector(
              onTap: _showImageSourceSheet,
              child: Container(
                width: double.infinity, height: 180,
                decoration: BoxDecoration(
                  color: primary100,
                  borderRadius: radius16,
                  border: Border.all(color: primary300)),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: radius16,
                        child: Image.network(_image!.path, fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file, size: 40, color: primary500),
                          const SizedBox(height: sp8),
                          Text('Tap to upload document',
                              style: AppTextStyles.bodyMedium.copyWith(color: primary500)),
                        ],
                      ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: sp12),
              Text(_error!, style: AppTextStyles.caption.copyWith(color: error500)),
            ],
            const SizedBox(height: sp24),
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
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitted() => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(sp32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: success500, size: 80),
            const SizedBox(height: sp16),
            const Text('Under Review', style: AppTextStyles.titleLarge),
            const SizedBox(height: sp8),
            Text(
              "We'll notify you once verified (usually within 24 hours).",
              style: AppTextStyles.bodyMedium.copyWith(color: gray500),
              textAlign: TextAlign.center),
            const SizedBox(height: sp32),
            FBButton(
              label: 'Go to Dashboard',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    ),
  );
}
