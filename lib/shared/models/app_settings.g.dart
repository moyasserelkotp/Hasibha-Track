// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 2;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      currency: fields[0] == null ? 'USD' : fields[0] as String,
      dateFormat: fields[1] == null ? 'MM/dd/yyyy' : fields[1] as String,
      theme: fields[2] == null ? 'system' : fields[2] as String,
      firstDayOfWeek: fields[3] == null ? 1 : fields[3] as int,
      language: fields[4] == null ? 'en' : fields[4] as String,
      enableNotifications: fields[5] == null ? true : fields[5] as bool,
      enableHapticFeedback: fields[6] == null ? true : fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.currency)
      ..writeByte(1)
      ..write(obj.dateFormat)
      ..writeByte(2)
      ..write(obj.theme)
      ..writeByte(3)
      ..write(obj.firstDayOfWeek)
      ..writeByte(4)
      ..write(obj.language)
      ..writeByte(5)
      ..write(obj.enableNotifications)
      ..writeByte(6)
      ..write(obj.enableHapticFeedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
