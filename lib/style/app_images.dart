import 'package:flutter/material.dart';

class AppImages{
  static const assetImage = "assets/images";
  static const background = "$assetImage/bg.png";
  static const background2 = "$assetImage/bg2.png";
  static const background3 = "$assetImage/bg3.png";
  static const google = "$assetImage/google.png";
  static const whatsapp = "$assetImage/wa.png";
  static const pet = "$assetImage/pet.png";
  static const shop = "$assetImage/shop.png";
  static const book = "$assetImage/book.png";
  static const homeservice = "$assetImage/homeservice.png";
  static const offlinevisit = "$assetImage/offlinevisit.png";
  static const clinic = "$assetImage/clinic.png";
}

class CustomImage extends StatelessWidget {
  const CustomImage({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.09,
      width: 33.83,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Image.asset(imagePath, height: 32.09, width: 33.83),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    super.key,
    required this.customFont, required this.image, required this.press
  });

  final String customFont;
  final String image;
  final String press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        print(press);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 27.5, right: 27.5, top: 6, bottom: 6),
        child: Row(
          spacing: 10,
          children: [
            Image.asset(AppImages.assetImage),
          ],
        ),
      ),
    );
  }
}