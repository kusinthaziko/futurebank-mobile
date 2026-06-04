String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Password must be at least 8 characters';
  return null;
}

String? validateAmount(String? value) {
  if (value == null || value.trim().isEmpty) return 'Amount is required';
  final amount = double.tryParse(value.trim());
  if (amount == null) return 'Enter a valid number';
  if (amount <= 0) return 'Amount must be positive';
  final parts = value.trim().split('.');
  if (parts.length == 2 && parts[1].length > 2) {
    return 'Maximum 2 decimal places';
  }
  return null;
}

String? validateStudentId(String? value) {
  if (value == null || value.trim().isEmpty) return 'Student ID is required';
  final idRegex = RegExp(r'^[a-zA-Z0-9/]+$');
  if (!idRegex.hasMatch(value.trim())) {
    return 'Only letters, numbers, and / allowed';
  }
  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName is required';
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) return 'Phone number is required';
  final phoneRegex = RegExp(r'^\+?[\d\s\-()]{7,15}$');
  if (!phoneRegex.hasMatch(value.trim())) return 'Enter a valid phone number';
  return null;
}
