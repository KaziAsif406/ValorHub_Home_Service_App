// import 'package:rxdart/rxdart.dart';
// import '../../../../../../networks/rx_base.dart';
// import 'api.dart';
// import '../../../../helpers/error_message_handler.dart';

// final class GetProfileRx extends RxResponseInt {
//   final api = GetProfileApi.instance;

//   GetProfileRx({required super.empty, required super.dataFetcher});

//   ValueStream get fileData => dataFetcher.stream;

//   Future<bool> featchProfile() async {
//     try {
//       Map data = await api.getProfileData();
//       return await handleSuccessWithReturn(data);
//     } catch (error) {
//       return await handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleSuccessWithReturn(data) async {
//     dataFetcher.sink.add(data);
//     return true;
//   }

//   @override
//   handleErrorWithReturn(error) {
//     ErrorMessageHandler.showErrorToast(error); // Just one call!
//     return false;
//   }
// }
