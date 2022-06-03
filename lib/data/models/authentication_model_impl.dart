import '../../network/real_time_database_data_agent_impl.dart';
import '../../network/social_data_agent.dart';
import '../vos/user_vo.dart';
import 'authentication_model.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  static final AuthenticationModelImpl _singleton =
      AuthenticationModelImpl._internal();

  factory AuthenticationModelImpl() {
    return _singleton;
  }

  AuthenticationModelImpl._internal();

  SocialDataAgent mDataAgent = RealtimeDatabaseDataAgentImpl();
  //SocialDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Future<void> login(String email, String password) {
    return mDataAgent.login(email, password);
  }

  @override
  Future<void> register(String email, String userName, String password) {
    return craftUserVO(email, password, userName)
        .then((user) => mDataAgent.registerNewUser(user));
  }

  Future<UserVO> craftUserVO(String email, String password, String userName) {
    //var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newUser = UserVO(
      //id: currentMilliseconds,
      id: "",
      userName: userName,
      email: email,
      password: password,
    );
    return Future.value(newUser);
  }

  @override
  UserVO getLoggedInUser() {
    return mDataAgent.getLoggedInUser();
  }

  @override
  bool isLoggedIn() {
    return mDataAgent.isLoggedIn();
  }

  @override
  Future<void> logOut() {
    return mDataAgent.logOut();
  }
}
