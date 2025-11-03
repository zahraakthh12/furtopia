// import 'package:flutter/cupertino.dart';
// import 'package:furtopia/model/user_model.dart';
// import 'package:furtopia/preferences/preference_handler.dart';

// class EditProfilPage extends StatefulWidget {
//   const EditProfilPage({super.key});

//   @override
//   State<EditProfilPage> createState() => _EditProfilPageState();
// }

// class _EditProfilPageState extends State<EditProfilPage> {
//   UserModel? user;

//   final fullnameC = TextEditingController();
//   final phoneC = TextEditingController();
//   final emailC = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//   }

//   loadUser() async {
//     user = await PreferenceHandler.getUser();
//     if (user != null) {
//       fullnameC.text = user!.fullname;
//       phoneC.text = user!.phone;
//       setState(() {});
//     }
//   }

//   updateData() async {
//     if (user == null) return;

//     final updatedUser = CustomerModel(
//       id: user!.id,
//       name: nameC.text,
//       email: user!.email,
//       phone: phoneC.text,
//       city: cityC.text,
//       password: user!.password,
//     );

//     await DbHelper.updateCustomer(updatedUser);
//     await PreferenceHandler.saveUser(updatedUser);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Profil berhasil diperbarui!")),
//     );

//     Navigator.pop(context); // Kembali ke AkunPage
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolor.softPinkPastel,
//       appBar: AppBar(
//         backgroundColor: Appcolor.button1,
//         centerTitle: true,
//         title: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
//       ),

//       body: user == null
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   _input("Nama Lengkap", nameC),
//                   const SizedBox(height: 16),
//                   _input("No. Telepon", phoneC, keyboard: TextInputType.phone),
//                   const SizedBox(height: 16),
//                   _input("Kota / Domisili", cityC),

//                   const SizedBox(height: 28),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: updateData,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Appcolor.button1,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: const Text(
//                         "Simpan Perubahan",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _input(
//     String label,
//     TextEditingController c, {
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return TextField(
//       controller: c,
//       keyboardType: keyboard,
//       decoration: InputDecoration(
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }
// }