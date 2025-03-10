
import 'package:flutter/material.dart';
import 'package:sql_lite_databse/demo1.dart';
import 'package:sql_lite_databse/personInfo.dart';

class Run1 extends StatefulWidget {
  const Run1({super.key});

  @override
  State<Run1> createState() => _Run1State();
}

class _Run1State extends State<Run1> {
  MyClass1 db = MyClass1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Practicle"),
      ),
      body: FutureBuilder
        (
          future: db.selectAllUsers(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(snapshot.data![index]['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          db.deleteUser(snapshot.data![index]['id']);
                          setState(() {});
                        }, icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    TextEditingController nameController = TextEditingController(text: snapshot.data![index]['name']);
                                    return AlertDialog(
                                      title: Text("DATA ENTRY UPDATE"),
                                      content: TextField(controller: nameController,),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: (){
                                              db.updateUser({'id':snapshot.data![index]['id'],'name':nameController.text});
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            child: Text("Update")
                                        )
                                      ],
                                    );
                                  }
                              ).then((value)=>setState(() {}));
                            },
                            icon: Icon(Icons.edit)
                        ),
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PersonInfo(map: snapshot.data![index])));
                        }, icon: Icon(Icons.person))
                      ],
                    ),
                  );
                }
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
                context: context,
                builder: (context){
                  TextEditingController nameController = TextEditingController();
                  return AlertDialog(
                    title: Text("DATA ENTRY"),
                    content: TextField(controller: nameController,),
                    actions: [
                      ElevatedButton(
                          onPressed: (){
                            db.insertUser({'name':nameController.text});
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Text("Submit")
                      )
                    ],
                  );
                }
            ).then((value)=>setState(() {}));
          },
        child: Icon(Icons.add),
      ),
    );
  }
}
