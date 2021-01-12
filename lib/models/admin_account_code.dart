import 'package:flutter/cupertino.dart';

class AdminAccountCode {
  static String get nameInBase => 'admin_account_codes';

  String documentId;

  String authorId;
  String accountCode;

  Map<String, dynamic> getMap() {
    return {
      'authorId': authorId,
      'accountCode': accountCode,
    };
  }

  AdminAccountCode({this.authorId, this.accountCode, this.documentId});

  AdminAccountCode.fromMap({Map data, this.documentId}) {
    this.authorId = data['authorId'];
    this.accountCode = data['accountCode'];
  }
}
