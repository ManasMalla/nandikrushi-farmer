import 'package:nandikrushi_farmer/domain/enum/user_authentication_state.dart';
import 'package:nandikrushi_farmer/domain/repository/user_repository.dart';

class OnlineUserRepository implements UserRepository {
  @override
  Map<UserAuthStatus, String> checkIfUserIdExists() {
    // TODO: implement checkIfUserIdExists from server
    throw UnimplementedError();
  }
}
