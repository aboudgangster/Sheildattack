import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class EncryptedVaultScreen extends StatefulWidget {
  @override
  _EncryptedVaultScreenState createState() => _EncryptedVaultScreenState();
}

class _EncryptedVaultScreenState extends State<EncryptedVaultScreen> {
  List<String> encryptedFileNames = [];

  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  final _iv = encrypt.IV.fromLength(16);

  Future<String> getVaultDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory('${dir.path}/vault');
    if (!vaultDir.existsSync()) vaultDir.createSync(recursive: true);
    return vaultDir.path;
  }

  Future<void> pickAndEncryptFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final inputFile = File(result.files.single.path!);
      final bytes = await inputFile.readAsBytes();

      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final encrypted = encrypter.encryptBytes(bytes, iv: _iv);

      final fileName = result.files.single.name + '.enc';
      final vaultPath = await getVaultDirectory();
      final outFile = File('$vaultPath/$fileName');

      await outFile.writeAsBytes(encrypted.bytes);

      setState(() => encryptedFileNames.add(fileName));
    }
  }

  Future<void> decryptAndOpen(String fileName) async {
    final vaultPath = await getVaultDirectory();
    final file = File('$vaultPath/$fileName');
    final encryptedBytes = await file.readAsBytes();

    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decryptBytes(
        encrypt.Encrypted(encryptedBytes),
        iv: _iv,
      );

      final decryptedFile = File('$vaultPath/${fileName.replaceAll(".enc", "")}');
      await decryptedFile.writeAsBytes(decrypted);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Decrypted and saved: ${decryptedFile.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Decryption error: ${e.toString()}")),
      );
    }
  }

  Future<void> deleteEncryptedFile(String fileName) async {
    final vaultPath = await getVaultDirectory();
    final file = File('$vaultPath/$fileName');
    if (await file.exists()) {
      await file.delete();
      setState(() => encryptedFileNames.remove(fileName));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted: $fileName")),
      );
    }
  }

  Future<void> loadEncryptedFiles() async {
    final path = await getVaultDirectory();
    final dir = Directory(path);
    final files = dir.listSync().whereType<File>().toList();
    setState(() {
      encryptedFileNames = files.map((f) => f.path.split('/').last).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadEncryptedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encrypted Vault"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.indigo.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.lock, color: Colors.white),
              label: Text("Encrypt File", style: TextStyle(fontSize: 16)),
              onPressed: pickAndEncryptFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade800,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: encryptedFileNames.isEmpty
                  ? Center(
                      child: Text("No encrypted files yet.",
                          style: TextStyle(color: Colors.white70, fontSize: 16)),
                    )
                  : ListView.builder(
                      itemCount: encryptedFileNames.length,
                      itemBuilder: (context, index) {
                        final fileName = encryptedFileNames[index];
                        return Card(
                          color: Colors.black.withOpacity(0.2),
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(fileName,
                                style: TextStyle(color: Colors.white, fontSize: 14)),
                            trailing: Wrap(
                              spacing: 12,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.lock_open, color: Colors.greenAccent),
                                  onPressed: () => decryptAndOpen(fileName),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => deleteEncryptedFile(fileName),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
