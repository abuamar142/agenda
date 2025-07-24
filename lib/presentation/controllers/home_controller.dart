import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeController extends GetxController {
  final googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/calendar'],
  );

  var isSignedIn = false.obs;
  GoogleSignInAccount? currentUser;

  Future<void> handleSignIn() async {
    try {
      currentUser = await googleSignIn.signIn();
      isSignedIn.value = currentUser != null;
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  Future<void> handleSignOut() async {
    await googleSignIn.signOut();
    currentUser = null;
    isSignedIn.value = false;
  }
}
