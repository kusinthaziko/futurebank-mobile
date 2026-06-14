import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/security_service.dart';

/// Provides the [SecurityService] used for screenshot protection.
final securityServiceProvider = Provider<SecurityService>(
  (_) => SecurityService(),
);
