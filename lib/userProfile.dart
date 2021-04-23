class UserProfile {
  String uid;
  String name;
  String address;
  String email;

  UserProfile(this.uid, this.name, this.email, this.address);
  Map<String, dynamic> toJson() =>
      {'name': name, 'email': email, 'address': address, 'uid': uid};
}
