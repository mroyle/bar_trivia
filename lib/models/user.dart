class User {
  final String uid;
  final String firstName;
  final String lastName;
  final bool isAdmin;
  final bool isModerator;
  final bool hasBeenUpdated;

  User(
      {this.uid,
      this.firstName,
      this.lastName,
      this.isAdmin,
      this.isModerator,
      this.hasBeenUpdated});
}
