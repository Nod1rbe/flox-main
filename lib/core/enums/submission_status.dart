enum SubmissionStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == SubmissionStatus.initial;
  bool get isLoading => this == SubmissionStatus.loading;
  bool get isSuccess => this == SubmissionStatus.success;
  bool get isFailure => this == SubmissionStatus.failure;
}
