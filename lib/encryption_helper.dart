import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  static final _key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  static Uint8List encryptBytes(Uint8List bytes) {
    final encrypted = _encrypter.encryptBytes(bytes, iv: _iv);
    return encrypted.bytes;
  }

  static Uint8List decryptBytes(Uint8List bytes) {
    final decrypted = _encrypter.decryptBytes(Encrypted(bytes), iv: _iv);
    return Uint8List.fromList(decrypted);
  }
}
