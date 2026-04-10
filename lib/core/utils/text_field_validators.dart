class TextFieldValidators {
  static String? validateEmail(String? value) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    } else if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return 'Please enter a password';
    }
    if (trimmed.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  static String? funnelName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Funnel name is required';
    }
    final trimmed = value.trim();
    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      return 'Name cannot be only numbers';
    }
    return null;
  }
}
