// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sql_lite_databse/demo.dart';
//
// class Run extends StatefulWidget {
//   const Run({super.key});
//
//   @override
//   State<Run> createState() => _RunState();
// }
//
// class _RunState extends State<Run> {
//   MyDatabse databse = MyDatabse();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.pink.shade50,
//             centerTitle: true,
//             title: Text("Crud Operation",style: TextStyle(color: Colors.black),),
//           ),
//           body: FutureBuilder(
//               future: databse.selectAllState(),
//               builder: (context, snapshot) {
//                 if(snapshot.connectionState == ConnectionState.waiting){
//                   return Center(child: CircularProgressIndicator(),);
//                 }else if (snapshot.hasData) {
//                   return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(snapshot.data![index]["state_name"]),
//                           trailing: Container(
//                             width: 100,
//                             child: Row(
//                               children: [
//                                 IconButton(
//                                     onPressed: () async {
//                                       await databse.deleteState(snapshot.data![index]["state_id"]);
//                                       setState(() {});
//                                     },
//                                     icon: Icon(Icons.delete)
//                                 ),
//                                 IconButton(
//                                     onPressed: (){
//                                       showDialog(
//                                         context: context,
//                                         builder: (context) {
//                                           TextEditingController stateController = TextEditingController(
//                                             text: snapshot.data![index]["state_name"]
//                                           );
//                                           return AlertDialog(
//                                             title: Text("Edit"),
//                                             content: TextField(
//                                               controller: stateController,
//                                             ),
//                                             actions: [
//                                               ElevatedButton(
//                                                   onPressed: ()async{
//                                                     await databse.updateState({"state_name":stateController.text,"state_id":snapshot.data![index]["state_id"]});
//                                                     Navigator.pop(context);
//                                                     setState(() {
//                                                     });
//                                                   },
//                                                   child: Text("Submit")
//                                               )
//                                             ],
//                                           );
//                                         },
//                                       ).then((value) => setState((){}));
//                                     },
//                                     icon: Icon(Icons.edit)
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                   );
//                 }
//                 return Center(child: Text("No Data Found"),);
//               },
//           ),
//           floatingActionButton: FloatingActionButton(
//               onPressed: (){
//                 showDialog(
//                     context: context,
//                     builder: (context) {
//                       TextEditingController stateController = TextEditingController();
//                       return AlertDialog(
//                         title: Text("Add"),
//                         content: TextField(
//                           controller: stateController,
//                         ),
//                         actions: [
//                           ElevatedButton(
//                               onPressed: ()async{
//                                 await databse.insertState({"state_name":stateController.text});
//                                 Navigator.pop(context);
//                                 setState(() {
//                                 });
//                               },
//                               child: Text("Submit")
//                           )
//                         ],
//                       );
//                     },
//                 ).then((value) => setState((){}));
//               },
//               child: Icon(Icons.add),
//           ),
//         )
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sql_lite_databse/demo.dart';

class Run extends StatefulWidget {
  const Run({super.key});

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> {
  final MyDatabse database = MyDatabse();

  void _showDialog({String title = "Add", Map<String, dynamic>? data}) {
    TextEditingController controller = TextEditingController(text: data?['state_name']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (data == null) {
                await database.insertState({"state_name": controller.text});
              } else {
                await database.updateState({"state_name": controller.text, "state_id": data["state_id"]});
              }
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade50,
        centerTitle: true,
        title: const Text("CRUD Operation", style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder(
        future: database.selectAllState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var item = snapshot.data![index];
              return ListTile(
                title: Text(item["state_name"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await database.deleteState(item["state_id"]);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => _showDialog(title: "Edit", data: item),
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

