class APIPath{
  static String Job(String uid,String jobId)=>'/users/$uid/jobs/$jobId';
  static String Jobs(String uid)=>'/users/$uid/jobs';
}