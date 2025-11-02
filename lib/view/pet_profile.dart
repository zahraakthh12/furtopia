// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:furtopia/database/db_helper.dart';
// import 'package:furtopia/model/pet_model.dart';

// class ListPetPage extends StatefulWidget {
//   const ListPetPage({super.key});

//   @override
//   State<ListPetPage> createState() => _ListPetPageState();
// }

// class _ListPetPageState extends State<ListPetPage> {
//   getData() {
//     DBHelper.getAllPet();
//     setState(() {});
//   }

//   Future<void> _onEdit(PetModel pet) async {
//     final editNameC = TextEditingController(text: pet.name);
//     final editTypeC = TextEditingController(text: pet.type);
//     final editGenderC = TextEditingController(text: pet.gender);
//     final editAgeC = TextEditingController(text: pet.age);
//     final editColorC = TextEditingController(text: pet.color);
//     final editWeightC = TextEditingController(text: pet.weight);
//     final editLengthC = TextEditingController(text: pet.length);
//     final res = await showDialog(
//       context: context, 
//       builder: (context){
//         return AlertDialog(
//           title: Text("Edit Data"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 12,
//             children: [
//               buildTextField(hintText: "Nama Hewan", controller: editNameC),
//               buildTextField(hintText: "Jenis Hewan", controller: editTypeC),
//               buildTextField(hintText: "Jenis Kelamin", controller: editGenderC),
//               buildTextField(hintText: "Usia Hewan", controller: editAgeC),
//               buildTextField(hintText: "Warna Hewan", controller: editColorC),
//               buildTextField(hintText: "Berat Badan", controller: editWeightC),
//               buildTextField(hintText: "Panjang Badan", controller: editLengthC),
//             ],),
//             actions: [
//               TextButton(onPressed: (){
//                 Navigator.pop(context);
//               }, child: Text("Batal"),
//               ),
//               TextButton(onPressed: (){
//                 Navigator.pop(context, true);
//               }, child: Text("Simpan"),
//               ),
//               ],
//         );
//       });

//       if (res == true){
//         final updated = PetModel(
//           id: pet.id,
//           name: editNameC.text,
//           type: editTypeC.text,
//           gender: editGenderC.text,
//           age: editAgeC.text,
//           color: editColorC.text,
//           weight: editWeightC.text,
//           length: editLengthC.text,
//         );
//         DBHelper.updatePet(updated);
//         getData();
//         Fluttertoast.showToast(msg: "Data berhasil di update");
//       }
//   }


//   Future<void> _onDelete(PetModel Pet) async {
//     final res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Hapus Data"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 12,
//             children: [
//               Text(
//                 "Apakah anda yakin ingin menghapus data ${Pet.name}?",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Jangan"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: Text("Ya, hapus aja"),
//             ),
//           ],
//         );
//       },
//     );

//     if (res == true) {
//       DBHelper.deletePet(Pet.id!);
//       getData();
//       Fluttertoast.showToast(msg: "Data berhasil di hapus");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text("List Pet")),
//       body: Column(
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text("List data Pet:"),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: DBHelper.getAllPet(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else {
//                   final data = snapshot.data as List<PetModel>;
//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: data.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final items = data[index];
//                         return Column(
//                           children: [
//                             ListTile(
//                               title: Text(items.name),
//                               subtitle: Text(items.type),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(onPressed: (){
//                                     _onEdit(items);
//                                   }, icon: Icon(Icons.edit),),
//                                   IconButton(onPressed: (){
//                                     _onDelete(items);
//                                   }, icon: Icon(Icons.delete, color: Colors.red),)
//                                 ],),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//   TextFormField buildTextField({
//     String? hintText,
//     bool isPassword = false,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       validator: validator,
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(
//             color: Colors.black.withOpacity(0.2),
//             width: 1.0,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(color: Colors.black, width: 1.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(
//             color: Colors.black.withOpacity(0.2),
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }