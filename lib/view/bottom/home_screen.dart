import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/user_model.dart';
import 'package:furtopia/preferences/preference_handler.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/style/text_style.dart';
import 'package:furtopia/view/bottom/chat_screen.dart';
import 'package:furtopia/view/petclinic/petclinic_booking.dart';
import 'package:furtopia/view/petedu/peteducation_screen.dart';
import 'package:furtopia/view/petshop/petshop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.shape6,
        elevation: 8,
        child: Icon(Icons.chat_bubble,
        color: AppColors.white,
        size: 26),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatSupportScreen()),
            );},),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(children: [buildBackground(), buildLayer()]));
  }

  SafeArea buildLayer(){
    return SafeArea(
      child: 
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Halo,", style: TextStyle(fontFamily: customFont, fontSize: 16)),
                  Text("${dataUser?.fullname ?? ""}", style: TextStyle(fontFamily: customFont, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Spacer(),
              Icon(Icons.notifications_outlined, size: 45, color: AppColors.black.withOpacity(0.5))
            ],
          ),
          height(25),
          Container(height: 100,
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(15), 
            boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
            offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
            child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppImages.pet, height: 60,),
                  width(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Selamat datang di FurTopia!", style: TextStyle(fontFamily: customFont, fontSize: 14, color: AppColors.text1.withOpacity(0.5), fontWeight: FontWeight.bold),),
                      Text("Layanan perawatan hewan", style: TextStyle(fontFamily: customFont),),
                      Text("terpercaya", style: TextStyle(fontFamily: customFont),)
                    ],
                  ),
                ],
              )
            ],)),
          height(30),
          Text("Layanan Kami", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.text1.withOpacity(0.5), fontWeight: FontWeight.bold)),
          
          height(10),
          GestureDetector(
            onTap:(){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => PetShopScreen()),);
            },
            child: Container(height: 100,
             padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
             decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.4), borderRadius: BorderRadius.circular(15), 
             boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
             offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60, 
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.shape4.withOpacity(0.3), AppColors.white], begin: AlignmentGeometry.topLeft), borderRadius: BorderRadius.circular(15), 
                      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                    child: 
                    Image.asset(AppImages.shop, height: 60,)),
                    width(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pet Shop", style: TextStyle(fontFamily: customFont, fontSize: 24, color: AppColors.white, fontWeight: FontWeight.bold),),
                        Text("Belanja kebutuhan, makanan,", style: TextStyle(fontFamily: customFont),),
                        Text("dan aksesoris hewan", style: TextStyle(fontFamily: customFont),)
                      ],
                    ),
                  ],
                )
              ],)),
          ),

          height(20),
          Container(height: 150,
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
           decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.4), borderRadius: BorderRadius.circular(15), 
           boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
           offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 60, 
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.shape4.withOpacity(0.3), AppColors.white], begin: AlignmentGeometry.topLeft), borderRadius: BorderRadius.circular(15), 
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                    offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                  child: 
                  Image.asset(AppImages.clinic, height: 60,)),
                  width(15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pet Clinic", style: TextStyle(fontFamily: customFont, fontSize: 24, color: AppColors.white, fontWeight: FontWeight.bold),),
                      Text("Booking perawatan hewan", style: TextStyle(fontFamily: customFont),),

                      height(5),
                      BuildWidget1(imagePath: AppImages.homeservice, text: "Home Service", customFont: customFont,),
                      height(8),
                      BuildWidget1(imagePath: AppImages.offlinevisit, text: "Offline Visit", customFont: customFont),
                    ],
                  ),
                ],
              )
            ],)),

          height(20),
          GestureDetector(
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => EduScreen()));
            },
            child: Container(height: 100,
             padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
             decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.4), borderRadius: BorderRadius.circular(15), 
             boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
             offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
            child: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60, 
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.shape4.withOpacity(0.3), AppColors.white], begin: AlignmentGeometry.topLeft), borderRadius: BorderRadius.circular(15), 
                      boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.25),
                      offset: Offset(2, 2), spreadRadius: 3, blurRadius: 1)]),
                    child: 
                    Image.asset(AppImages.book, height: 60,)),
                    width(15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pet Education", style: TextStyle(fontFamily: customFont, fontSize: 24, color: AppColors.white, fontWeight: FontWeight.bold),),
                        Text("Artikel, tips, dan video edukasi", style: TextStyle(fontFamily: customFont),),
                        Text("perawatan hewan", style: TextStyle(fontFamily: customFont),)
                      ],
                    ),
                  ],
                )
              ],)),
          ),

            height(30),
            Text("Tips Perawatan Hewan 💡", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.text1.withOpacity(0.5), fontWeight: FontWeight.bold)),
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
            decoration: BoxDecoration(color: AppColors.shape1.withOpacity(0.4), borderRadius: BorderRadius.circular(15), ),
            child: Column(
              children: [
                Text(text, style: TextStyle(fontFamily: customFont, fontSize: 12),)
              ],
            ),);
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