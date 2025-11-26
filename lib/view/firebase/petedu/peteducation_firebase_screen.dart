import 'package:flutter/material.dart';
import 'package:furtopia/navigation/bottom_nav_firebase.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';

class EduFirebaseScreen extends StatefulWidget {
  const EduFirebaseScreen({super.key});

  @override
  State<EduFirebaseScreen> createState() => _EduFirebaseScreenState();
}

class _EduFirebaseScreenState extends State<EduFirebaseScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.shape4.withOpacity(0.75),
      title: Text("Pet Education", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: (){
          Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => BottomNavFirebase()));
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
                  style: TextStyle(fontWeight: FontWeight.w500),)),
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
    const customFont = 'Poppins';
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Grooming Pet",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: customFont,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AppImages.grooming,
                height: 200,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Grooming Pet: Perawatan Penting untuk Kesehatan dan Kenyamanan Hewan Peliharaan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: customFont,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            const Text(
              "Grooming pet adalah proses perawatan yang dilakukan pada hewan peliharaan, seperti anjing dan kucing, untuk menjaga kebersihan, kesehatan, serta penampilan mereka. "
              "Banyak pemilik hewan yang menganggap grooming hanya sekadar memandikan hewan, padahal kenyataannya grooming mencakup berbagai tahapan penting yang tidak boleh dilewatkan.",
              style: TextStyle(fontFamily: customFont, fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              "Apa itu Grooming?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: customFont,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Grooming adalah serangkaian perawatan fisik yang meliputi pembersihan, pemotongan, dan pengecekan kondisi tubuh hewan. "
              "Perawatan ini biasanya mencakup beberapa tahapan berikut:",
              style: TextStyle(fontFamily: customFont),
            ),
            const SizedBox(height: 8),
            const Text(
              "• Memandikan hewan dengan sampo khusus sesuai jenis bulunya.\n"
              "• Menyisir dan mengeringkan bulu agar tidak kusut atau rontok.\n"
              "• Memotong kuku untuk mencegah cedera dan infeksi.\n"
              "• Membersihkan telinga dan mata dari kotoran.\n"
              "• Mengecek kondisi kulit dan bulu untuk mendeteksi kutu atau masalah kulit.",
              style: TextStyle(fontFamily: customFont),
            ),
            const SizedBox(height: 20),
            const Text(
              "Manfaat Grooming Secara Rutin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: customFont,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. Menjaga kebersihan dan kesehatan hewan peliharaan.\n"
              "2. Mencegah penyakit kulit dan infeksi telinga.\n"
              "3. Membantu mendeteksi masalah kesehatan sejak dini.\n"
              "4. Membuat hewan merasa nyaman dan tampil lebih rapi.\n"
              "5. Memperkuat ikatan antara pemilik dan hewan peliharaan.",
              style: TextStyle(fontFamily: customFont),
            ),
            const SizedBox(height: 20),
            const Text(
              "Tips Grooming di Rumah",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: customFont,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Gunakan alat grooming yang aman dan sesuai ukuran hewan.\n"
              "• Pastikan air mandi tidak terlalu panas atau dingin.\n"
              "• Jangan gunakan sampo manusia, pilih sampo khusus hewan.\n"
              "• Lakukan dengan lembut agar hewan tidak stres.\n"
              "• Beri camilan setelah grooming agar hewan merasa senang.",
              style: TextStyle(fontFamily: customFont),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kapan Harus ke Pet Grooming Profesional?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: customFont,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Jika hewanmu memiliki bulu panjang, mudah kusut, atau menunjukkan tanda-tanda ketidaknyamanan saat dibersihkan, "
              "sebaiknya bawa ke tempat grooming profesional. Groomer berpengalaman dapat menangani perawatan dengan aman dan efisien.",
              style: TextStyle(fontFamily: customFont),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              "Dengan melakukan grooming secara rutin, kamu membantu menjaga kebersihan, kesehatan, dan kebahagiaan hewan peliharaanmu. "
              "Hewan yang bersih dan sehat akan lebih aktif, ceria, dan nyaman berinteraksi denganmu setiap hari!",
              style: TextStyle(
                fontFamily: customFont,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "❤️ Rawat hewanmu dengan kasih sayang di FurTopia ❤️",
                style: TextStyle(
                  fontFamily: customFont,
                  color: AppColors.text1.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
