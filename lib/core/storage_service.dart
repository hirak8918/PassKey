import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/password_entry.dart';

class StorageService {
  static const _hiveKey = 'hive_encryption_key';
  static const _boxName = 'passwords';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Box<PasswordEntry>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PasswordEntryAdapter());

    final encryptionKey = await _getEncryptionKey();

    _box = await Hive.openBox<PasswordEntry>(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<Uint8List> _getEncryptionKey() async {
    String? keyString = await _secureStorage.read(key: _hiveKey);

    if (keyString == null) {
      final key = Hive.generateSecureKey();
      await _secureStorage.write(key: _hiveKey, value: base64UrlEncode(key));
      return Uint8List.fromList(key);
    } else {
      return base64Url.decode(keyString);
    }
  }

  List<PasswordEntry> getAllPasswords() {
    if (_box == null) return [];
    return _box!.values.toList();
  }

  Future<void> savePassword(PasswordEntry entry) async {
    if (_box == null) return;
    await _box!.put(entry.id, entry);
  }

  Future<void> deletePassword(String id) async {
    if (_box == null) return;
    await _box!.delete(id);
  }

  Future<void> deleteAll() async {
    if (_box == null) return;
    await _box!.clear();
  }
}
