import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final customFont = 'Poppins';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
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
                  Text("Halo,", style: TextStyle(fontFamily: customFont, fontSize: 16, color: AppColors.white)),
                  Text("Zahra Khotimah", style: TextStyle(fontFamily: customFont, fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
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
          Container(height: 100,
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
                      Container(
                        height: 30,
                        padding: EdgeInsets.all(4),
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Image.asset(AppImages.homeservice, height: 20),
                          width(10),
                          Text("Home Service")
                        ],),
                      ),
                      height(5),
                      Container( 
                        color: AppColors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Image.asset(AppImages.offlinevisit, height: 20),
                          width(10),
                          Text("Offline Visit")
                        ],),
                      )
                    ],
                  ),
                ],
              )
            ],)),

          height(20),
          Container(height: 100,
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


        ],
        ),
      ),
      );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background3),
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