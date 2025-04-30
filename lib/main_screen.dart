import 'dart:ui';
import 'package:flutter/material.dart';
import 'secure_notes_screen.dart';
import 'file_encryption_screen.dart';
import 'breach_scanner_screen.dart';
import 'password_generator_screen.dart';
import 'encrypted_vault_screen.dart';
import 'pin_screen.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void navigateWithSlide(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
    );
  }

  Widget buildModuleCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ripple background effect
          AnimatedBackground(),
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  buildModuleCard(
                    context: context,
                    title: 'Secure Notes',
                    icon: Icons.note_alt,
                    color: Colors.greenAccent,
                    onTap: () => navigateWithSlide(context, const SecureNotesScreen()),
                  ),
                  buildModuleCard(
                    context: context,
                    title: 'File Encryption',
                    icon: Icons.lock_outline,
                    color: Colors.blueAccent,
                    onTap: () => navigateWithSlide(context,  FileEncryptionScreen()),
                  ),
                  buildModuleCard(
                    context: context,
                    title: 'Breach Scanner',
                    icon: Icons.shield,
                    color: Colors.deepPurpleAccent,
                    onTap: () => navigateWithSlide(context,  BreachScannerScreen()),
                  ),
                  buildModuleCard(
                    context: context,
                    title: 'Password Generator',
                    icon: Icons.password,
                    color: Colors.orangeAccent,
                    onTap: () => navigateWithSlide(context,  PasswordGeneratorScreen()),
                  ),
                  buildModuleCard(
                    context: context,
                    title: 'Encrypted Vault',
                    icon: Icons.folder_zip,
                    color: Colors.pinkAccent,
                    onTap: () => navigateWithSlide(context,  EncryptedVaultScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});
  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: -0.2, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation2 = Tween<double>(begin: 1.2, end: -0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * _animation1.value,
              left: MediaQuery.of(context).size.width * 0.25,
              child: _circle(Colors.greenAccent.withOpacity(0.25)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * _animation2.value,
              left: MediaQuery.of(context).size.width * 0.7,
              child: _circle(Colors.blueAccent.withOpacity(0.25)),
            ),
          ],
        );
      },
    );
  }

  Widget _circle(Color color) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
