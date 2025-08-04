import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedExtension on num {

  SizedBox get width => SizedBox(width: toDouble().w);
  SizedBox get height => SizedBox(height: toDouble().h);

  EdgeInsets get padding => EdgeInsets.all(toDouble());
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble().w);
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble().h);
}