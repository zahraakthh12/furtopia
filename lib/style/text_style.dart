import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';

class BuildWidget1 extends StatelessWidget {
  final String imagePath;
  final String text;
  final customFont = 'Poppins';

  const BuildWidget1({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 2,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontFamily: customFont,
              fontWeight: FontWeight.bold,
              color: AppColors.shape4.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:furtopia/style/app_colors.dart';

// class FeatureCard extends StatelessWidget {
//   final Color? color;
//   final List? gradientColors;
//   final String imagePath;
//   final String title;
//   final List subtitles;
//   final double height;
//   final double imageSize;
//   final String fontFamily;
//   const FeatureCard({
//     super.key,
//     this.color,
//     this.gradientColors,
//     required this.imagePath,
//     required this.title,required this.subtitles,this.height = 100,this.imageSize = 60,required this.fontFamily});




// @override
// Widget build(BuildContext context) {
// return Container(
// height: height,
// padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// decoration: BoxDecoration(
// color: color ?? AppColors.shape4.withOpacity(0.4),
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: AppColors.black.withOpacity(0.25),
// offset: const Offset(2, 2),
// spreadRadius: 3,
// blurRadius: 1,
// ),
// ],
// ),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// height: imageSize,
// padding: const EdgeInsets.all(5.0),
// decoration: BoxDecoration(
// gradient: gradientColors != null
// ? LinearGradient(colors: gradientColors!)
// : null,
// color: gradientColors == null ? AppColors.white : null,
// borderRadius: BorderRadius.circular(15),
// boxShadow: [
// BoxShadow(
// color: AppColors.black.withOpacity(0.25),
// offset: const Offset(2, 2),
// spreadRadius: 3,
// blurRadius: 1,
// ),
// ],
// ),
// child: Image.asset(imagePath, height: imageSize),
// ),
// const SizedBox(width: 15),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// title,
// style: TextStyle(
// fontFamily: fontFamily,
// fontSize: 20,
// color: AppColors.white,
// fontWeight: FontWeight.bold,
// ),
// ),
// for (var text in subtitles)
// Text(text, style: TextStyle(fontFamily: fontFamily)),
// ],
// ),
// ],
// ),
// );
// }
// }