import 'dart:convert';
import 'package:http/http.dart' as http;

class Api{
  String path = "https://67b56673a9acbdb38ed22118.mockapi.io/users";
  // String path = "https://67b563e4a9acbdb38ed21331.mockapi.io/user";

  Future<List<dynamic>> getUser()async{
    var res = await http.get(Uri.parse(path),);
    List<dynamic> data = jsonDecode(res.body);
    return data;
  }
  Future<Map<String,dynamic>> getUserById(String id)async{
    var res = await http.get(Uri.parse("$path/$id"),);
    dynamic data = jsonDecode(res.body);
    return data;
  }
  Future<void> addUser(Map<String,dynamic> map)async{
    var res = await http.post(Uri.parse(path), body: map,);
  }
  Future<void> deleteUser(String id)async{
    var res = await http.delete(Uri.parse("$path/$id"),);
  }
  Future<void> updateUser(Map<String, dynamic> map) async {
    var res = await http.put(Uri.parse("$path/${map['id']}"), body: map);
  }

}