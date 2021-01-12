import 'package:flutter/cupertino.dart';

import '../firebase/firebase_db.dart';
import '../../models/user.dart';

class AccountService extends ChangeNotifier {
  User _account = User('');

  User get account => _account;

  FBDataBase _fbDataBase;

  AccountService() {
    _fbDataBase = FBDataBase.getInstance();
  }

  Future<void> createAccount({User user}) async {
    if (user == null) {
      user = _account;
    }
    var result = await _fbDataBase.addItem(
        itemName: User.nameInBase, itemFields: user.getMap());
    if (result != null) {
      user.documentId = result;
      _account = user;
    }
  }

  Future<bool> updateAccountInfo({@required User user}) async {
    var result = await _fbDataBase.updateItem(
        itemName: User.nameInBase,
        itemId: user.documentId,
        itemFields: user.getMap());
    if (result) {
      _account = user;
      notifyListeners();
    }
    return result;
  }

  Future<void> loadAccount({@required String id}) async {
    var items = await _fbDataBase.loadItemsByAttribute(
        itemName: User.nameInBase, fieldName: 'id', fieldValue: id);
    if (items != null && items.entries.isNotEmpty) {
      _account = User.fromMap(
          data: items.entries.first.value, documentId: items.entries.first.key);
    }
  }

  void clearLocalAccountInfo() {
    _account = null;
  }
}
