import '../core/constants/app_constants.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final bool isGuest;
  final bool isPremium;
  final int dailyUsageBytes;
  final DateTime? premiumExpiry;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.isGuest = false,
    this.isPremium = false,
    this.dailyUsageBytes = 0,
    this.premiumExpiry,
  });

  int get dailyLimitBytes => isPremium ? -1 : AppConstants.freeDailyDataLimitBytes;

  double get usagePercentage {
    if (isPremium) return 0.0;
    if (dailyLimitBytes <= 0) return 0.0;
    return (dailyUsageBytes / dailyLimitBytes).clamp(0.0, 1.0);
  }

  bool get hasExceededDailyLimit {
    if (isPremium) return false;
    return dailyUsageBytes >= dailyLimitBytes;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? isGuest,
    bool? isPremium,
    int? dailyUsageBytes,
    DateTime? premiumExpiry,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isGuest: isGuest ?? this.isGuest,
      isPremium: isPremium ?? this.isPremium,
      dailyUsageBytes: dailyUsageBytes ?? this.dailyUsageBytes,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'isGuest': isGuest,
      'isPremium': isPremium,
      'dailyUsageBytes': dailyUsageBytes,
      'premiumExpiry': premiumExpiry?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Barua User',
      isGuest: json['isGuest'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      dailyUsageBytes: (json['dailyUsageBytes'] as num?)?.toInt() ?? 0,
      premiumExpiry: json['premiumExpiry'] != null ? DateTime.tryParse(json['premiumExpiry'] as String) : null,
    );
  }

  factory UserModel.guest() {
    return const UserModel(
      id: 'guest_user',
      email: 'guest@baruavpn.com',
      displayName: 'Guest Explorer',
      isGuest: true,
      isPremium: false,
    );
  }
}
