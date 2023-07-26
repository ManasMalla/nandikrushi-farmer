import 'package:nandikrushi_farmer/data/repository/online_user_repository.dart';
import 'package:nandikrushi_farmer/domain/enum/user_authentication_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repository/local_user_repository.dart';

class LoginUseCase {
  final OnlineUserRepository onlineUserRepository;
  final LocalUserRepository localUserRepository;
  const LoginUseCase(
      {required this.localUserRepository, required this.onlineUserRepository});

  UserAuthenticationState isUserLoggedIn() {
    final doesUserDataExistOnLocal =
        localUserRepository.checkIfUserIdExists().entries.first.key ==
            UserAuthStatus.verified;
    final doesFirebaseUserExist = FirebaseAuth.instance.currentUser != null;
    if (doesFirebaseUserExist && doesUserDataExistOnLocal) {
      /// Data of the user exists and the user signed in with phone number
      return UserAuthenticationState.phone;
    } else {
      if (!doesUserDataExistOnLocal) {
        if (doesFirebaseUserExist) {
          /// Firebase logged in but maybe not registered or data didn't save to SharedPref
          return UserAuthenticationState.firebase;
        } else {
          /// New user
          return UserAuthenticationState.none;
        }
      } else {
        /// Logged in with mail
        return UserAuthenticationState.email;
      }
    }
  }

  void saveUserToLocalStorage(String userCustomerId) {
    //TODO Save data
  }
}
