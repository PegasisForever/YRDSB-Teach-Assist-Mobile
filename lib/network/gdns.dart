part of "network.dart";

const gdnsBaseUrl =
    "https://raw.githubusercontent.com/PegasisForever/GDNS/main/";
final _ipv4Reg = RegExp(
    r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
final _ipv6Reg = RegExp(
    r"^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$");

Map<String, String> _gdnsCache = {};

// throw exception if failed
Future<Uri> _gdnsResolve(Uri uri) async {
  if (!_isDomain(uri)) {
    return uri;
  } else if (_gdnsCache.containsKey(uri.host)) {
    return uri.replace(
      host: _gdnsCache[uri.host],
    );
  } else {
    Response res = await _getClient().get(gdnsBaseUrl + uri.host);
    if (res.statusCode == 200) {
      _gdnsCache[uri.host] = res.body.trim();
      return uri.replace(
        host: res.body.trim(),
      );
    } else {
      throw "can't resolve $uri";
    }
  }
}

bool _isDomain(Uri uri) {
  return !_ipv4Reg.hasMatch(uri.host) && !_ipv6Reg.hasMatch(uri.host);
}
