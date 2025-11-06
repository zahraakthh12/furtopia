import 'package:flutter/material.dart';
import 'package:furtopia/navigation/bottom_nav.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';
import 'package:furtopia/view/bottom/home_screen.dart';

class EduScreen extends StatefulWidget {
  const EduScreen({super.key});

  @override
  State<EduScreen> createState() => _EduScreenState();
}

class _EduScreenState extends State<EduScreen> {
  final customFont = 'Poppins';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.shape4.withOpacity(0.75),
      title: Text("Pet Education", style: TextStyle(fontFamily: customFont, fontWeight: FontWeight.bold, fontSize: 20),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: (){
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => BottomNav()));
        })),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => GroomContent()));
              },
              child: BuildContentEdu("Grooming Pet: Perawatan Penting untuk Kesehatan dan Kenyamanan Hewan Peliharaan", 
              AppImages.grooming),
            ),
            height(10),
            BuildContentEdu("Sterilisasi Hewan Peliharaan: Manfaat, Prosedur, dan Pentingnya untuk Kesehatan Pet", 
            AppImages.steril),
            height(10),
            BuildContentEdu("Vaksinasi Hewan Peliharaan: Perlindungan Penting untuk Kehidupan yang Lebih Sehat", 
            AppImages.vaksin)
          ],),
      ),
      

    );
  }

  Container BuildContentEdu(String text, String imagesPath) {
    return Container(
          padding: EdgeInsets.only(left: 10, right: 20.0, top: 10.0),
          height: 120,
          decoration: BoxDecoration(color: AppColors.shape4.withOpacity(0.1), borderRadius: BorderRadius.circular(10), ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagesPath, height: 100),
                width(10),
                Expanded(
                  child: Text(text, 
                  style: TextStyle(fontFamily: customFont, fontWeight: FontWeight.w500),)),
              ],
            ),
          );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);


}

class GroomContent extends StatelessWidget {
  const GroomContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Expanded(child: Column(
            children: [
              Image.asset(AppImages.grooming, height: 200,),
              SizedBox(height: 10,),
              Text("Grooming Pet: Perawatan Penting untuk Kesehatan dan Kenyamanan Hewan Peliharaan", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Text("Grooming pet adalah proses perawatan yang dilakukan pada hewan peliharaan, seperti anjing dan kucing, untuk menjaga kebersihan, kesehatan, serta penampilan mereka. Banyak pemilik hewan yang menganggap grooming hanya sekadar memandikan hewan, padahal kenyataannya grooming mencakup berbagai tahapan penting yang tidak boleh dilewatkan."),
              SizedBox(height: 10,),
              Text("Apa itu Grooming?", style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Grooming adalah serangkaian perawatan fisik yang meliputi pembersihan, pemotongan, dan pengecekan kondisi tubuh hewan. Perawatan ini biasanya mencakup:")
            ],
          ))
        ],),
      )
    );
  }
}