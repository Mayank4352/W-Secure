import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/user_profile.freezed.dart';
part 'generated/user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String name,
    @Default('') String email,
    @Default('') String emergencyContact,
    @Default('') String profilePictureUrl,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
