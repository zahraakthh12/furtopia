import 'package:flutter/material.dart'; // untuk widget Flutter
import 'package:firebase_auth/firebase_auth.dart'; // untuk autentikasi Firebase
import 'package:furtopia/model/firebase/user_firebase_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/service/firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/firebase/login/login_firebase_screen.dart';
import 'package:furtopia/view/firebase/profil_user/edit_profile_firebase_screen.dart';
import 'package:furtopia/view/firebase/profil_user/ongoing_firebase_order.dart';

class ProfileFirebaseScreen extends StatefulWidget {
  const ProfileFirebaseScreen({super.key});

  @override
  State<ProfileFirebaseScreen> createState() => _ProfileFirebaseScreenState();
}

class _ProfileFirebaseScreenState extends State<ProfileFirebaseScreen> {
  UserFirebaseModel? dataUser; // menyimpan data user yang diambil dari Firebase

  // menginisialisasi state dan memanggil getData
  void initState() {
    super.initState();
    getData();
  }

  // mengambil data user dari Firebase
  Future<void> getData() async {
    String? uid = await PreferenceHandler.getToken(); // ambil UID Firestore
    if (uid != null) {
      UserFirebaseModel? result = await FirebaseService.getUser(uid);
      setState(() {
        dataUser = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
        automaticallyImplyLeading: false, // menghilangkan tombol back
      ),
      body: Stack(children: [buildBackground(), buildLayer()]), // menumpuk background dan layer
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            height(5),
            Container(
              height: 160,
              padding: EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
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
                      CircleAvatar(
                        backgroundColor: AppColors.shape4.withOpacity(0.5),
                        radius: 40,
                        child: Image.asset(AppImages.person, height: 50),
                      ),
                      width(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${dataUser?.fullname ?? ""}",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: AppColors.black.withOpacity(0.4),
                                size: 15,
                              ),
                              width(5),
                              Text(
                                "${dataUser?.email ?? ""}",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.call_outlined,
                                color: AppColors.black.withOpacity(0.4),
                                size: 15,
                              ),
                              width(5),
                              Text(
                                "${dataUser?.phone ?? ""}",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  height(10),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shape4.withOpacity(0.75),
                        minimumSize: const Size(300, 40),
                        elevation: 6,
                        shadowColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (dataUser == null) return; // pastikan dataUser tidak null
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileFirebaseScreen(user: dataUser!), // menuju halaman edit profil
                          ),
                        );
                        // refresh data user setelah kembali dari halaman edit profil
                        if (updatedUser != null) {
                          setState(() {
                            dataUser = updatedUser; // perbarui data user dengan data yang diupdate
                          });
                        }
                      },
                      child: Text(
                        "Edit Profil",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            height(30),
            Container(
              height: 130,
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text1.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  height(20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderInProgressScreen(), // menuju halaman pesanan berlangsung
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: AppColors.shape4.withOpacity(0.75),
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
                          child: Image.asset(AppImages.box, height: 50),
                        ),
                      ),

                      width(20),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderInProgressScreen(), // menuju halaman pesanan berlangsung
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pesanan Berlangsung",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.black,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // logout button
            height(30),
            GestureDetector(
              onTap: () async {
                // Tampilkan dialog konfirmasi logout
                bool? confirmLogout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      "Konfirmasi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text("Apakah Anda yakin ingin keluar dari akun?"),
                    actions: [
                      TextButton(
                        child: Text("Batal"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.shape4,
                        ),
                        child: const Text(
                          "Keluar",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                // Jika user pilih "Keluar"
                if (confirmLogout == true) {
                  await FirebaseAuth.instance.signOut(); // logout Firebase
                  await PreferenceHandler.removeToken(); // hapus UID dari SharedPreferences

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginFirebaseScreen(), // kembali ke halaman login
                    ),
                  );
                }
              },

              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 90),
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
                child: Row(
                  children: [
                    Image.asset(AppImages.logout, height: 20),
                    width(10),
                    Text(
                      "Keluar dari akun",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            height(20),
            Column(
              children: [
                Image.asset(
                  AppImages.pet,
                  height: 40,
                  color: AppColors.black.withOpacity(0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // membuat background
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

  // membuat SizedBox untuk jarak
  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);
}
