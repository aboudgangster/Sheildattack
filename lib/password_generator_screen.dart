import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() => _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  int length = 12;
  bool includeUppercase = true;
  bool includeLowercase = true;
  bool includeNumbers = true;
  bool includeSymbols = true;
  String generatedPassword = '';

  void generatePassword() {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?/~';

    String chars = '';
    if (includeLowercase) chars += lowercase;
    if (includeUppercase) chars += uppercase;
    if (includeNumbers) chars += numbers;
    if (includeSymbols) chars += symbols;

    if (chars.isEmpty) {
      setState(() => generatedPassword = 'Select at least one character set.');
      return;
    }

    final rand = Random.secure();
    final password = List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();

    setState(() => generatedPassword = password);
  }

  void copyPassword() {
    Clipboard.setData(ClipboardData(text: generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password copied!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Password Generator"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.tealAccent, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.password, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text("Length: $length", style: const TextStyle(color: Colors.white, fontSize: 16)),
            Slider(
              value: length.toDouble(),
              min: 6,
              max: 32,
              divisions: 26,
              label: length.toString(),
              onChanged: (value) => setState(() => length = value.toInt()),
            ),
            CheckboxListTile(
              title: const Text("Include Uppercase Letters", style: TextStyle(color: Colors.white)),
              value: includeUppercase,
              onChanged: (val) => setState(() => includeUppercase = val!),
            ),
            CheckboxListTile(
              title: const Text("Include Lowercase Letters", style: TextStyle(color: Colors.white)),
              value: includeLowercase,
              onChanged: (val) => setState(() => includeLowercase = val!),
            ),
            CheckboxListTile(
              title: const Text("Include Numbers", style: TextStyle(color: Colors.white)),
              value: includeNumbers,
              onChanged: (val) => setState(() => includeNumbers = val!),
            ),
            CheckboxListTile(
              title: const Text("Include Symbols", style: TextStyle(color: Colors.white)),
              value: includeSymbols,
              onChanged: (val) => setState(() => includeSymbols = val!),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Generate"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: generatePassword,
            ),
            const SizedBox(height: 20),
            SelectableText(
              generatedPassword,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (generatedPassword.isNotEmpty && !generatedPassword.startsWith("Select"))
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text("Copy"),
                onPressed: copyPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[800],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
