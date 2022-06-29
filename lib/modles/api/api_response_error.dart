class APIResponseError {
  final String error;
  final String errorCode;

  APIResponseError({required this.error, required this.errorCode}) : super();

  factory APIResponseError.fromMap(Map<String, dynamic> json) =>
      APIResponseError(
        error: json["error"],
        errorCode: json["errorcode"],
      );

  Map<String, String> toMap() {
    return {
      "error": error,
      "errorcode": errorCode,
    };
  }
}
