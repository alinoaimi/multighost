import 'dart:io';

enum NativePlatform {
  Linux, macOS, Windows, Android, iOS
}

class NativeData {

  static NativePlatform getPlatform() {

    // return NativePlatform.Linux;

    if(Platform.isMacOS) {
      return NativePlatform.macOS;
    }
    if(Platform.isLinux) {
      return NativePlatform.Linux;
    }
    if(Platform.isWindows) {
      return NativePlatform.Windows;
    }
    if(Platform.isAndroid) {
      return NativePlatform.Android;
    }
    if(Platform.isIOS) {
      return NativePlatform.iOS;
    }

    return NativePlatform.macOS;

  }

  static double nativeCardSideMargins = 10;


}