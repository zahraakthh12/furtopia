import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/view/firebase/profil_user/clinic_detail_order.dart';
import 'package:furtopia/view/firebase/profil_user/order_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class OrderInProgressScreen extends StatelessWidget {
  OrderInProgressScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance; // untuk autentikasi
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // untuk akses Firestore

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  } // format mata uang Rupiah

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser; // ambil user yang sedang login
    if (user == null) { // jika tidak ada user yang login
      return Scaffold(
        body: Center(child: Text("Harap login terlebih dahulu.")),
      );
    }

    // Stream untuk pesanan petshop yang sedang berlangsung
    final petshopStream = firestore
        .collection("orders")
        .where("userId", isEqualTo: user.uid)
        .where("status", whereIn: ["pending", "process", "on-delivery"])
        .snapshots();

    // Stream untuk booking klinik hewan yang sedang berlangsung
    final clinicStream = firestore
        .collection("clinic_bookings")
        .where("userId", isEqualTo: user.uid)
        .where("status", whereIn: ["pending", "process"])
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pesanan Berlangsung",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: 
      // StreamBuilder untuk menggabungkan data pesanan petshop dan booking klinik hewan
      StreamBuilder<List<QuerySnapshot>>(
        stream: StreamZip([petshopStream, clinicStream]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final petshopDocs = data[0].docs;
          final clinicDocs = data[1].docs;

          // Gabungkan dua list
          List<Map<String, dynamic>> allOrders = [];

          // pesanan petshop
          for (var doc in petshopDocs) {
            final data = doc.data() as Map<String, dynamic>;
            data["docId"] = doc.id;
            data["type"] = "petshop";
            allOrders.add(data); // tambahkan ke list gabungan
          }

          // booking petclinic
          for (var doc in clinicDocs) {
            final data = doc.data() as Map<String, dynamic>;
            data["docId"] = doc.id;
            data["type"] = "clinic";
            allOrders.add(data);
          }

          // Jika tidak ada pesanan
          if (allOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Tidak ada pesanan berlangsung",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // Urutkan berdasarkan createdAt (descending) atau tanggal pembuatan terbaru
          allOrders.sort((a, b) {
            final aDate =
                DateTime.tryParse(a["createdAt"] ?? "") ?? DateTime(2000);
            final bDate =
                DateTime.tryParse(b["createdAt"] ?? "") ?? DateTime(2000);
            return bDate.compareTo(aDate);
          });

          // Tampilkan daftar pesanan
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: allOrders.length,
            itemBuilder: (context, index) {
              final data = allOrders[index];

              return data["type"] == "petshop"
                  ? _buildPetshopCard(context, data)
                  : _buildClinicCard(context, data);
            },
          );
        },
      ),
    );
  }

  // Widget untuk menampilkan kartu pesanan petshop
  Widget _buildPetshopCard(BuildContext context, Map<String, dynamic> data) {
    final items = List<Map<String, dynamic>>.from(data["products"]);
    final invoice = data["invoice"];
    final total = data["total"];
    final status = data["status"];
    final id = data["docId"];

    // tampilkan kartu pesanan petshop
    return _orderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(invoice, status),
          SizedBox(height: 10),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  items[0]["image"],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  items[0]["product"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),

          if (items.length > 1) // jika ada lebih dari 1 produk
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "+${items.length - 1} produk lainnya",
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
            ),

          SizedBox(height: 14),
          _totalPrice(total),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(orderId: id), // buka detail pesanan petshop 
                  ),
                );
              },
              style: _btnStyle(), // gaya tombol
              child: Text(
                "Lihat Detail",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kartu booking klinik hewan
  Widget _buildClinicCard(BuildContext context, Map<String, dynamic> data) {
    final invoice = data["invoice"];
    final status = data["status"];
    final serviceName = data["serviceName"];
    final date = data["date"];
    final time = data["time"];
    final category = data["category"];
    final address = data["address"];
    final id = data["docId"];

    return _orderCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(invoice, status),
          SizedBox(height: 10),

          Text(
            serviceName ?? "-",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 6),

          Text("Tanggal: $date"),
          Text("Waktu: $time"),
          Text("Kategori: $category"),

          if (address != null) Text("Alamat: $address", maxLines: 2),

          SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ClinicBookingDetailScreen(bookingId: id),
                  ),
                );
              },
              style: _btnStyle(),
              child: Text(
                "Detail Booking",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kartu pesanan atau booking
  Widget _orderCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  // Widget untuk menampilkan header kartu pesanan atau booking
  Widget _header(String invoice, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "No. Pesanan: $invoice",
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 10),

        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 90,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor(status),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel(status),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow:
                  TextOverflow.ellipsis, // jika teks terlalu panjang
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan total harga
  Widget _totalPrice(int total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total Bayar:",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          formatRupiah(total),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.shape4,
          ),
        ),
      ],
    );
  }

  // gaya tombol
  ButtonStyle _btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.shape4.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "process":
        return Colors.blue;
      case "on-delivery":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case "pending":
        return "Menunggu";
      case "process":
        return "Diproses";
      case "on-delivery":
        return "Diterima";
      default:
        return "Unknown";
    }
  }
}
