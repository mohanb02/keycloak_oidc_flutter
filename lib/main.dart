
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart';
import 'oidc_client_singleton.dart';

Future<void> main() async {
  print ("Inside main");
  var oidcClient = OIDCClient.getInstance("slic_inc", "QBd3d7eCAkg06BNIJ6OMtFDsoxjS4K1P");
  UserInfo? userInfo = await oidcClient.getUserInfo();

  if (userInfo == null){
    oidcClient.authenticate();
  } else {
    runApp( MyApp(userInfo: userInfo));
  }
}

class MyApp extends StatelessWidget {
    UserInfo userInfo;
    MyApp({super.key, required this.userInfo});
     //MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'openid_client demo',
      home: MyHomePage(title: 'openid_client Demo Home Page',userInfo: userInfo,),
    );
  }
}

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title, required this.userInfo});

   String title;
   UserInfo? userInfo;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    print("Inside initState()");
    //oidcClient.getUserInfo().then((value) => userInfo = value);
    
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
            if (widget.userInfo != null) ...[
              Text('Hello ${widget.userInfo!.name}'),
              Text(widget.userInfo!.email ?? ''),
              OutlinedButton(
                  child: const Text('Logout'),
                  onPressed: () async {
                    setState(() {
                      widget.userInfo = null;
                    });
                    var oidcClient = OIDCClient.getInstance("slic_inc", "QBd3d7eCAkg06BNIJ6OMtFDsoxjS4K1P");
                    oidcClient.logOut();
                    
                  })
            ],
            if (widget.userInfo == null)
              OutlinedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                     //oidcClient.authenticate();
                     
                    /* setState(() {
                      oidcClient.getUserInfo().then((value) => userInfo = value);
                    }); */
                  }),
          ],
        ),
      ),
    );
  }
 
}
