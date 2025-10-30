// class V {
//   static String? email(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Email is required';
//     final r = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
//     if (!r.hasMatch(v.trim())) return 'Enter a valid email';
//     return null;
//   }
//
//   static String? password(String? v) {
//     if (v == null || v.isEmpty) return 'Password is required';
//     if (v.length < 6) return 'Minimum 6 characters';
//     return null;
//   }
//
//   static String? required(String? v, [String label = 'This field']) {
//     if (v == null || v.trim().isEmpty) return '$label is required';
//     return null;
//   }
//
//   static String? phone(String? v) {
//     if (v == null || v.trim().isEmpty) return 'Contact number is required';
//     if (v.trim().length < 7) return 'Enter a valid phone';
//     return null;
//   }
// }
class V {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final r = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
    if (!r.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  static String? required(String? v, [String label = 'This field']) {
    if (v == null || v.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? phone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Contact number is required';
    if (v.trim().length < 7) return 'Enter a valid phone';
    return null;
  }
}
