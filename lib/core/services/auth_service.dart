import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorev_yonetimi/core/errors/app_exceptions.dart';

/// Firebase Kimlik Doğrulama işlemlerini yöneten servis sınıfı
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mevcut oturum açmış kullanıcıyı döndürür
  User? get currentUser => _auth.currentUser;

  /// Kimlik doğrulama durumundaki değişiklikleri (giriş/çıkış) dinleyen akış
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// E-posta ve şifre kullanarak giriş yapar
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Giriş validasyon kontrolleri
      if (email.trim().isEmpty) {
        throw const ValidationException('E-posta adresi boş olamaz');
      }
      if (password.trim().isEmpty) {
        throw const ValidationException('Şifre boş olamaz');
      }

      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        // Firebase'den gelen hata kodlarını kullanıcı dostu mesajlara dönüştürür
        case 'user-not-found':
          message = 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          message = 'Şifre yanlış';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        case 'user-disabled':
          message = 'Bu kullanıcı hesabı devre dışı bırakılmış';
          break;
        case 'too-many-requests':
          message =
              'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin';
          break;
        case 'network-request-failed':
          message = 'Ağ bağlantısı hatası. İnternet bağlantınızı kontrol edin';
          break;
        case 'configuration-not-found':
        case 'missing-configuration':
          message =
              'Firebase Authentication yapılandırması eksik. Lütfen Firebase Console\'da Email/Password authentication metodunu etkinleştirin.';
          break;
        default:
          message = 'Giriş yapılırken bir hata oluştu: ${e.message ?? e.code}';
      }
      throw AuthException(message, e);
    } on ValidationException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}', e);
    }
  }

  /// Yeni bir kullanıcı kaydı oluşturur
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Kayıt validasyon kontrolleri
      if (email.trim().isEmpty) {
        throw const ValidationException('E-posta adresi boş olamaz');
      }
      if (password.trim().isEmpty) {
        throw const ValidationException('Şifre boş olamaz');
      }
      if (password.length < 6) {
        throw const ValidationException('Şifre en az 6 karakter olmalıdır');
      }
      if (displayName.trim().isEmpty) {
        throw const ValidationException('İsim boş olamaz');
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Kullanıcının görünen ismini günceller
      await credential.user?.updateDisplayName(displayName.trim());
      await credential.user?.reload();

      return credential;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'Şifre çok zayıf. Daha güçlü bir şifre seçin';
          break;
        case 'email-already-in-use':
          message = 'Bu e-posta adresi zaten kullanılıyor';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        case 'operation-not-allowed':
          message = 'Bu işlem şu anda izin verilmiyor';
          break;
        case 'network-request-failed':
          message = 'Ağ bağlantısı hatası. İnternet bağlantınızı kontrol edin';
          break;
        default:
          message = 'Kayıt olurken bir hata oluştu: ${e.message ?? e.code}';
      }
      throw AuthException(message, e);
    } on ValidationException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AuthException('Beklenmeyen bir hata oluştu: ${e.toString()}', e);
    }
  }

  /// Oturumu kapatır
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(
        'Çıkış yapılırken bir hata oluştu: ${e.toString()}',
        e,
      );
    }
  }
}
