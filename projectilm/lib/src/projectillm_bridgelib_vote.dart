import 'dart:async';

import 'package:http/http.dart' as http;
import 'api_settings.dart' as api_settings;
import 'dart:convert';
import 'projectillm_bridgelib_base.dart';

class Poll {
  int id;
  String title;
  Event parent;
  Poll(this.id, this.title, this.parent);

  Future<bool> creator_update(String new_title) async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "vote_update",
      "args": [username, password, id, new_title]
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
      "command": "vote_delete",
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

  Future<VoteOption?> creator_create_option(String title) async {
    if (me == null) {
      return null;
    }
    var request = {
      "command": "vote_option_create",
      "args": [username, password, id, title]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return VoteOption(data["result"]["id"], title, this);
    }
    return null;
  }

  Future<int> get_vote_count() async {
    if (me == null) {
      return -1;
    }
    var request = {
      "command": "vote_get_count",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return -1;
  }

  Future<List<VoteOption>> get_options() async {
    if (me == null) {
      return [];
    }
    var request = {
      "command": "vote_load_options",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<VoteOption> options = [];
      data["result"]
          .forEach((e) => {options.add(VoteOption(e["id"], e["title"], this))});
      return options;
    }
    return [];
  }

  Future<List<VoteOption>> get_my_voted_options() async {
    if (me == null) {
      return [];
    }
    var request = {
      "command": "vote_user_get_votes",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<VoteOption> options = [];
      data["result"]
          .forEach((e) => {options.add(VoteOption(e["id"], e["title"], this))});
      return options;
    }
    return [];
  }
}

class VoteOption {
  int id;
  Poll parent;
  String title;
  VoteOption(this.id, this.title, this.parent);

  Future<bool> creator_update(String new_title) async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "vote_option_update",
      "args": [username, password, id, new_title]
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
      "command": "vote_option_delete",
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

  Future<bool> vote_for() async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "vote_user_add_vote",
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

  Future<bool> unvote_for() async {
    if (me == null) {
      return false;
    }
    var request = {
      "command": "vote_user_remove_vote",
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

  Future<int> get_vote_count() async {
    if (me == null) {
      return -1;
    }
    var request = {
      "command": "vote_option_get_count",
      "args": [username, password, id]
    };
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return -1;
  }
}
