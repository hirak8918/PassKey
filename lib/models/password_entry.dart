import 'package:hive/hive.dart';

part 'password_entry.g.dart';

@HiveType(typeId: 0)
class PasswordEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title; // App or Website Name

  @HiveField(2)
  final String password; // Encrypted password (handled by Hive box encryption, but can be double encrypted if needed)

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String? username; // Optional username/email

  PasswordEntry({
    required this.id,
    required this.title,
    required this.password,
    required this.createdAt,
    this.username,
  });
}
