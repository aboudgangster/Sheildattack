import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class BreachScannerScreen extends StatefulWidget {
  @override
  _BreachScannerScreenState createState() => _BreachScannerScreenState();
}

class _BreachScannerScreenState extends State<BreachScannerScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> breachedData = [];
  String? result;

  @override
  void initState() {
    super.initState();
    loadBreachedData();
  }

  Future<void> loadBreachedData() async {
    final data = await rootBundle.loadString('assets/breached_data.txt');
    setState(() {
      breachedData = data.split('\n').map((e) => e.trim().toLowerCase()).toList();
    });
  }

  void scanEmail() {
    final input = _controller.text.trim().toLowerCase();
    if (input.isEmpty) return;

    setState(() {
      result = breachedData.contains(input)
          ? '⚠️ This email was found in a breach!'
          : '✅ Safe! No match found.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Breach Scanner'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.deepOrangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.white),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter email or username",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text("Scan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: scanEmail,
              ),
              const SizedBox(height: 30),
              if (result != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    result!,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
