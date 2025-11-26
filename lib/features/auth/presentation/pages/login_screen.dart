import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection.dart' as di;
import '../../../../shared/const/colors.dart';
import '../blocs/login/login_bloc.dart';
import 'login_component.dart';

class LoginScreen2 extends StatelessWidget {
  const LoginScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<LoginBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: const LoginComponent(),
      ),
    );
  }
}
