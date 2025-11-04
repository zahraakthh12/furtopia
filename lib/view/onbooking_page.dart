// import 'package:flutter/material.dart';
// import 'package:furtopia/database/db_helper.dart';
// import 'package:furtopia/model/clinic_model.dart';
// import 'package:furtopia/style/app_colors.dart';

// class OnGoingBookingPage extends StatefulWidget {
//   const OnGoingBookingPage({super.key});

//   @override
//   State<OnGoingBookingPage> createState() => _OnGoingBookingPageState();
// }

// class _OnGoingBookingPageState extends State<OnGoingBookingPage> {
//   late Future<List<ClinicModel>> bookingList;

//   @override
//   void initState() {
//     super.initState();
//     bookingList = DBHelper.getAllBooking();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         title: const Text("Pesanan Berlangsung"),
//         backgroundColor: AppColors.shape4,
//       ),

//       body: FutureBuilder<List<ClinicModel>>(
//         future: bookingList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text("Belum ada pesanan"),
//             );
//           }

//           final data = snapshot.data!;

//           return ListView.builder(
//             padding: const EdgeInsets.all(20),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               final item = data[index];

//               return Container(
//                 margin: const EdgeInsets.only(bottom: 15),
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 5,
//                       offset: const Offset(2, 2),
//                     )
//                   ],
//                 ),

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Judul
//                     Text(
//                       item.service,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     // Hewan
//                     Row(
//                       children: [
//                         const Icon(Icons.pets, size: 18),
//                         const SizedBox(width: 8),
//                         Text(item.petdata),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 6),

//                     // Tipe layanan
//                     Row(
//                       children: [
//                         const Icon(Icons.room_service_outlined, size: 18),
//                         const SizedBox(width: 8),
//                         Text(item.servicetype),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     // Jadwal
//                     Row(
//                       children: [
//                         const Icon(Icons.calendar_month, size: 18),
//                         const SizedBox(width: 8),
//                         Text("${item.date} • ${item.time}"),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     // Alamat jika Home Service
//                     if (item.servicetype == "Home Service") ...[
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.location_on_outlined, size: 18),
//                           const SizedBox(width: 8),
//                           Expanded(child: Text(item.address)),
//                         ],
//                       ),

//                       const SizedBox(height: 6),
//                     ],

//                     // Payment
//                     Row(
//                       children: [
//                         const Icon(Icons.payment, size: 18),
//                         const SizedBox(width: 8),
//                         Text(item.payment),
//                       ],
//                     ),

//                     const SizedBox(height: 12),

//                     // Harga
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Total Harga",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "Rp ${item.price}",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.shape4,
//                             fontSize: 16,
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
