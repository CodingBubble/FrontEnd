import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:projectilm/src/projectillm_bridgelib_lists.dart';
import 'package:projectilm/src/projectillm_bridgelib_splid.dart';
import 'api_settings.dart' as api_settings;
import 'dart:convert';
import 'projectillm_bridgelib_vote.dart';
import 'dart:io';
import "package:async/async.dart";

class User {
  int id;
  String username;
  bool is_me;
  User (this.id, this.username, {this.is_me:false});
  @override
  int get hashCode => id;
}

List order(User u1, User u2)
{
  return u1.id < u2.id ? [u1, u2] : [u2, u1];
}


class Group {
  int id;
  int admin_id;
  String name;
  String description;
  Group(this.id, this.admin_id, this.name, this.description);

  Future<bool> is_admin(User user) async {
    return user.id == admin_id;
  }

  Future<bool> admin_update(String new_name, String new_desc) async {
    if (me==null) {return false; }
    var request = {"command": "group_update", "args": [username, password, id, new_name, new_desc]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> leave() async {
    if (me==null) {return false; }
    var request = {"command": "group_leave", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> admin_kick_user(User user_to_kick) async {
    if (me==null) {return false; }
    var request = {"command": "group_kick", "args": [username, password, user_to_kick.id, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<String?> admin_create_key({days_to_use:7}) async {
    if (me==null) {return null; }
    var request = {"command": "group_create_key", "args": [username, password, id, days_to_use]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"]["key"];
    }
    return null;
  }

  Future<bool> admin_delete() async {
    if (me==null) {return false; }
    var request = {"command": "group_delete", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<List<User>> get_members() async {
    if (me==null) {return []; }
    var request = {"command": "group_get_members", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<User> users = [];
      data["result"].forEach((e)=> {
        users.add(User(e["id"], e["username"]))
      });
      return users;
    }
    return [];
  }

  Future<List<GroupMessage>> get_messages() async {
    if (me==null) {return []; }
    var request = {"command": "group_load_msgs", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<GroupMessage> messages = [];
      data["result"].forEach((e)=> {
        messages.add(GroupMessage(e["id"], e["text"], User(e["userid"], e["username"]), 
                  DateTime.parse(e["date"]), this))
      });
      return messages;
    }
    return [];
  }

  Future<List<GroupMessage>> get_messages_gen(int part) async {
    if (me==null) {return []; }
    var request = {"command": "group_load_msgs_gen", "args": [username, password, id, part]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<GroupMessage> messages = [];
      data["result"].forEach((e)=> {
        messages.add(GroupMessage(e["id"], e["text"], User(e["userid"], e["username"]), 
                  DateTime.parse(e["date"]), this))
      });
      return messages;
    }
    return [];
  }

  Future<GroupMessage?> send_message(text) async {
    if (me==null) {return null; }
    var request = {"command": "group_msg_send", "args": [username, password, id, text]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return GroupMessage(data["result"]["id"], text, me!, 
                  DateTime.parse(data["result"]["date"]), this);
    }
    return null;
  }

  Future<List<Event>> get_events_active() async {
    if (me==null) {return []; }
    var request = {"command": "group_get_events_active", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Event> events = [];
      data["result"].forEach((e)=> {
        events.add(Event(e["id"], this, e["creator"], e["eventname"], e["description"], DateTime.parse(e["date"])))
      });
      return events;
      }
    return [];
  }

  Future<List<Event>> get_events_achieved() async {
    if (me==null) {return []; }
    var request = {"command": "group_get_events_achieved", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Event> events = [];
      data["result"].forEach((e)=> {
        events.add(Event(e["id"], this, me!.id, e["eventname"], e["description"], DateTime.parse(e["date"])))
      });
      return events;
      }
    return [];
  }

  Future<Event?> create_event(String title, String desc, DateTime time) async {
    if (me==null) { return null; }
    var request = {"command": "event_create", "args": [username, password, id, title, desc, time.millisecondsSinceEpoch/1000]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return Event(data["result"]["id"], this, me!.id, title, desc, time);
    }
    return null;
  }

  Future<int> upload_image(File imageFile) async {
    var url = Uri.http(api_settings.img_host, "upload_file");
    print(url);
    var request = http.MultipartRequest("POST", url);
    request.fields["username"]=username;
    request.fields["password"]=password;
    request.fields["id"]=id.toString();
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('image', stream, length, filename: "image");
    request.files.add(multipartFile);
    var response = await request.send();
    String body=await response.stream.bytesToString();
    print(body);
    var data = jsonDecode(body);
    if (data["success"]) {
      return data["id"];
    }
    return -1;
  }

  Future<Transaction?> create_transaction(String title, User from, User to, double balance) async {
    if (me==null) { return null; }
    var request = {"command": "transaction_create", "args": [username, password,from.id, to.id, balance, title, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return Transaction(data["result"]["id"], title, from, to, balance);
    }
    return null;
  }

  Future<List<Transaction>> get_all_transactions() async {
  if (me==null) {return []; }
  var request = {"command": "transactions_get_in", "args": [username, password, id]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    List<Transaction> transactions = [];
    data["result"].forEach((e)=> {
      transactions.add(Transaction(e["id"], e["title"], 
                                  User(e["userid1"], e["username1"]), 
                                  User(e["userid2"], e["username2"]), 
                                  double.parse(e["balance"].toString())
      ))
    });
    return transactions;
    }
  return [];
}

  Future<List<Transaction>> get_transactions_of(User u) async {
    if (me==null) {return []; }
    var request = {"command": "transactions_get_of_in", "args": [username, password, u.id, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body); 
    if (data["success"]) {
      List<Transaction> transactions = [];
      data["result"].forEach((e)=> {
        transactions.add(Transaction(e["id"], e["title"], User(e["userid1"], e["username1"]), User(e["userid2"], e["username2"]), double.parse(e["balance"].toString())))
      });
      return transactions;
      }
    return [];
  }

  Future<List<Transaction>> get_transactions_between(User u1, User u2) async {
    if (me==null) {return []; }
    var request = {"command": "transactions_get_between_in", "args": [username, password, u1.id, u2.id, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Transaction> transactions = [];
      List o = order(u1, u2);
      data["result"].forEach((e)=> {
        transactions.add(Transaction(e["id"], e["title"], o[0], o[1], double.parse(e["balance"].toString())))
      });
      return transactions;
      }
    return [];
  }

  get_my_transactions_with(User user) {}

}

class Event {
  int id;
  Group parental_group;
  int creator_id;
  String name;
  String description;
  DateTime time;
  Event(this.id, this.parental_group, this.creator_id, this.name, this.description, this.time);

  Future<bool> is_creator(User user) async {
    return user.id == creator_id;
  }

  Future<List<EventMessage>> get_messages() async {
    if (me==null) {return []; }
    var request = {"command": "event_load_msgs", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<EventMessage> messages = [];
      data["result"].forEach((e)=> {
        messages.add(EventMessage(e["id"], e["text"], User(e["userid"], e["username"]), 
                  DateTime.parse(e["date"]), this))
      });
      return messages;
    }
    return [];
  }

  Future<List<EventMessage>> get_messages_gen(int part) async {
    if (me==null) {return []; }
    var request = {"command": "event_load_msgs_gen", "args": [username, password, id, part]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<EventMessage> messages = [];
      data["result"].forEach((e)=> {
        messages.add(EventMessage(e["id"], e["text"], User(e["userid"], e["username"]), 
                  DateTime.parse(e["date"]), this))
      });
      return messages;
    }
    return [];
  }

  Future<EventMessage?> send_message(text) async {
    if (me==null) {return null; }
    var request = {"command": "event_msg_send", "args": [username, password, id, text]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return EventMessage(data["result"]["id"], text, me!, 
                  DateTime.parse(data["result"]["date"]), this);
    }
    return null;
  }

  Future<List<Announcement>> get_announcements() async {
    if (me==null) {return []; }
    var request = {"command": "event_load_announcements", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Announcement> messages = [];
      data["result"].forEach((e)=> {
        messages.add(Announcement(e["id"], this, e["text"], 
                  DateTime.parse(e["date"])))
      });
      return messages;
    }
    return [];
  }

  Future<List<Announcement>> get_announcements_gen(int part) async {
    if (me==null) {return []; }
    var request = {"command": "event_load_announcements_gen", "args": [username, password, id, part]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Announcement> messages = [];
      data["result"].forEach((e)=> {
        messages.add(Announcement(e["id"], this, e["text"], 
                  DateTime.parse(e["date"])))
      });
      return messages;
    }
    return [];
  }

  Future<Announcement?> creator_send_announcement(text) async {
    if (me==null) {return null; }
    var request = {"command": "event_announcement_send", "args": [username, password, id, text]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return Announcement(data["result"]["id"], this, text, 
                  DateTime.parse(data["result"]["date"]));
    }
    return null;
  }



  Future<bool> creator_update(String new_name, String new_desc, DateTime new_time) async {
    if (me==null) {return false; }
    var request = {"command": "event_update", "args": [username, password, id, new_name, new_desc, new_time.millisecondsSinceEpoch/1000]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      if (data["result"]){
        this.name = new_name;
        this.description = description;
      }
      return data["result"];
    }
    return false;
  }

  Future<bool> creator_delete() async {
    if (me==null) {return false; }
    var request = {"command": "event_delete", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<List<User>> get_members() async {
    if (me==null) {return []; }
    var request = {"command": "event_get_members", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<User> users = [];
      data["result"].forEach((e)=> {
        users.add(User(e["id"], e["username"]))
      });
      return users;
    }
    return [];
  }

  Future<bool> join() async {
    if (me==null) {return false; }
    var request = {"command": "event_join", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> am_member() async {
    if (me==null) {return false; }
    var request = {"command": "event_is_member", "args": [me!.id, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  Future<bool> leave() async {
    if (me==null) {return false; }
    var request = {"command": "event_leave", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }


  Future<List<Poll>> get_polls () async {
    if (me==null) {return []; }
    var request = {"command": "event_load_votes", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Poll> polls = [];
      data["result"].forEach((e)=> {
        polls.add(Poll(e["id"], e["title"], this))
      });
      return polls;
    }
    return [];
  } 

  Future<Poll?> creator_create_poll(String title) async {
    if (me==null) { return null; }
    var request = {"command": "vote_create", "args": [username, password, id, title]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return Poll(data["result"]["id"], title ,this);
    }
    return null;
  }

   Future<List<ListItem>> get_list_items () async {
    if (me==null) {return []; }
    var request = {"command": "event_list_load", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<ListItem> items = [];
      data["result"].forEach((e)=> {
        items.add(ListItem(e["id"], e["title"], this, e["user_bring"]))
      });
      return items;
    }
    return [];
  } 

  Future<ListItem?> creator_list_add_item(String title) async {
    if (me==null) { return null; }
    var request = {"command": "event_list_add_item", "args": [username, password, id, title]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return ListItem(data["result"]["id"], title ,this, data["result"]["user_bring"]);
    }
    return null;
  }
}

abstract class Message {
  User author;
  int id;
  String text;
  DateTime time;
  Message(this.id, this.text, this.author, this.time);
}

class Announcement {
  int id;
  Event eventid;
  String text;
  DateTime time;
  Announcement(this.id, this.eventid,this.text, this.time);
  Future<bool> creator_delete() async {
  if (me==null) {return false; }
  var request = {"command": "event_announcement_delete", "args": [username, password, id]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    return data["result"];
  }
  return false;
  }
}

class GroupMessage extends Message {
  Group group;
  GroupMessage(super.id, super.text, super.author, super.time, this.group);
  Future<bool> author_delete() async {
    if (me==null) {return false; }
    var request = {"command": "group_msg_delete", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }
}

class EventMessage extends Message {
  Event event;
  EventMessage(super.id, super.text, super.author, super.time, this.event);
  Future<bool> author_delete() async {
    if (me==null) {return false; }
    var request = {"command": "event_msg_delete", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }
}



Future<bool> login(String _username, String _password) async {
  var request = {"command": "user_get_by_name", "args": [_username, _password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response;
  try {
    response = await http.get(url);
  } catch (e)  {
    return false;
  }
  var data = jsonDecode(response.body);
  if (data["success"]) {
    if (data["result"]!=-1) {
      logged_in = true;
      username = _username;
      password = _password;
      me = User(data["result"], username, is_me: true);
      return true;
    }
    return false;
  }
  return false;
}

Future<bool> register(String _username, String _password) async {
  var request = {"command": "user_create", "args": [_username, _password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
 if (data["success"]) {
    if (!data["result"].isEmpty) {
      logged_in = true;
      username = _username;
      password = _password;
      me = User(data["result"]["id"], username, is_me: true);
      return true;
    }
    return false;
  }
  return false;
}

Future<bool> me_delete() async {
  var request = {"command": "user_delete", "args": [username, password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
 if (data["success"]) {
    if (!data["result"].isEmpty) {
      logged_in = false;
      username = "";
      password = "";
      me = null;
      return true;
    }
    return false;
  }
  return false;
}

Future<List<Group>> me_get_groups() async {
  if (me==null) {return []; }
  var request = {"command": "user_get_groups", "args": [username, password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    List<Group> groups = [];
    data["result"].forEach((e)=> {
      groups.add(Group(e["id"], e["admin"], e["groupname"], e["description"]))
    });
    return groups;
  }
  return [];
}

Future<Group?> me_use_invitation_code(String code) async {
  if (me==null) {return null; }
  var request = {"command": "user_use_invitation_code", "args": [username, password, code]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    if (data["result"].isEmpty) {return null;}
    return Group(data["result"]["id"], data["result"]["admin"], data["result"]["groupname"], data["result"]["description"]);
  }
  return null;
}

Future<bool> me_change_password(String newPassword) async {
    if (me==null) {return false; }
    var request = {"command": "user_change_password", "args": [username, password, newPassword]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      if (data["result"]) {
        password = newPassword;
        return true;
      }
      return false;
    }
    return false;
  }

Future<Group?> me_create_group(String name, String desc) async {
  if (me==null) { return null; }
    var request = {"command": "group_create", "args": [username, password, name, desc]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return Group(data["result"]["id"], data["result"]["admin"], data["result"]["description"], data["result"]["groupname"]);
    }
    return null;
}

String get_image_url(int imgID) { 
  var request = {"command": "access_file", "args": [username, password, imgID]};
  return "http://" + api_settings.host + "/"+ jsonEncode(request);
}

Future<bool> delete_image(int id) async
{
  var request = {"command": "delete_file", "args": [username, password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
      return data["result"];
    }
  return false;
}

Future<List<Event>> get_events_active_i_joined() async {
    if (me==null) {return []; }
    var request = {"command": "user_get_all_active_joined_events", "args": [username, password]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      List<Event> events = [];
      data["result"].forEach((e)=> {
        events.add(Event(e["id"], 
                  Group(e["groupid"], e["admin"], e["groupname"], e["groupdesc"]),
                  me!.id, e["eventname"], e["description"], DateTime.parse(e["date"])))
      });
      return events;
      }
    return [];
  }

Future<List<Transaction>> get_my_transactions() async {
  if (me==null) {return []; }
  var request = {"command": "transactions_get_of", "args": [username, password]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    List<Transaction> transactions = [];
    data["result"].forEach((e)=> {
      transactions.add(Transaction(e["id"], e["title"], User(e["userid1"], e["username1"]), User(e["userid2"], e["username2"]), double.parse(e["balance"].toString())))
    });
    return transactions;
    }
  return [];
}

Future<List<Transaction>> get_my_transactions_with(User l) async {
  if (me==null) {return []; }
  var request = {"command": "transactions_get_between", "args": [username, password, l.id]};
  var url = Uri.http(api_settings.host, jsonEncode(request));
  var response = await http.get(url);
  var data = jsonDecode(response.body);
  if (data["success"]) {
    List<Transaction> transactions = [];
    List o = order(me!, l);
    data["result"].forEach((e)=> {
      transactions.add(Transaction(e["id"], e["title"], o[0], o[1], double.parse(e["balance"].toString())))
    });
    return transactions;
    }
  return [];
}


bool logged_in = false;
String username = "";
String password = "";
const String image_signalizer =  "!-[]{}qimage_id:";


User? me;
