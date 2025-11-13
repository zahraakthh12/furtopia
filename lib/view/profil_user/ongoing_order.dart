// import 'package:flutter/material.dart';


// class PesananBerlangsungScreen extends StatelessWidget {
//   final Service service;
//   final Doctor? doctor;
//   final String date;
//   final String time;

//   const PesananBerlangsungScreen({
//     super.key,
//     required this.service,
//     this.doctor,
//     required this.date,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF5E9),
//       appBar: AppBar(
//         title: const Text("Pesanan Berlangsung",
//             style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
//         backgroundColor: const Color(0xFFB76E79),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF0F3),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("${service.icon} ${service.name}",
//                   style: const TextStyle(
//                       fontFamily: "Poppins",
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFFB76E79))),
//               const SizedBox(height: 8),
//               Text("Tanggal: $date",
//                   style: const TextStyle(fontFamily: "Nunito", color: Colors.black87)),
//               Text("Waktu: $time",
//                   style: const TextStyle(fontFamily: "Nunito", color: Colors.black87)),
//               if (doctor != null) ...[
//                 const SizedBox(height: 8),
//                 Text("Dokter: ${doctor!.name}",
//                     style: const TextStyle(fontFamily: "Nunito", color: Colors.black87)),
//               ],
//               const Spacer(),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFB76E79),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       minimumSize: const Size(double.infinity, 50)),
//                   child: const Text("Kembali ke Beranda",
//                       style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white)),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
