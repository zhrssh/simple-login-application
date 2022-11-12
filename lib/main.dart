import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_app/send_message_bloc.dart';
import 'package:login_app/send_message_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Simple Login System'),
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
  var _user = '', _pass = '';
  var data = {};

  var host = "localhost";
  var port = 3000;

  final _sendMessageBloc = SendMessageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _sendMessageBloc.response,
        initialData: "",
        builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  style: Theme.of(context).textTheme.headline5,
                ),
                TextField(
                  onChanged: (value) => {_user = value},
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                ),
                TextField(
                  onChanged: (value) => {_pass = value},
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Password"),
                ),
                TextButton(
                    onPressed: () => setState(() => {
                          data = {'user': _user, 'pass': _pass},

                          // We parse the message first
                          _sendMessageBloc.parseMessage(host, port, data),

                          // Sends an event to the block containing the url and the data
                          _sendMessageBloc.sendMessageEventSink
                              .add(SendMessage()),
                        }),
                    child: const Text("Submit")),
                Text("Sent data: user: ${data['user']}; pass: ${data['pass']}"),
                Text("Response: ${snapshot.data}")
              ]);
        },
      ),
    );
  }
}
