import 'package:http/http.dart';

const gdnsBaseUrl =
    "https://raw.githubusercontent.com/PegasisForever/GDNS/main/";

// return null if failed
Future<String> gdnsResolve(String domain) async {
  Response res = await get(gdnsBaseUrl + domain);
  if (res.statusCode == 200) {
    return res.body.trim();
  } else {
    return null;
  }
}
