import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Database database,Job job}) async {
    await Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}


class _EditJobPageState extends State<EditJobPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.job!=null){
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }
  //to access the state of the form
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;


  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //Todo validate and save form
    if (_validateAndSaveForm()) {
      try {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id,name: _name, ratePerHour: _ratePerHour);
          //todo submit data to firestore or api
          await widget.database.setJob(job);
          Navigator.of(context).pop();

      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: 'Operation Failed',
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ))
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      //to use as much vertical spacing as needed and not the whole screen
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name, //used for editing an existing job
        decoration: InputDecoration(labelText: 'Job Name'),
        validator: (value) =>
            value.isNotEmpty ? null : 'job name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: '$_ratePerHour',
        decoration: InputDecoration(labelText: 'Rate Per Hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
      ),
    ];
  }
}
