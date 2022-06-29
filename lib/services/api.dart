class AlphaAPI {
  AlphaAPI._();
  static String moodleBaseUrl = '';

  static String get moodleRest => moodleBaseUrl + '/webservice/rest/server.php';
  static String alphaRest = 'https://server.newquizzes.games';
  static String alphaSocket = 'https://server.newquizzes.games';

  static bool isAlphaModule(String endpoint) {
    return endpoint.contains(alphaRest);
  }
}
