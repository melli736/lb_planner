// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Notification _$$_NotificationFromJson(Map<String, dynamic> json) =>
    _$_Notification(
      id: json['id'] as int,
      payload: json['payload'] as Map<String, dynamic>,
      type: $enumDecode(_$NotifactionTypesEnumMap, json['type']),
      status: $enumDecode(_$NotificationStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$_NotificationToJson(_$_Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payload': instance.payload,
      'type': _$NotifactionTypesEnumMap[instance.type],
      'status': _$NotificationStatusEnumMap[instance.status],
    };

const _$NotifactionTypesEnumMap = {
  NotifactionTypes.invite: 'invite',
};

const _$NotificationStatusEnumMap = {
  NotificationStatus.unread: 'unread',
  NotificationStatus.read: 'read',
};
