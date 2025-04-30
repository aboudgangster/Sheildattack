import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class SecureNotesScreen extends StatefulWidget {
  const SecureNotesScreen({super.key});

  @override
  State<SecureNotesScreen> createState() => _SecureNotesScreenState();
}

class _SecureNotesScreenState extends State<SecureNotesScreen> {
  List<String> _notes = [];
  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 char key
  final _iv = encrypt.IV.fromLength(16);

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedNotes = prefs.getStringList('secure_notes') ?? [];
    final decrypted = encryptedNotes.map(_decrypt).toList();
    setState(() {
      _notes = decrypted;
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encrypted = _notes.map(_encrypt).toList();
    await prefs.setStringList('secure_notes', encrypted);
  }

  String _encrypt(String text) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(text, iv: _iv);
    return encrypted.base64;
  }

  String _decrypt(String base64Text) {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decrypt64(base64Text, iv: _iv);
      return decrypted;
    } catch (_) {
      return '[Corrupted Note]';
    }
  }

  void _addNote() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Note"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter note..."),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _notes.add(controller.text);
                    _saveNotes();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNote,
          )
        ],
      ),
      body: _notes.isEmpty
          ? const Center(child: Text("No notes found"))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(_notes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
                  ),
                ),
              ),
            ),
    );
  }
}
