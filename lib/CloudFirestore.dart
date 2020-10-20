import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cloud_Firestore extends StatefulWidget {
  @override
  _Cloud_FirestoreState createState() => _Cloud_FirestoreState();
}

class _Cloud_FirestoreState extends State<Cloud_Firestore> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'full_name': "witawatd", // John Doe
          'company': "control c", // Stokes and Sons
          'age': 23 // 42
        })
        .then((value) => print("add ===> success"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Firestore"),
        actions: [
          FlatButton(
            child: Text("Add Data"),
            textColor: Colors.white,
            onPressed: () {
              addUser();
            },
          )
        ],
      ),
      body: Center(
        child:StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document.data()['full_name']),
                  subtitle: new Text(document.data()['company']),
                );
              }).toList(),
            );
          },
        )
      ),
    );
  }
}
