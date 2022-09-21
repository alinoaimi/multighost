import 'dart:io';
import 'dart:math';

// a versatile callback def to use in various places
typedef void DataCallback<T>(T data);

class GlobalUtils {
  static String formatBytes(double bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  static String formateMBsForInstanceCreation(double mbs) {
    double bytes = mbs * 1048576;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();

    String suffix = suffixes[i];
    int decimals = 0;
    if (i > 2) {
      decimals = 1;
    }

    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffix;
  }

  static void launchPathNative(String path) async {
    var result = await Process.run('open', [path]);
  }

  static double standardPaddingOne = 8;

  static String multipassPath = '';

}
