import 'package:firebase_auth/firebase_auth.dart';

String firebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    // LOGIN
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Email atau password salah.';

    // REGISTER
    case 'email-already-in-use':
      return 'Email sudah terdaftar.';

    // UMUM
    case 'invalid-email':
      return 'Format email tidak valid.';

    case 'weak-password':
      return 'Password minimal 6 karakter.';

    case 'user-disabled':
      return 'Akun telah dinonaktifkan.';

    case 'network-request-failed':
      return 'Tidak ada koneksi internet.';

    case 'too-many-requests':
      return 'Terlalu banyak percobaan. Coba lagi beberapa saat.';

    default:
      return e.message ?? 'Terjadi kesalahan.';
  }
}
