import 'dart:html';

import 'package:openid_client/openid_client.dart';
import 'dart:math';

Future<Credential> authenticate(Client client,
    {List<String> scopes = const []}) async {
      /* Uri discoveryUri = Uri.https("your discover uri");
    var clientId = "your client id";
    var scopes = ['openid', 'profile', 'basic', 'email', 'offline_access'];
    var issuer = await Issuer.discover(discoveryUri);
    var client = Client(issuer, clientId); */

    var codeVerifier = _randomString(50);
    var state = _randomString(20);
    //var responseUrl;

    var flow = Flow.authorizationCodeWithPKCE(
      client,
      scopes: scopes,
      codeVerifier: codeVerifier,
      state: state,
    );
    print ("Inside authenticate() : after authorizationCodeWithPKCE");
    flow.redirectUri =
        Uri.parse(
            '${window.location.protocol}//${window.location.host}${window.location.pathname}');
    print ("Inside authenticate() : flow.redirectUri : $flow.redirectUri");
    //else {
      // redirect to auth server
      window.sessionStorage["auth_code_verifier"] = codeVerifier;
      window.sessionStorage["auth_state"] = state;
      var authorizationUrl = flow.authenticationUri;
      window.location.href = authorizationUrl.toString();
      print ("Inside responseUrl == null block");
      throw "Authenticating...";
    //}
}

void logOut (String logOutURI) {
        window.sessionStorage.remove("auth_code_verifier");
        window.sessionStorage.remove("auth_callback_response_url");
        window.sessionStorage.remove("auth_state");  
        print("Inside logOut");
        window.open(logOutURI, '_self');
}

Future<Credential?> getRedirectResult(Client client,
    {List<String> scopes = const []}) async {
  print ("Inside getRedirctReslst()" );
  var codeVerifier = window.sessionStorage["auth_code_verifier"];
  var state = window.sessionStorage["auth_state"];
  var responseUrl = window.sessionStorage["auth_callback_response_url"];
  var flow = Flow.authorizationCodeWithPKCE(
      client,
      scopes: scopes,
      codeVerifier: codeVerifier,
      state: state,
    );
   flow.redirectUri =
        Uri.parse(
            '${window.location.protocol}//${window.location.host}${window.location.pathname}');
  if (responseUrl != null) {
      // handle callback
      //try {
        var responseUri = Uri.parse(responseUrl);
        var credentials = await flow.callback(responseUri.queryParameters);
        print ("Inside getRedirctReslst() : after credentials : $credentials");
        return credentials;
      //} 
    } else {
        return null;
    }
}

String _randomString(int length) {
    var r = Random.secure();
    var chars =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return Iterable.generate(length, (_) => chars[r.nextInt(chars.length)])
        .join();
  }