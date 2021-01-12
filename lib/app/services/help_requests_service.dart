import 'package:HelpHere/models/admin_account_code.dart';
import 'package:HelpHere/models/help_request.dart';
import 'package:flutter/cupertino.dart';

import '../firebase/firebase_db.dart';

class HelpRequestsService extends ChangeNotifier {
  List<HelpRequest> _helpRequests;

  List<HelpRequest> get approvedHelpRequests =>
      _helpRequests.where((element) => element.isApproved == true).toList();
  List<HelpRequest> get unApprovedHelpRequests =>
      _helpRequests.where((element) => element.isApproved == false).toList();

  FBDataBase _fbDataBase;

  HelpRequestsService() {
    _fbDataBase = FBDataBase.getInstance();
    _helpRequests = List<HelpRequest>();
  }

  Future<void> addNewHelpRequest({@required HelpRequest helpRequest}) async {
    var result = await _fbDataBase.addItem(
        itemName: AdminAccountCode.nameInBase,
        itemFields: helpRequest.getMap());
    if (result != null) {
      helpRequest.documentId = result;
      _helpRequests.add(helpRequest);
      notifyListeners();
    }
  }

  Future<bool> updateHelpRequestStatus(
      {@required HelpRequest helpRequest, bool isApproved}) async {
    var index = _helpRequests.indexOf(helpRequest);
    _helpRequests[index].isApproved = isApproved;
    var result = await _fbDataBase.updateItem(
        itemName: HelpRequest.nameInBase,
        itemId: _helpRequests[index].documentId,
        itemFields: _helpRequests[index].getMap());
    notifyListeners();
    return result;
  }

  Future<bool> deleteHelpRequest(
      {@required String helpRequestDocumentId}) async {
    var result = await _fbDataBase.deleteItemById(
        itemName: HelpRequest.nameInBase, itemId: helpRequestDocumentId);
    if (result) {
      _helpRequests
          .removeWhere((item) => item.documentId == helpRequestDocumentId);
      notifyListeners();
    }
    return result;
  }

  Future<void> loadApprovedHelpRequests() async {
    var items = await _loadRequests(isApproved: true);
    if (items != null) {
      _helpRequests = items.entries
          .map((e) => HelpRequest.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
  }

  Future<void> loadUnapprovedHelpRequests() async {
    var items = await _loadRequests(isApproved: false);
    if (items != null) {
      _helpRequests = items.entries
          .map((e) => HelpRequest.fromMap(data: e.value, documentId: e.key))
          .toList();
      notifyListeners();
    }
  }

  Future<Map<String, Map<String, dynamic>>> _loadRequests(
      {@required bool isApproved}) async {
    var result = await _fbDataBase.loadItemsByAttribute(
        itemName: HelpRequest.nameInBase,
        fieldName: 'isApproved',
        fieldValue: isApproved);
    return result;
  }

  void clearLocalHelpRequestsStorage() {
    _helpRequests.clear();
  }
}
