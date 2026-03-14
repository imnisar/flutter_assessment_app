import '../config/custom_screen_util.dart';

extension SizeExtension on num {
  double get h => CustomScreenUtil.height(toDouble());
  double get w => CustomScreenUtil.width(toDouble());
}