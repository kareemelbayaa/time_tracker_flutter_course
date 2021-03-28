import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  final EmailSignInChangeModel model;

  EmailSignInFormChangeNotifier({@required this.model});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model =>widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      //TODO replace with user alert
      print(e.toString());
      showExceptionAlertDialog(context, title: 'Sign in failed', exception: e);
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: model.passwordErrorText,
        labelText: 'Password',
        enabled: model.isLoading == false,
      ),
      onChanged: (password) => model.updatePassword(password),
      obscureText: true,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
        onEditingComplete: () => _emailEditingComplete(),
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        controller: _emailController,
        onChanged: (email) => model.updateEmail(email),
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading == false,
        ));
  }

  @override
  Widget build(BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(),
            ),
          );
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
