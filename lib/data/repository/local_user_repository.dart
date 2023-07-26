import 'package:nandikrushi_farmer/domain/enum/user_authentication_state.dart';
import 'package:nandikrushi_farmer/domain/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository implements UserRepository {
  final SharedPreferences sharedPreferences;
  const LocalUserRepository({required this.sharedPreferences});
  @override
  Map<UserAuthStatus, String> checkIfUserIdExists() {
    return sharedPreferences.getString('userID') != null &&
            (sharedPreferences.getString('userID')?.isNotEmpty ?? false)
        ? {UserAuthStatus.verified: sharedPreferences.getString('userID')!}
        : {UserAuthStatus.none: ""};
  }
}
