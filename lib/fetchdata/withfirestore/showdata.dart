import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class Showdata extends StatefulWidget {
  const Showdata({super.key});

  @override
  State<Showdata> createState() => _ShowdataState();
}

class _ShowdataState extends State<Showdata> {

  final firestore = FirebaseFirestore.instance.collection("Users").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fetching Data from Firebase"),centerTitle: true,),
      
      body: StreamBuilder(stream: firestore,
          builder: (contact, snapshots){

          if(snapshots.connectionState == ConnectionState.active){

            if(snapshots.hasData){
              return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: CircleAvatar(child: Text("${index+1}"),),
                      title: Text(snapshots.data!.docs[index]["Email"]),
                      subtitle: Text(snapshots.data!.docs[index]["Phone"]),
                    );
                    

              });

            }else if(snapshots.hasError){
              return  Center(child: Text(snapshots.error.toString()),);
            }
            else{
              return Center(child: Text("No Data Found"),);
            }

          }else{
            return  Center(child: CircularProgressIndicator(),);
          }




          }),
      
      
      floatingActionButton: FloatingActionButton(onPressed: (){
        FirebaseFirestore.instance.collection("Users").doc("local1").set({
          "Email": "fixedid12@gmail.com",
          "Phone": "1114123333",
        });
        
      },child: Icon(Icons.add),),
    );
  }
}
