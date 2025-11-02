// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:furtopia/database/db_helper.dart';
// import 'package:furtopia/model/pet_model.dart';
// import 'package:furtopia/navigation/bottom_nav.dart';
// import 'package:furtopia/style/app_colors.dart';
// import 'package:furtopia/view/login_page.dart';
// import 'package:furtopia/view/profile_page.dart';

// class CRPetWidget extends StatefulWidget {
//   const CRPetWidget({super.key});

//   @override
//   State<CRPetWidget> createState() => _CRPetWidgetState();
// }

// class _CRPetWidgetState extends State<CRPetWidget> {
//   final customFont = 'Poppins';
//   final nameC = TextEditingController();
//   final typeC = TextEditingController();
//   final genderC = TextEditingController();
//   final ageC = TextEditingController();
//   final colorC = TextEditingController();
//   final weightC = TextEditingController();
//   final lengthC = TextEditingController();
//   getData() {
//     DBHelper.getAllPet();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold( 
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Transform.translate(
//                   offset: const Offset(-12,0),
//                   child: IconButton( 
//                     onPressed: () {
//                       Navigator.pop(context,
//                         MaterialPageRoute(builder: (context) => BottomNav()));
//                     },
//                     icon: Icon(Icons.arrow_back, size: 25,),
//                   ),
//                 ),
//                 Text("Pendataan Hewan Peliharaan", style: TextStyle(fontSize: 18, fontFamily: customFont, fontWeight: FontWeight.bold)),
//               ],
//             ),

//             height(20),
//             buildTitle("Nama Hewan"),
//             height(5),
//             buildTextField(hintText: "Masukkan nama hewan Anda", controller: nameC),
//             height(10),
//             buildTitle("Jenis Hewan"),
//             height(5),
//             buildTextField(hintText: "contoh: Anjing, Kucing, Kelinci", controller: typeC),
//             height(10),
//             buildTitle("Jenis Kelamin"),
//             height(5),
//             buildTextField(hintText: "Betina/Jantan", controller: genderC),
//             height(10),
//             buildTitle("Usia Hewan"),
//             height(5),
//             buildTextField(hintText: "Masukkan usia hewan Anda", controller: ageC),
//             height(10),
//             buildTitle("Warna Hewan"),
//             height(5),
//             buildTextField(hintText: "Masukkan warna hewan Anda", controller: colorC),
//             height(10),
//             buildTitle("Berat Badan"),
//             height(5),
//             buildTextField(hintText: "contoh: 4.5 kg, 4 kg", controller: weightC),
//             height(10),
//             buildTitle("Panjang Badan"),
//             height(5),
//             buildTextField(hintText: "contoh: 30 cm, 35.8 cm", controller: lengthC),

//             height(15),
//             LoginButton(
//               text: "Tambahkan",
//               onPressed: () {
//                 if (nameC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Nama hewan belum diisi");
//                 } else if (typeC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Jenis hewan belum diisi");
//                 } else if (genderC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Jenis kelamin belum diisi");
//                 } else if (ageC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Usia hewan belum diisi");
//                 } else if (colorC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Warna hewan belum diisi");
//                 } else if (weightC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Berat badan belum diisi");
//                 } else if (lengthC.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Panjang badan belum diisi");
//                 } else {
//                   final PetModel dataPet = PetModel(
//                     name: nameC.text,
//                     type: typeC.text,
//                     gender: genderC.text,
//                     age: ageC.text,
//                     color: colorC.text,
//                     weight: weightC.text,
//                     length: lengthC.text,
                
//                   );
//                   DBHelper.createPet(dataPet).then((value) {
//                     typeC.clear();
//                     ageC.clear();
//                     genderC.clear();
//                     nameC.clear();
//                     weightC.clear();
//                     lengthC.clear();
//                     colorC.clear;
//                     getData();
//                     Fluttertoast.showToast(msg: "Data hewan berhasil ditambahkan");
//                   });
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//    TextFormField buildTextField({
//     String? hintText,
//     Icon? icon,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       validator: validator,
//       controller: controller,
//       style: TextStyle(fontFamily: customFont, fontSize: 12),
//       decoration: InputDecoration(
//         filled: true,
//         contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//         hintText: hintText,
//         hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontFamily: customFont),
//         prefixIcon: icon,
//         fillColor: AppColors.bg1.withOpacity(0.35),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: AppColors.bg1.withOpacity(0.92),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.bg1.withOpacity(0.92)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(
//             color: AppColors.bg1,
//           ),
//         ),
//       ),
//     );}

//     Widget buildTitle(String text) {
//     return Row(
//       children: [
//         Text(text, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontFamily: customFont ))
//       ],
//     );
//   }

//   SizedBox height(double height) => SizedBox(height: height);
//   SizedBox width(double width) => SizedBox(width: width);

// }