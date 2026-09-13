import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInResult {
  final String idToken;
  final String? photoUrl;

  GoogleSignInResult({required this.idToken, this.photoUrl});
}

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );

  Future<GoogleSignInResult?> signIn() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    if (auth.idToken == null) return null;

    return GoogleSignInResult(
      idToken: auth.idToken!,
      photoUrl: account.photoUrl,
    );
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
