import 'package:aplikacija2/help/databaseservice.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplikacija2/help/authentification.dart';

class UserDataCollection extends StatefulWidget {
  const UserDataCollection({super.key});

  @override
  State<UserDataCollection> createState() => _UserDataCollectionState();
}

class _UserDataCollectionState extends State<UserDataCollection> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  String uid = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    getUidFromDatabaseService();
  }

  getUserData() async {
    await Helpfunction.getUserEmailSf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await Helpfunction.getUserNameSf().then((val) {
      setState(() {
        username = val!;
      });
    });
  }

  void getUidFromDatabaseService() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUid = user.uid;
      DatabaseService databaseService = DatabaseService(currentUid);
      String? dbUid = await databaseService.getUid();

      setState(() {
        uid = dbUid ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
