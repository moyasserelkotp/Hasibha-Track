import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/const/colors.dart';
import '../../../../shared/const/app_strings.dart';
import '../../../../shared/style/app_styles.dart';



class BackToLogin extends StatelessWidget {
  const BackToLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          context.pop();
        },
        child: Text(AppStrings.backToLogin,
            style: AppStyles.styleNormal16(context)
                .copyWith(color: AppColors.primary)),
      ),
    );
  }
}
