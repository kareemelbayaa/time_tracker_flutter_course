import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/avatar.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: [
          FlatButton(onPressed: ()=>_confirmSignOut(context), child: Text('Logout',style: TextStyle(fontSize: 18.0,color: Colors.white),))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }
  Future<void> _signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        defaultActionText: 'YES',
        cancelActionText: 'CANCEL');
    if (didRequestSignOut == true) {
      _signout(context);
    }
  }

  Widget _buildUserInfo(User currentUser) {
    return Avatar(
      photoUrl: currentUser.photoURL,
      radius: 50,
    );
  }
}
