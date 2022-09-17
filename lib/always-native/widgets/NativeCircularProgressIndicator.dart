import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class NativeCircularProgressIndicator extends StatelessWidget {

  double? width;
  Color? color;

  NativeCircularProgressIndicator({Key? key, this.width, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return CupertinoActivityIndicator(radius: width == null ? 20 : width!, color: color,);
  }
}
