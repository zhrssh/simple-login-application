import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:login_app/send_message_event.dart';

class SendMessageBloc {
  // Variables
  var _url;
  var _data;

  // For sending messages
  final _messageStateController = StreamController<Object>();
  StreamSink<Object> get _inResponse => _messageStateController.sink;

  // For states
  // This is where the stream builder listens
  Stream<Object> get response => _messageStateController.stream;

  // For events
  final _messageEventController = StreamController<SendMessageEvent>();

  // This is where we add the events (e.g. _block.sendMessageEventSink.add(event))
  Sink<SendMessageEvent> get sendMessageEventSink =>
      _messageEventController.sink;

  SendMessageBloc() {
    _messageEventController.stream.listen(_mapStateToEvent);
  }

  // This sets up the data to be sent and the url
  void parseMessage(var host, var port, var data) {
    _data = data;
    _url = Uri(scheme: "http", host: host, path: '/', port: port);
  }

  void _mapStateToEvent(SendMessageEvent event) async {
    if (event is SendMessage) {
      // Encode body to json
      var body = json.encode(_data);

      // Post data to the url
      var response = await post(_url,
          headers: {"Content-Type": "application/json"}, body: body);

      // Return response to the stream
      _inResponse.add(response.body);
    }
  }

  void dispose() {
    _messageEventController.close();
    _messageStateController.close();
  }
}
