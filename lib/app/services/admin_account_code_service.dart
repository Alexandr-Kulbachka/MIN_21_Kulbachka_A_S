import 'dart:convert';

import 'package:HelpHere/models/admin_account_code.dart';
import 'package:flutter/cupertino.dart';

import '../firebase/firebase_db.dart';

class AdminAccountCodeService extends ChangeNotifier {
  List<AdminAccountCode> _generatedCodes;

  List<AdminAccountCode> get generatedCodes => _generatedCodes;

  FBDataBase _fbDataBase;

  AdminAccountCodeService() {
    _fbDataBase = FBDataBase.getInstance();
    _generatedCodes = List<AdminAccountCode>();
  }

  Future<void> addNewCode({@required AdminAccountCode adminAccountCode}) async {
    var result = await _fbDataBase.addItem(
        itemName: AdminAccountCode.nameInBase,
        itemFields: adminAccountCode.getMap());
    if (result != null) {
      adminAccountCode.documentId = result;
      _generatedCodes.add(adminAccountCode);
      notifyListeners();
    }
  }

  Future<void> deleteCode({@required String codeDocumentId}) async {
    var result = await _fbDataBase.deleteItemById(
        itemName: AdminAccountCode.nameInBase, itemId: codeDocumentId);
    if (result) {
      _generatedCodes.removeWhere((item) => item.documentId == codeDocumentId);
      notifyListeners();
    }
  }

  Future<void> loadCodes({@required String authorId}) async {
    var items = await _fbDataBase.loadItemsByAttribute(
        itemName: AdminAccountCode.nameInBase,
        fieldName: 'authorId',
        fieldValue: authorId);
    if (items != null) {
      _generatedCodes = items.entries
          .map(
              (e) => AdminAccountCode.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
  }

  void clearLocalCodesStorage() {
    _generatedCodes.clear();
  }
}
