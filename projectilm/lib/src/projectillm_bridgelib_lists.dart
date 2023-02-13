import 'dart:async';

import 'package:http/http.dart' as http;
import 'api_settings.dart' as api_settings;
import 'dart:convert';
import 'projectillm_bridgelib_base.dart';

class ListItem {
  int id;
  String title;
  Event parent;
  String bringer;
  ListItem(this.id, this.title, this.parent, this.bringer);

  Future<bool> bring_me() async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "event_list_set_user",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> unbring_me() async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "event_list_reset_user",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> creator_delete() async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "event_list_remove_item",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }
}
