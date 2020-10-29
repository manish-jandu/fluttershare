import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUSerId;
  EditProfile({this.currentUSerId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  String profileImageUrl;
  bool _bioValid = true;
  bool _displayNameValid = true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUSerId).get();
    User user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    profileImageUrl = user.photoUrl;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
              hintText: 'Update Display Name',
              errorText: _displayNameValid ? null : 'Display Name too short.'),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
              hintText: 'Update Bio',
              errorText: _bioValid ? null : 'Bio too Long.'),
        )
      ],
    );
  }

  void updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
      bioController.text.trim().length > 100 || bioController.text.isEmpty
          ? _bioValid = false
          : _bioValid = true;
    });
    if (_bioValid && _displayNameValid) {
      usersRef.doc(widget.currentUSerId).update({
        'displayName': displayNameController.text,
        'bio': bioController.text
      });
      SnackBar snackBar = SnackBar(
        content: Text('Profile Updated'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void logout() {
    googleSignIn.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              CachedNetworkImageProvider(profileImageUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDisplayNameField(),
                            buildBioField(),
                            RaisedButton(
                              child: Text(
                                'Update Profile',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: updateProfileData,
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: FlatButton.icon(
                                onPressed: logout,
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                label: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
