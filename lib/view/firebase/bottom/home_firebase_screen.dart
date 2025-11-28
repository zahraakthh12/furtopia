import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/style/text_style.dart';
import 'package:furtopia/view/firebase/petclinic/petchoose_firebase_screen.dart';
import 'package:furtopia/view/firebase/petedu/peteducation_firebase_screen.dart';
import 'package:furtopia/view/firebase/petshop/petshop_firebase_screen.dart';

class HomeScreenFirebase extends StatefulWidget {
  const HomeScreenFirebase({super.key});

  @override
  State<HomeScreenFirebase> createState() => _HomeScreenFirebaseState();
}

class _HomeScreenFirebaseState extends State<HomeScreenFirebase> {
  UserFirebaseModel? dataUser;

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String? uid = await PreferenceHandler.getToken(); // ambil UID user
    log(uid.toString());
    if (uid != null) {
      final result = await FirebaseService.getUser(uid);

      setState(() {
        dataUser = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Halo,", style: TextStyle(fontSize: 16)),
                    Text(
                      "${dataUser?.fullname ?? ""}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height(25),
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    offset: Offset(2, 2),
                    spreadRadius: 3,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppImages.pet, height: 60),
                      width(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat datang di FurTopia!",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text1.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Layanan perawatan hewan \nterpercaya"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            height(30),
            Text(
              "Layanan Kami",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text1.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),

            height(10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetShopFirebaseScreen(),
                  ),
                );
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.shape4.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2),
                      spreadRadius: 3,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.shape4.withOpacity(0.3),
                                AppColors.white,
                              ],
                              begin: AlignmentGeometry.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.25),
                                offset: Offset(2, 2),
                                spreadRadius: 3,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Image.asset(AppImages.shop, height: 60),
                        ),
                        width(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pet Shop",
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Belanja kebutuhan, makanan, \ndan aksesoris hewan",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            height(20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetChooseFirebaseScreen(),
                  ),
                );
              },
              child: Container(
                height: 150,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.shape4.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2),
                      spreadRadius: 3,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.shape4.withOpacity(0.3),
                                AppColors.white,
                              ],
                              begin: AlignmentGeometry.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.25),
                                offset: Offset(2, 2),
                                spreadRadius: 3,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Image.asset(AppImages.clinic, height: 60),
                        ),
                        width(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pet Clinic",
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("Booking perawatan hewan"),

                            height(5),
                            BuildWidget1(
                              imagePath: AppImages.homeservice,
                              text: "Home Service",
                            ),
                            height(8),
                            BuildWidget1(
                              imagePath: AppImages.offlinevisit,
                              text: "In-Clinic Service",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            height(20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EduFirebaseScreen()),
                );
              },
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.shape4.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2),
                      spreadRadius: 3,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.shape4.withOpacity(0.3),
                                AppColors.white,
                              ],
                              begin: AlignmentGeometry.topLeft,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.25),
                                offset: Offset(2, 2),
                                spreadRadius: 3,
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Image.asset(AppImages.book, height: 60),
                        ),
                        width(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pet Education",
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Artikel, tips, dan video edukasi \nperawatan hewan",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            height(30),
            Text(
              "Tips Perawatan Hewan 💡",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text1.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            height(10),
            buildTipsWidget("💉 Vaksinasi rutin setiap 6 bulan"),
            height(10),
            buildTipsWidget("🚿 Grooming berkala untuk kesehatan bulu"),
          ],
        ),
      ),
    );
  }

  Container buildTipsWidget(String text) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.shape1.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(children: [Text(text, style: TextStyle(fontSize: 12))]),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background4),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Container boxScreen(){
  //   String? text;
  //   Image? image;
  //   Icon? icon;
  //   return Container(
  //     height:
  //   );
  // }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
