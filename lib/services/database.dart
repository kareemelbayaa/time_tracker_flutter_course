import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/models/Job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements Database {
  final String uid;
  final _service = FirestoreService.instance;
  FireStoreDatabase({@required this.uid}) : assert(uid != null);

  Future<void> createJob(Job job) => _service.setData(
        path: APIPath.Job(uid, 'job_efg'),
        data: job.toMap(),
      );

  //to get all the jobs for a single user
  Stream<List<Job>> jobsStream() {
    return _service.collectionStream(
        path: APIPath.Jobs(uid), builder: (data) => Job.fromMap(data));
  }


}
