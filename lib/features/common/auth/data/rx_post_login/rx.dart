import 'package:rxdart/rxdart.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../helpers/di.dart';
import '../../../../../helpers/error_message_handler.dart';
import '../../../../../helpers/post_login.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class PostLoginRx extends RxResponseInt {
  final api = PostLoginApi.instance;
  String message = "Something went wrong";
  PostLoginRx({required super.empty, required super.dataFetcher});
  ValueStream get getPostLoginRes => dataFetcher.stream;

  Future<bool> postLogin(
      {required String email, required String password}) async {
    try {
      Map<String, dynamic> data = {"email": email, "password": password};
      Map resdata = await api.postLogIn(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    String? accesstoken = data['data']['token'];

    int id = data['data']["user"]['id'];
    DioSingleton.instance.update(accesstoken!);
    await appData.write(kKeyIsLoggedIn, true);
    await appData.write(kKeyIsExploring, false);
    await appData.write(kKeyUserID, id);
    await appData.write(kKeyAccessToken, accesstoken);

    dataFetcher.sink.add(data);
    performPostLoginActions();

    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error); // Just one call!
    return false;
  }
}
