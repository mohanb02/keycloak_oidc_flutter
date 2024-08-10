import 'dart:async';

import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_browser.dart' as browser;

Future<Credential> authenticate(Client client,
    {List<String> scopes = const []}) async {
  var authenticator = browser.Authenticator(client, scopes: scopes);
print("authenticator in authenticate : ${authenticator.toString()}" );
  authenticator.authorize();

  return Completer<Credential>().future;
}

Future<Credential?> getRedirectResult(Client client,
    {List<String> scopes = const []}) async {
  var authenticator = browser.Authenticator(client, scopes: scopes);
print("authenticator in getRedirectResulst : ${authenticator.toString()}" );
  var c = await authenticator.credential;

  return c;
}

void logout(Client client, {List<String> scopes = const []}) {
  browser.Authenticator? authenticator = browser.Authenticator(client, scopes: scopes);
  print("authenticator in logout : ${authenticator.toString()}" );
  authenticator = null;
  //authenticator
}