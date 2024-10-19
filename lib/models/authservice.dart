
import 'package:mobi_div/models/jwt_generator.dart';
import 'package:mobi_div/models/usermodel.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final UserService userService = UserService();
  String uuid = Uuid().v4();


  Future<bool> login(String email, String password) async {

    if(email.isEmpty || password.isEmpty){
      return false;
    }else{
      String token = jwtGen(uuid);
      User user = User(id: uuid, email: email, password: password, token: token);
      userService.saveUser(user);
      return true;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    if(email.isEmpty || password.isEmpty){
      return false;
    }else{
      String token = jwtGen(uuid);
      final User user = User(id: uuid, name: name, email: email, password: password, token: token);
      await userService.saveUser(user);

      return true;
    }
  }

  Future<void> logout() async {
    await userService.clearUser();
  }
}
