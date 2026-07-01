// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      emergencyContact: json['emergencyContact'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'emergencyContact': instance.emergencyContact,
      'profilePictureUrl': instance.profilePictureUrl,
    };
