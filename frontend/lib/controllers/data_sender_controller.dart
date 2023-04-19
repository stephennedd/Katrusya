
import 'package:frontend/api/my_api.dart';
import 'package:get/get.dart';

class DataSenderController extends GetxController {

  Future<void> sendTheUserResultsPerTest(apiUrl, data) async {
    await CallApi().addUserResultsPerTest(apiUrl, data);
  }
}
