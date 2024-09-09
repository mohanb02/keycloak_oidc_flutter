
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart';
import 'oidc_client_singleton.dart';
///import 'package:openid_client/src/model.dart';



Future<void> main() async {
  print ("Inside main");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'openid_client demo',
      home: MyHomePage(title: 'openid_client Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var oidcClient = OIDCClient.getInstance("slic_inc", "QBd3d7eCAkg06BNIJ6OMtFDsoxjS4K1P");
  UserInfo? userInfo ;

  @override
  void initState() {
    print("Inside initState()");
    //oidcClient.getUserInfo().then((value) => userInfo = value);
    _getUserInfo();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (userInfo != null) ...[
              Text('Hello ${userInfo!.name}'),
              Text(userInfo!.email ?? ''),
              OutlinedButton(
                  child: const Text('Logout'),
                  onPressed: () async {
                    setState(() {
                      userInfo = null;
                    });
                    oidcClient.logOut();
                    
                  })
            ],
            if (userInfo == null)
              OutlinedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                     oidcClient.authenticate();
                     
                    /* setState(() {
                      oidcClient.getUserInfo().then((value) => userInfo = value);
                    }); */
                  }),
          ],
        ),
      ),
    );
  }

  Future<void> _getUserInfo() async {
      var userInf = await oidcClient.getUserInfo();
      setState(() {
        userInfo = userInf;
      });
    } 
}
