import 'package:flutter/material.dart';
import 'package:json_api/apiService.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Api ap = Api();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Project"),
      ),
      body: FutureBuilder(
          future: ap.getUser(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else if (snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      title: Text(snapshot.data![index]["name"]),
                      subtitle: Text(snapshot.data![index]["id"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: (){
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      TextEditingController name = TextEditingController(text: snapshot.data![index]['name']);
                                      return AlertDialog(
                                        title: Text("Add data"),
                                        content: TextField(controller: name,),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                await ap.updateUser({'name':name.text,'id':snapshot.data![index]['id']});
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              },
                                              child: Text("Update")
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              icon: Icon(Icons.edit)
                          ),
                          IconButton(onPressed: () async {
                            await ap.deleteUser(snapshot.data![index]["id"]);
                            setState(() {});
                          }, icon: Icon(Icons.delete)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.person))
                        ],
                      ),
                    );
                  }
              );
            }
            else return Center(child: Text("No data"),);
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                TextEditingController name = TextEditingController();
                return AlertDialog(
                  title: Text("Add data"),
                  content: TextField(controller: name,),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await ap.addUser({'name':name.text});
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Text("Submit")
                    )
                  ],
                );
              }
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
