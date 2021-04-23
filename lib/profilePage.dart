import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/userProfile.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
//   /// The page title.
  final String title = 'Profile';
  final FirebaseUser user;

  ProfilePage({Key key, this.user}) : super(key: key);

//
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserProfile _userProfile =
        UserProfile(widget.user.uid, null, widget.user.email, null);

    UserProfileWidget profileWidget =
        UserProfileWidget(widget.user, _userProfile);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
                textColor: Colors.white,
                onPressed: () async {},
                child: const Text('Sign out'));
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            // _UserInfoCard(widget.user),
            profileWidget
          ],
        );
      }),
    );
  }
}

class UserProfileWidget extends StatefulWidget {
  final FirebaseUser user;
  final UserProfile _userProfile;

  const UserProfileWidget(this.user, this._userProfile);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  TextEditingController _nameController;
  TextEditingController _addressController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _nameController.text = widget._userProfile.name;
    _addressController.text = widget._userProfile.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._userProfile.name == null) {
      Firestore.instance
          .collection("profiles")
          .document(widget.user.uid)
          .get()
          .then((doc) {
        if (doc != null && doc.data != null) {
          widget._userProfile.name = doc.data["name"];
          widget._userProfile.address = doc.data["address"];
          _nameController.text = widget._userProfile.name;
          _addressController.text = widget._userProfile.address;
          setState(() {});
        }
      });
    }
    return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (widget.user != null)
                    Text(
                        widget.user == null
                            ? 'Not signed in'
                            : '${widget.user.isAnonymous ? 'User is anonymous\n\n' : ''}'
                                'Email: ${widget.user.email}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              widget._userProfile.uid = widget.user.uid;
                              widget._userProfile.email = widget.user.email;
                              widget._userProfile.name = _nameController.text;
                              widget._userProfile.address =
                                  _addressController.text;
                              Firestore.instance
                                  .collection('profiles')
                                  .document(widget.user.uid)
                                  .setData(widget._userProfile.toJson());
                            }
                          },
                          child: const Text('Save'),
                        )),
                  ),
                ])));
  }
}
