import '../enums/roles_enum.dart';

class User {
  static String get nameInBase => 'users';

  String documentId;

  String id;
  String name;
  String surname;
  int age;
  String email;
  Role role;
  String specialty;
  List<String> drivingLicenseCategories;
  bool psychologicalPreparationCourse;

  bool isRegistered;

  Map<String, dynamic> getMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'age': age,
      'email': email,
      'role': role.title,
      'specialty': specialty,
      'drivingLicenseCategories': drivingLicenseCategories,
      'psychologicalPreparationCourse': psychologicalPreparationCourse,
      'isRegistered': isRegistered
    };
  }

  User(this.id,
      {this.documentId,
      this.name = '',
      this.surname = '',
      this.role,
      this.email = '',
      this.age = 0,
      this.specialty = '',
      this.drivingLicenseCategories,
      this.psychologicalPreparationCourse,
        this.isRegistered});

  User.fromMap({Map<String, dynamic> data, this.documentId}) {
    this.id = data['id'];
    this.name = data['name'];
    this.surname = data['surname'];
    this.role = roleFromString(data['role']);
    this.email = data['email'];
    this.age = data['age'];
    this.specialty = data['specialty'];
    this.drivingLicenseCategories = data['drivingLicenseCategories'];
    this.psychologicalPreparationCourse =
        data['psychologicalPreparationCourse'];
    this.isRegistered = data['isRegistered'];
  }
}
