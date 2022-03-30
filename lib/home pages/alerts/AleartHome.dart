import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../models.dart';
import 'AddAleart.dart';
import 'UpdateAleart.dart';
import 'notification.dart';
import '../../models.dart';


class AleartHome extends StatefulWidget {
  AleartHome({Key key}) : super(key: key);

  @override
  _AleartHomeState createState() => _AleartHomeState();
}

class _AleartHomeState extends State<AleartHome> {
  Icon unActiveNotification =
      Icon(Icons.notifications_none_sharp, color: iconColor);
  Icon ActiveNotification = Icon(Icons.notifications_active, color: iconColor);
  CollectionReference aleartCollection =
      FirebaseFirestore.instance.collection("medical");
  var notificationID = createUnidID();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            drawer: drawer(context),
            appBar: AppBar(backgroundColor: appColor),
            body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//bacground image------------------------------
                  Expanded(
                    flex: 2,
                    child: containerWithImage(context, height, "midical4.jpg",
                        "تنبيهات بمواعيد الادوية"),
                  ),

//fields----------------------------------------
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buttomText(
                      context,
                      "اضافة تنبيه",
                      15.0,
                      white,
                      () {
                        goToPage(context, AddAleart());
                      },
                      evaluation: 5,
                    ),
                  ),
                  StreamBuilder(
                      stream: aleartCollection
                          .where("UserId",
                              isEqualTo: FirebaseAuth.instance.currentUser.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshat) {
                        if (snapshat.hasError) {
                          return Text("Connection error");
                        }
                        if (snapshat.hasData) {
                          return Expanded(
                              flex: 4, child: getMedical(context, snapshat));
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),

//-------------------------------------------------------------------------------------
                ]))));
  }

  Widget getMedical(BuildContext context, AsyncSnapshot snapshat) {
    return snapshat.data.docs.length> 0
        ? ListView.builder(
            itemCount: snapshat.data.docs.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 200,
                  child: InkWell(
                    onTap: () {
                      goToPage(
                          context,
                          UpdateAleart(
                            medicalId: snapshat.data.docs[i].id,
                            userImage:
                                snapshat.data.docs[i].data()['imagePath'],
                            userMedicalName:
                                snapshat.data.docs[i].data()['medicalName'],
                            userMedicalType:
                                snapshat.data.docs[i].data()['type'],
                            userNotificationId:
                                snapshat.data.docs[i].data()['notificaton_id'],
                            userRepate: snapshat.data.docs[i].data()['repet'],
                            userActive:
                                snapshat.data.docs[i].data()['isActive'],
                            userTime:
                                snapshat.data.docs[i].data()['medicalTime'],
                            userHours: snapshat.data.docs[i].data()['hours'],
                            userMint: snapshat.data.docs[i].data()['mint'],
                          ));
                    },
                    child: Card(
                        elevation: 10,
                        color: white,
                        child: Row(
                          children: [
                            //image name-----------------------------------------------------------------
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4)),
                                child: Image.network(
                                  "${snapshat.data.docs[i].data()['imagePath']}",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            //details----------------------------------------------------------------
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 11),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
//name--------------------------------------------------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.medical_services_rounded,
                                            color: iconColor),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        text(
                                            context,
                                            "${snapshat.data.docs[i].data()['medicalName']}",
                                            14,
                                            appColor),
                                        Spacer(),
//delete------------------------------------------------------------
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: IconButton(
                                                icon: Icon(Icons.delete_rounded,
                                                    color: iconColor),
                                                onPressed: () {
                                                  delete(
                                                      snapshat.data.docs[i].id,
                                                      snapshat.data.docs[i]
                                                          .data()['imagePath'],
                                                      snapshat.data.docs[i]
                                                              .data()[
                                                          'notificaton_id']);
                                                })),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
//time--------------------------------------------------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.alarm_outlined,
                                            color: iconColor),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        text(
                                            context,
                                            "${snapshat.data.docs[i].data()['medicalTime']}",
                                            14,
                                            appColor),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
//type--------------------------------------------------
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.medical_services_outlined,
                                            color: iconColor),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        text(
                                            context,
                                            "${snapshat.data.docs[i].data()['type']}",
                                            14,
                                            appColor),
                                      ],
                                    ),

//notification--------------------------------------------------
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: IconButton(
                                        onPressed: () {
                                          if (snapshat.data.docs[i]
                                                  .data()['isActive'] ==
                                              true) {
//اذا كانت الاشعرات مفعله يتم الغاها---------------------------
                                            showYesNoDaylog(
                                                context,
                                                "ايقاف الاشعارات",
                                                "هل تريد ايقاف الاشعارات لهذا الدواء؟",
                                                //yes option-----------------------------------------------------------
                                                () {
                                              Navigator.pop(context);
                                              cancelNotification(snapshat
                                                  .data.docs[i]
                                                  .data()['notificaton_id']);
                                              UpdateActiveMedical(
                                                  "${snapshat.data.docs[i].id}",
                                                  false,
                                                  0);
                                              //يتم االانتقال الي الواجهة الرئيسيه اتوماتيك
                                            },
                                                //no option-----------------------------------------------------------
                                                () {
                                              Navigator.pop(context);
                                            });
                                          } else {
                                            createNotification(
                                             notificationID,
                                              context,
                                              snapshat.data.docs[i]
                                                  .data()['medicalName'],
                                              snapshat.data.docs[i]
                                                  .data()['hours'],
                                              snapshat.data.docs[i]
                                                  .data()['mint'],
                                              snapshat.data.docs[i]
                                                          .data()['repet'] ==
                                                      "لا"
                                                  ? false
                                                  : true,
                                              snapshat.data.docs[i]
                                                  .data()['imagePath'],
                                            );

                                            UpdateActiveMedical(
                                                snapshat.data.docs[i].id,
                                                true,
                                                notificationID);
                                          }
                                        },
                                        icon: snapshat.data.docs[i]
                                                    .data()['isActive'] ==
                                                true
                                            ? ActiveNotification
                                            : unActiveNotification,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              );
            })
        : Align(
            alignment: Alignment.center,
            child: text(context, "لاتوجد بيانات لعرضها حاليا", 14, appColor,fontWeight: FontWeight.bold));
  }

//-------------------------------------------------------------------------
  void UpdateActiveMedical(id, bool isActiv, int notId) {
    print("update id to---------$notId");
    lodding(context, "");
    FirebaseFirestore.instance
        .collection('medical')
        .doc(id)
        .update({"isActive": isActiv, "notificaton_id": notId}).then((value) {
      Navigator.pop(context);
      showDialogMethod(context, isActiv ? 'تلقي اشعارات' : 'ايقاف الاشعارات',
          'تمت العملية بنجاح');
    });
  }

  void delete(id, String imageURL, int notId) {
    showYesNoDaylog(
      context,
      'حذف تنبية',
      'هل انت متاكد من اكمال عملية الحذف؟',
      () async {
        Navigator.pop(context);
        lodding(context, "حذف تنبية");
        cancelNotification(notId);
        await FirebaseStorage.instance.refFromURL(imageURL).delete();
        await FirebaseFirestore.instance
            .collection('medical')
            .doc(id)
            .delete()
            .then((value) {
          Navigator.pop(context);
          showDialogMethod(context, 'حذف تنبية', 'تمت العملية بنجاح');
        });
      },
      () async {
        Navigator.pop(context);
      },
    );
  }
}
