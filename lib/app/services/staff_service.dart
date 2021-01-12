import 'package:HelpHere/enums/roles_enum.dart';
import 'package:HelpHere/models/user.dart';
import 'package:flutter/cupertino.dart';

import '../firebase/firebase_db.dart';

class StaffService extends ChangeNotifier {
  List<User> _staff;

  List<User> get registeredVolunteers =>
      _staff.where((user) => user.isRegistered == true).toList();
  List<User> get unregisteredVolunteers =>
      _staff.where((user) => user.isRegistered == false).toList();
  List<User> get admins =>
      _staff.where((user) => user.role == Role.admin).toList();

  FBDataBase _fbDataBase;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  StaffService() {
    _fbDataBase = FBDataBase.getInstance();
    _staff = List<User>();
  }

  Future<void> awaitLoading() async {
    if (_isLoading) {
      await Future.doWhile(() async {
        await Future.delayed(Duration(microseconds: 500));
        return _isLoading == true;
      });
    }
  }

  Future<bool> deleteVolunteer({@required String volunteerDocumentId}) async {
    var result = await _fbDataBase.deleteItemById(
        itemName: User.nameInBase, itemId: volunteerDocumentId);
    if (result) {
      _staff.removeWhere((item) => item.documentId == volunteerDocumentId);
      notifyListeners();
    }
    return result;
  }

  Future<bool> updateVolunteerStatus(
      {@required String id, bool isRegistered}) async {
    var index = _staff.indexWhere((element) => element.id == id);
    _staff[index].isRegistered = isRegistered;
    var result = await _fbDataBase.updateItem(
        itemName: User.nameInBase,
        itemId: _staff[index].documentId,
        itemFields: _staff[index].getMap());
    notifyListeners();
    return result;
  }

  Future<void> loadAdmins() async {
    await awaitLoading();
    _isLoading = true;
    var items = await _fbDataBase.loadItemsByAttribute(
        itemName: User.nameInBase,
        fieldName: 'role',
        fieldValue: Role.admin.title);
    if (items != null) {
      _staff = items.entries
          .map((e) => User.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
    _isLoading = false;
  }

  Future<void> loadRegisteredVolunteers() async {
    await awaitLoading();
    _isLoading = true;
    var items = await _loadVolunteers(isRegistered: true);
    if (items != null) {
      _staff = items.entries
          .map((e) => User.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
    _isLoading = false;
  }

  Future<void> loadUnregisteredVolunteers() async {
    await awaitLoading();
    _isLoading = true;
    var items = await _loadVolunteers(isRegistered: false);
    if (items != null) {
      _staff = items.entries
          .map((e) => User.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
    _isLoading = false;
  }

  Future<Map<String, Map<String, dynamic>>> _loadVolunteers(
      {@required bool isRegistered}) async {
    var result = await _fbDataBase.loadItemsByAttribute(
        itemName: User.nameInBase,
        fieldName: 'isRegistered',
        fieldValue: isRegistered);
    return result;
  }

  void clearLocalVolunteersStorage() {
    _staff.clear();
  }
}
