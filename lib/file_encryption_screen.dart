import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'encryption_helper.dart'; // Update this to support binary methods

class FileEncryptionScreen extends StatefulWidget {
  @override
  _FileEncryptionScreenState createState() => _FileEncryptionScreenState();
}

class _FileEncryptionScreenState extends State<FileEncryptionScreen> {
  String? statusMessage;

  Future<void> pickAndEncryptFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsBytes();

        final encrypted = EncryptionHelper.encryptBytes(content);
        final fileName = file.uri.pathSegments.last;
        final encryptedFile = File('${file.parent.path}/$fileName.enc');
        await encryptedFile.writeAsBytes(encrypted);

        setState(() {
          statusMessage = 'File encrypted: ${encryptedFile.path}';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'Encryption failed: $e';
      });
    }
  }

  Future<void> pickAndDecryptFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final encryptedData = await file.readAsBytes();

        final decrypted = EncryptionHelper.decryptBytes(encryptedData);
        final fileName = file.uri.pathSegments.last.replaceAll('.enc', '');
        final decryptedFile = File('${file.parent.path}/decrypted_$fileName');
        await decryptedFile.writeAsBytes(decrypted);

        setState(() {
          statusMessage = 'File decrypted: ${decryptedFile.path}';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'Decryption failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Encryption', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: const Icon(Icons.lock_outline, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock),
                  label: const Text("Encrypt File"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: pickAndEncryptFile,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock_open),
                  label: const Text("Decrypt File"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: pickAndDecryptFile,
                ),
                const SizedBox(height: 30),
                if (statusMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusMessage!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
