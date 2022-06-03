import 'package:firebase_padc/pages/home_page.dart';
import 'package:firebase_padc/pages/register_page.dart';
import 'package:firebase_padc/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../resources/dimens.dart';
import '../resources/strings.dart';
import '../widgets/label_and_textfield_view.dart';
import '../widgets/or_view.dart';
import '../widgets/primary_button_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            LabelAndTextFieldView(
              label: LBL_EMAIL,
              hint: HINT_EMAIL,
              onChanged: (email) {},
            ),
            const SizedBox(
              height: MARGIN_XLARGE,
            ),
            LabelAndTextFieldView(
              label: LBL_PASSWORD,
              hint: HINT_PASSWORD,
              onChanged: (email) {},
              isSecure: true,
            ),
            const SizedBox(
              height: MARGIN_XXLARGE,
            ),
            TextButton(
              onPressed: () {
                navigateToScreen(context, const HomePage());
              },
              child: const PrimaryButtonView(
                label: LBL_LOGIN,
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
