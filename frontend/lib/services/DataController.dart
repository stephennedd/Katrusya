import 'package:get/get.dart';

class DataController extends GetxController {
  getData(String collection) {
    return [
      {
        "image":
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.edx.org%2Fschool%2Fedx&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAE",
        "title": "Python course",
        "author": "Maksim Maksimovic",
        "ratings": "5",
        "entrolled": "yes",
        "price": "100"
      },
      {
        "image":
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Findianexpress.com%2Farticle%2Feducation%2Fhave-a-business-acumen-try-out-these-new-age-short-online-courses-6352687%2F&psig=AOvVaw3vRjaUy3sTcr7qWDXWNx2q&ust=1677924499615000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCKjJ4P_Bv_0CFQAAAAAdAAAAABAI",
        "title": "JS course",
        "author": "Yehor Zhvarnytskyi",
        "ratings": "5",
        "entrolled": "yes",
        "price": "200"
      }
    ];
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
