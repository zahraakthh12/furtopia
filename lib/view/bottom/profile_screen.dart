import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/user_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/login/login_screen.dart';
import 'package:furtopia/view/profil_user/profil_edit_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final customFont = 'Poppins';
  UserModel? dataUser;

    void initState(){
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var id = await PreferenceHandler.getID();
    if(id != null){
      UserModel? result = await DBHelper.getUser(id);
      setState(() {
        dataUser = result;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Profil Saya", style: TextStyle(fontFamily: customFont, fontWeight: FontWeight.bold, fontSize: 20),), backgroundColor: AppColors.shape4.withOpacity(0.75), automaticallyImplyLeading: false,),
            body: Stack(children: [buildBackground(), buildLayer()]));
  }

  SafeArea buildLayer(){
    return SafeArea(
      child: 
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [

          height(5),
          Container(height: 160,
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
           decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15), 
           boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
           offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar( backgroundColor: AppColors.shape4.withOpacity(0.5),
                    radius: 40,
                    child: Image.asset(AppImages.person, height: 50,)),
                  width(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${dataUser?.fullname ?? ""}", style: TextStyle(fontFamily: customFont, fontSize: 20, color: AppColors.black, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Icon(Icons.email_outlined, color: AppColors.black.withOpacity(0.4), size: 15),
                          width(5),
                          Text("${dataUser?.email ?? ""}", style: TextStyle(fontFamily: customFont, fontSize: 12),),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.call_outlined, color: AppColors.black.withOpacity(0.4), size: 15),
                          width(5),
                          Text("${dataUser?.phone ?? ""}", style: TextStyle(fontFamily: customFont, fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              height(10),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.shape4.withOpacity(0.75), minimumSize: const Size(300, 40),
                  elevation: 6, shadowColor: AppColors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))),
                  onPressed: () async {
                    if (dataUser == null) return;
                    final updatedUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserEditProfile(user: dataUser!),),);
                      // Jika ada data yang dikembalikan dari halaman edit
                      if (updatedUser != null) {
                        setState(() {
                          dataUser = updatedUser;
                            });
                            }}, child: Text("Edit Profil", style: TextStyle(fontFamily: customFont, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),)),)
                ],)),

            height(30),
            Container(height: 280, width: 500,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15), 
            boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
            offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Menu", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.text1.withOpacity(0.5), fontWeight: FontWeight.bold)),
                
                height(20),
                Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50, 
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.75), borderRadius: BorderRadius.circular(15), 
                      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                    child: 
                    Image.asset(AppImages.box, height: 50,)),
                  ),
                  width(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pesanan Berlangsung", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w300),),
                    ],
                  ),
                ],
              ),

                
                height(20),
                Row(
                children: [
                  Container(
                    height: 50, 
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.75), borderRadius: BorderRadius.circular(15), 
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                    offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                  child: 
                  Image.asset(AppImages.history, height: 50,)),
                  width(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Riwayat Pesanan", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w300),),
                    ],
                  ),
                ],
              ),


                height(20),
                Row(
                children: [
                  Container(
                    height: 50, 
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.75), borderRadius: BorderRadius.circular(15), 
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                    offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                  child: 
                  Image.asset(AppImages.setting, height: 50,)),
                  width(20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pengaturan", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.black, fontWeight: FontWeight.w300),),
                    ],
                  ),
                ],
              ),
                
                
                ],
                )),

                height(30),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => LoginPage(),),);
                  },
                  child: Container(
                    height: 50, 
                    padding: EdgeInsets.symmetric(horizontal: 90),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15), 
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                    offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                    child:
                    Row(
                      children: [
                      Image.asset(AppImages.logout, height: 20,),
                      width(10),
                      Text("Keluar dari akun", style: TextStyle(fontFamily: customFont, fontSize: 14, fontWeight: FontWeight.bold),)
                    ],)
                  ),
                ),

                height(20),
                Column(children: [
                  Image.asset(AppImages.pet, height: 40, color: AppColors.black.withOpacity(0.5),),
                ],)
          ],
        ),
      ),
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

  // Container boxPage(){
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