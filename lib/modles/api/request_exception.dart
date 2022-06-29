class RequestException implements Exception {
  final String _message;
  final String _prefix;
  
RequestException(this._message, this._prefix);
  
@override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends RequestException {
  FetchDataException(String message)
      : super(message, "Error During Communication: ");
}

class BadRequestException extends RequestException {
  BadRequestException(message) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends RequestException {
  UnauthorisedException(message) : super(message, "Unauthorised: ");
}

class InvalidInputException extends RequestException {
  InvalidInputException(String message) : super(message, "Invalid Input: ");
}