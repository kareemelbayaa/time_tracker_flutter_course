import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTab}) : super(key: key);

  final Job job;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(job.name),onTap: onTab,trailing: Icon(Icons.chevron_right),);
  }
}
