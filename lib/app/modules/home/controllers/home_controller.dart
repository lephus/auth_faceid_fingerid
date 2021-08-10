import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
class HomeController extends GetxController {
  var _localAuth = LocalAuthentication();
  var hasFingerPrintLock = false.obs;
  var hasFaceLock = false.obs;
  var isUserAuthenticated = false.obs;

  void _getAllVBiometrics() async {
    bool hasLocalAuthentication = await _localAuth.canCheckBiometrics;
    if (hasLocalAuthentication){
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      hasFaceLock.value = availableBiometrics.contains(BiometricType.face);
      hasFingerPrintLock.value = availableBiometrics.contains(BiometricType.fingerprint);
    }else{

    }
  }
void showSnackbar({String title, String message, Color backgroudColor}){
    Get.snackbar(
      title, message, colorText: Colors.white, backgroundColor: backgroudColor, snackPosition: SnackPosition.BOTTOM
    );
}
  @override
  void onInit() {
    super.onInit();
    _getAllVBiometrics();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  void authenticationUser() async{
    try {
      const androidMessage = const AndroidAuthMessages(
        cancelButton: "Cancel",
        goToSettingsButton:"Setting",
        goToSettingsDescription: 'Please set up your Fingerprint/Face',
          biometricHint: 'Verify your identity'
      );
      isUserAuthenticated.value = await _localAuth.authenticate(
        localizedReason:'Authentication Yourself',
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
        androidAuthStrings: androidMessage
      );
      if (isUserAuthenticated.value) {
        showSnackbar(
          title: "success",
          message: "You are authenticated",
          backgroudColor: Colors.green
        );
      }else{
        showSnackbar(
            title: "error",
            message: "Authenticated cancelled",
            backgroudColor: Colors.red
        );
      }
    }catch(e){
      showSnackbar(
          title: "error",
          message: e.toString(),
          backgroudColor: Colors.red
      );
    }
  }
}
