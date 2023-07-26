import 'package:nandikrushi_farmer/domain/enum/user_authentication_state.dart';

abstract class UserRepository {
  Map<UserAuthStatus, String> checkIfUserIdExists();
}
