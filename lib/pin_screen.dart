import 'package:flutter/material.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? errorText;

  void _verifyPin() {
    if (_pinController.text == '1234') {
      Navigator.pushReplacementNamed(context, '/main'); // Update this route name
    } else {
      setState(() {
        errorText = 'Incorrect PIN. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: '1234',
                  hintStyle: const TextStyle(color: Colors.white70),
                  errorText: errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Unlock', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
