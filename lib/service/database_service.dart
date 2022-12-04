import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  Future updateUser(String username, String email) async {
    return await userCollection.doc(uid).set({
      "username": username,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }

  Future getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupsDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupsDocumentReference.update({
      "groupId": groupsDocumentReference.id,
      "members": FieldValue.arrayUnion(["${uid}_${userName}"])
    });

    DocumentReference userDocumentReference = await userCollection.doc(uid);
    await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupsDocumentReference.id}_$groupName"])
    });
  }

  Future getAdmin(String groupId) async {
    DocumentReference d = await groupCollection.doc(groupId);
    DocumentSnapshot snapshot = await d.get();
    return snapshot["admin"];
  }

  Future getChats(String groupId) async {
    return await groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getMembers(String groupId) async {
    return await groupCollection.doc(groupId).snapshots();
  }

  Future getGroupByName(String groupName) async {
    QuerySnapshot snapshot =
        await groupCollection.where("groupName", isEqualTo: groupName).get();
    return snapshot;
  }

  Future<bool> isJoined(String groupId, String groupName) async {
    DocumentReference usr = await userCollection.doc(uid);
    DocumentSnapshot snapshot = await usr.get();
    List<dynamic> groups = await snapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference usr = await userCollection.doc(uid);
    DocumentReference grp = await groupCollection.doc(groupId);

    DocumentSnapshot snapshot = await usr.get();
    List<dynamic> groups = await snapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      usr.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      grp.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      usr.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      grp.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
