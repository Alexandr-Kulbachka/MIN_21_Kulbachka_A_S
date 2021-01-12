class HelpRequest {
  static String get nameInBase => 'help_requests';

  String documentId;

  String candidatesName;
  String candidatesPatronymic;
  String candidatesSurname;
  int candidatesAge;
  String phoneNumber;
  String email;
  String address;
  String description;

  bool isApproved;

  Map<String, dynamic> getMap() {
    return {
      'candidatesName': candidatesName,
      'candidatesPatronymic': candidatesPatronymic,
      'candidatesSurname': candidatesSurname,
      'candidatesAge': candidatesAge,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'description': description,
      'isApproved' : isApproved,
    };
  }

  HelpRequest({
    this.candidatesName,
    this.candidatesPatronymic,
    this.candidatesSurname,
    this.candidatesAge = 0,
    this.phoneNumber,
    this.email,
    this.address,
    this.description,
    this.isApproved = false
  });

  HelpRequest.fromMap({Map<String, dynamic> data, this.documentId}) {
    this.candidatesName = data['candidatesName'];
    this.candidatesPatronymic = data['candidatesPatronymic'];
    this.candidatesSurname = data['candidatesSurname'];
    this.candidatesAge = data['candidatesAge'];
    this.phoneNumber = data['phoneNumber'];
    this.email = data['email'];
    this.address = data['address'];
    this.description = data['description'];
    this.isApproved = data['isApproved'];
  }
}
