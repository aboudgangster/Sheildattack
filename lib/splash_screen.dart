import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/pin');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_rounded, size: 100, color: Colors.green.shade800),
              const SizedBox(height: 20),
              Text(
                "ShieldStack",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your All-in-One Cybersecurity Vault",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Colors.green,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
