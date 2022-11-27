import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_auth_demo/bridge_response.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(title: 'Hive Auth + Flutter'),
      debugShowCheckedModeBanner: false,
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
  var token = "None yet";
  var expiry = "None yet";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Text("Hive Auth Token - $token"),
            const SizedBox(height: 15),
            Text("Hive Auth Token Expiry - $expiry"),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text('Log in'),
              onPressed: () async {
                var platform = const MethodChannel('blog.hive.auth/bridge');
                final String authStr =
                    await platform.invokeMethod('_f2n_get_redirect_uri', {
                  'username': 'sagarkothari88',
                });
                log('Hive auth string is $authStr');
                var response = BridgeResponse.fromJsonString(authStr);
                if (response.data != null) {
                  var url = Uri.parse(response.data!);
                  launchUrl(url);
                }
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              child: const Text('Refresh'),
              onPressed: () async {
                var platform = const MethodChannel('blog.hive.auth/bridge');
                final String data = await platform.invokeMethod('getUserInfo');
                log('Data is $data');
                var response = BridgeResponse.fromJsonString(data);
                var userInfoData =
                    UserInfoResponse.fromJsonString(response.error);
                setState(() {
                  token = userInfoData.token ?? "None yet";
                  expiry = userInfoData.expire ?? "None yet";
                });
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
