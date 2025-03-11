import 'package:fairpytasker/Utilities/assets.dart';
import 'package:fairpytasker/core/app/extension/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomLoader extends EasyLoadingAnimation {
  @override
  Widget buildWidget(Widget child, AnimationController controller, AlignmentGeometry alignment) {
    return Center(
      child: Image.asset(
        Assets.loaderGif,
        width: 80,
        height: 80,
        fit: BoxFit.fitHeight,
      ),
    );
  }

}

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        Assets.loaderGif,
        width: 80,
        height: 80,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
