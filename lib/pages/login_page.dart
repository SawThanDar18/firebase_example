import 'package:firebase_padc/pages/home_page.dart';
import 'package:firebase_padc/pages/register_page.dart';
import 'package:firebase_padc/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/login_bloc.dart';
import '../resources/dimens.dart';
import '../resources/strings.dart';
import '../widgets/label_and_textfield_view.dart';
import '../widgets/or_view.dart';
import '../widgets/primary_button_view.dart';
import 'add_new_post_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Selector<LoginBloc, bool>(
          selector: (context, bloc) => bloc.isLoading,
          builder: (context, isLoading, child) => Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: LOGIN_SCREEN_TOP_PADDING,
                  bottom: MARGIN_LARGE,
                  left: MARGIN_XLARGE,
                  right: MARGIN_XLARGE,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      LBL_LOGIN,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: TEXT_BIG,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XXLARGE,
                    ),
                    Consumer<LoginBloc>(
                      builder: (context, bloc, child) => LabelAndTextFieldView(
                        label: LBL_EMAIL,
                        hint: HINT_EMAIL,
                        onChanged: (email) => bloc.onEmailChanged(email),
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    Consumer<LoginBloc>(
                      builder: (context, bloc, child) => LabelAndTextFieldView(
                        label: LBL_PASSWORD,
                        hint: HINT_PASSWORD,
                        onChanged: (password) =>
                            bloc.onPasswordChanged(password),
                        isSecure: true,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XXLARGE,
                    ),
                    Consumer<LoginBloc>(
                      builder: (context, bloc, child) => TextButton(
                        onPressed: () {
                          bloc
                              .onTapLogin()
                              .then((_) =>
                                  navigateToScreen(context, const HomePage()))
                              .catchError((error) => showSnackBarWithMessage(
                                  context, error.toString()));
                        },
                        child: const PrimaryButtonView(
                          label: LBL_LOGIN,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    const ORView(),
                    const SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    const RegisterTriggerView()
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: LoadingView(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterTriggerView extends StatelessWidget {
  const RegisterTriggerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LBL_DONT_HAVE_AN_ACCOUNT,
        ),
        const SizedBox(width: MARGIN_SMALL),
        GestureDetector(
          onTap: () => navigateToScreen(
            context,
            const RegisterPage(),
          ),
          child: const Text(
            LBL_REGISTER,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
