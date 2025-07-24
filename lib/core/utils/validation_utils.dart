class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password validation
  static bool isValidPassword(String password) {
    // At least 8 characters, with at least one letter and one number
    return RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$',
    ).hasMatch(password);
  }

  // Phone number validation
  static bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phoneNumber);
  }

  // URL validation
  static bool isValidUrl(String url) {
    return RegExp(
      r'^https?:\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
    ).hasMatch(url);
  }

  // Name validation
  static bool isValidName(String name) {
    return name.trim().isNotEmpty && name.trim().length >= 2;
  }

  // Event title validation
  static bool isValidEventTitle(String title) {
    return title.trim().isNotEmpty && title.trim().length >= 3;
  }

  // Event description validation
  static bool isValidEventDescription(String description) {
    return description.trim().length <= 1000;
  }

  // Duration validation (in minutes)
  static bool isValidDuration(int minutes) {
    return minutes > 0 && minutes <= 1440; // Max 24 hours
  }

  // Date validation
  static bool isValidDate(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.isAfter(now.subtract(const Duration(days: 1)));
  }

  // Time validation
  static bool isValidTimeRange(DateTime startTime, DateTime endTime) {
    return endTime.isAfter(startTime);
  }

  // Get email validation error message
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Please enter a valid email';
    return null;
  }

  // Get password validation error message
  static String? getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!isValidPassword(password)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  // Get name validation error message
  static String? getNameError(String name) {
    if (name.trim().isEmpty) return 'Name is required';
    if (!isValidName(name)) return 'Name must be at least 2 characters';
    return null;
  }

  // Get event title validation error message
  static String? getEventTitleError(String title) {
    if (title.trim().isEmpty) return 'Event title is required';
    if (!isValidEventTitle(title))
      return 'Event title must be at least 3 characters';
    return null;
  }

  // Get event description validation error message
  static String? getEventDescriptionError(String description) {
    if (!isValidEventDescription(description)) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }
}
