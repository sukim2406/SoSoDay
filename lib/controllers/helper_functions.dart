import 'package:soso_day/controllers/auth_controller.dart';

class HelperFunction {
  void userSignupFunction(String email, String name, String password) {
    Map<String, String> userInfoMap = {
      'name': name,
      'email': email,
    };

    AuthController.instance.register(email, password);
  }
}
