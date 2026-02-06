import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static const _pinKey = 'user_pin_hash';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _hasPin = false;
  bool get hasPin => _hasPin;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AuthService() {
    _checkPinExists();
  }

  Future<void> _checkPinExists() async {
    final pinHash = await _secureStorage.read(key: _pinKey);
    _hasPin = pinHash != null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _secureStorage.write(key: _pinKey, value: hash);
    _hasPin = true;
    // Auto-login after setting PIN
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(key: _pinKey);
    if (storedHash == null) return false;

    final inputHash = _hashPin(pin);
    if (storedHash == inputHash) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  String _hashPin(String pin) {
    // Simple SHA-256 hash
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  // For debugging/reset
  Future<void> clearAll() async {
    await _secureStorage.delete(key: _pinKey);
    _hasPin = false;
    _isAuthenticated = false;
    notifyListeners();
  }
}
