import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth_service.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  final bool isSetup;

  const PinScreen({super.key, required this.isSetup});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String? _confirmPin;
  String _error = '';

  void _onKeyPress(String value) {
    setState(() {
      if (_pin.length < 4) {
        _pin += value;
        _error = '';
      }
    });

    if (_pin.length == 4) {
      _handleSubmit();
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _error = '';
      });
    }
  }

  Future<void> _handleSubmit() async {
    final authService = context.read<AuthService>();

    if (widget.isSetup) {
      if (_confirmPin == null) {
        // First step of setup: Check validation or move to confirm
        setState(() {
          _confirmPin = _pin;
          _pin = '';
        });
      } else {
        // Second step: Confirm
        if (_pin == _confirmPin) {
          await authService.setPin(_pin);
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          }
        } else {
          setState(() {
            _error = "PINs don't match. Try again.";
            _pin = '';
            _confirmPin = null; // Reset to start
          });
        }
      }
    } else {
      // Unlock mode
      final isValid = await authService.verifyPin(_pin);
      if (isValid) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      } else {
        setState(() {
          _error = "Incorrect PIN";
          _pin = '';
          // Shake animation hook could go here
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConfirming = widget.isSetup && _confirmPin != null;
    final title = widget.isSetup
        ? (isConfirming ? 'Confirm PIN' : 'Create PIN')
        : 'Enter PIN';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.lock_rounded, size: 48),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.isSetup && !isConfirming)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'This PIN identifies you. PassKey cannot recover your data if you forget it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
                ),
              ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final filled = index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                );
              }),
            ),
            SizedBox(
              height: 24,
              child: Text(_error, style: const TextStyle(color: Colors.red)),
            ),
            const Spacer(),
            Expanded(flex: 5, child: _buildNumPad()),
          ],
        ),
      ),
    );
  }

  Widget _buildNumPad() {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['', '0', 'del']),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          if (key.isEmpty) return const SizedBox(width: 80);
          return SizedBox(
            width: 80,
            height: 80,
            child: key == 'del'
                ? IconButton(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace_outlined),
                  )
                : TextButton(
                    onPressed: () => _onKeyPress(key),
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      textStyle: const TextStyle(fontSize: 28),
                    ),
                    child: Text(key),
                  ),
          );
        }).toList(),
      ),
    );
  }
}
