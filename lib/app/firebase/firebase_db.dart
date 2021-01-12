import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FBDataBase {
  FirebaseFirestore _firestore;

  FBDataBase._constructor() {
    _firestore = FirebaseFirestore.instance;
  }

  static FBDataBase _instance;

  static FBDataBase getInstance() {
    if (_instance == null) {
      _instance = FBDataBase._constructor();
    }
    return _instance;
  }

  Future<String> addItem(
      {String itemName, Map<String, dynamic> itemFields}) async {
    CollectionReference collectionReference = _firestore.collection(itemName);
    try {
      DocumentReference documentReference =
          await collectionReference.add(itemFields);
      return documentReference.id;
    } catch (e) {
      log('Error caught during adding $itemName to the FB data base!');
      return null;
    }
  }

  Future<bool> updateItem(
      {String itemName, String itemId, Map<String, dynamic> itemFields}) async {
    CollectionReference collectionReference = _firestore.collection(itemName);
    try {
      await collectionReference.doc(itemId).update(itemFields);
      return true;
    } catch (e) {
      log('Error caught during adding $itemName to the FB data base!');
      return false;
    }
  }

  Future<bool> deleteItemById({String itemName, String itemId}) async {
    CollectionReference collectionReference = _firestore.collection(itemName);
    try {
      await collectionReference.doc(itemId).delete();
      return true;
    } catch (e) {
      log('Error caught during deleting $itemName from the FB data base!');
      return false;
    }
  }

  Future<Map<String, Map<String, dynamic>>> loadItemsByAttribute(
      {String itemName, String fieldName, dynamic fieldValue}) async {
    CollectionReference collectionReference = _firestore.collection(itemName);
    try {
      var response = await collectionReference
          .where(fieldName, isEqualTo: fieldValue)
          .get();
      return Map.fromIterable(response.docs,
          key: (e) => e.id, value: (e) => e.data());
    } catch (e) {
      log('Error caught during loading $itemName from the FB data base!');
      return null;
    }
  }
}
