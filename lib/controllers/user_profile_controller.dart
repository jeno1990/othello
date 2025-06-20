import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class UserProfileController extends GetxController {
  final box = GetStorage();

  var username = ''.obs;
  var gender = ''.obs;
  var birthDate = DateTime.now().obs;
  var city = ''.obs;
  var country = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  late TextEditingController usernameCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController passwordCtrl;

  var obscurePassword = true.obs;

  String get usernameValue => username.value;

  @override
  void onInit() {
    usernameCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    username.value = box.read('username') ?? '';
    gender.value = box.read('gender') ?? '';
    city.value = box.read('city') ?? '';
    country.value = box.read('country') ?? '';
    email.value = box.read('email') ?? '';
    password.value = box.read('password') ?? '';

    final storedDate = box.read('birthDate');
    if (storedDate != null) {
      birthDate.value = DateTime.tryParse(storedDate) ?? DateTime.now();
    }

    usernameCtrl.text = username.value;
    cityCtrl.text = city.value;
    emailCtrl.text = email.value;
    passwordCtrl.text = password.value;
  }

  void saveProfile() {
    username.value = usernameCtrl.text;
    city.value = cityCtrl.text;
    email.value = emailCtrl.text;
    password.value = passwordCtrl.text;

    box.write('username', username.value);
    box.write('gender', gender.value);
    box.write('birthDate', birthDate.value.toIso8601String());
    box.write('city', city.value);
    box.write('country', country.value);
    box.write('email', email.value);
    box.write('password', password.value);

    Get.snackbar(
      'Success',
      'Profile saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
