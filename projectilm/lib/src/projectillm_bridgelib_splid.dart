import 'projectillm_bridgelib_base.dart';
import 'api_settings.dart' as api_settings;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transaction {
  int id;
  String title;
  User from;
  User to;
  double balance;

  Transaction(this.id, this.title, this.from, this.to, this.balance);

  Transaction flipped()
  {
      return Transaction(id, title, from, to, balance);
  }

  Future<bool> delete() async {
    if (me==null) {return false; }
    var request = {"command": "transaction_delete", "args": [username, password, id]};
    var url = Uri.http(api_settings.host, jsonEncode(request));
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    if (data["success"]) {
      return data["result"];
    }
    return false;
  }

  @override
  int get hashCode => id;

}




Map<int, double> get_group_balances(List<Transaction> l)
{
  Map<int, double> balances = <int, double>{};
  for (Transaction t in l)
  {
    balances[t.from.id] = (balances[t.from.id]??0) + t.balance;
    balances[t.to.id] = (balances[t.to.id]??0) - t.balance;
  }
  return balances;
}

double sum_transactions(List<Transaction> l){
  double s = 0;
  for (Transaction t in l)
  {
    s+=t.balance; 
  }
  return s;
}

double sum_transactions_for(List<Transaction> l, User i){
  double s = 0;
  for (Transaction t in l)
  {
    if (i==t.from)
    {
      s+=t.balance;     
    }
    else if (i==t.to)
    {
      s-=t.balance;     
    }
  }
  return s;
}