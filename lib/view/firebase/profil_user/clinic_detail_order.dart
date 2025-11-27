import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicBookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const ClinicBookingDetailScreen({super.key, required this.bookingId});

  String rupiah(String price) {
    int p = int.tryParse(price) ?? 0;
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.shape4.withOpacity(0.75),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("clinic_bookings")
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final invoice = data["invoice"];
          final serviceName = data["serviceName"];
          final category = data["category"];
          final price = data["price"] ?? "0";
          final date = data["date"];
          final time = data["time"];
          final address = data["address"];
          final status = data["status"];
          final petId = data["petId"];
          final createdAt = data["createdAt"];

          // biaya admin
          const adminFee = 10000;
          final total =
              (int.tryParse(price) ?? 0) + adminFee;

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // ===================== INVOICE BOX =====================
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. Pesanan",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(invoice, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Tanggal Booking:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(createdAt.toString()),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // ============ INFO HEWAN ============
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("pets")
                    .doc(petId)
                    .get(),
                builder: (context, snap) {
                  if (!snap.hasData)
                    return Container();

                  final pet = snap.data!.data() as Map<String, dynamic>?;

                  if (pet == null) return Container();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hewan Peliharaan",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),

                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              pet["icon"] ?? "🐾",
                              style: TextStyle(fontSize: 38),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(pet["name"] ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                Text("${pet["type"]} • ${pet["age"]}",
                                    style: TextStyle(color: Colors.grey[700])),
                              ],
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  );
                },
              ),

              // ============ INFO LAYANAN ============
              Text("Detail Layanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(serviceName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 6),
                    Text("Kategori: $category"),
                    Text("Tanggal: $date"),
                    Text("Waktu: $time"),
                    if (address != null)
                      Text("Alamat: $address"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ===================== RINGKASAN =====================
              Text("Ringkasan Pembayaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              summaryRow("Harga Layanan", rupiah(price)),
              summaryRow("Biaya Admin", rupiah(adminFee.toString())),
              summaryRow(
                "Total Bayar",
                rupiah(total.toString()),
                bold: true,
                color: AppColors.shape4,
              ),

              SizedBox(height: 30),

              // ===================== BUTTON SESUAI STATUS =====================

              if (status == "pending") ...[
                actionButton(
                  text: "Batalkan Booking",
                  color: Colors.red,
                  onTap: () => cancelBooking(context),
                ),
                SizedBox(height: 12),
              ],

              if (status == "process") ...[
                Center(
                  child: Text(
                    "Booking sedang diproses...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
              ],

              if (status == "done")
                Center(
                  child: Text(
                    "Booking telah selesai.",
                    style: TextStyle(color: Colors.green),
                  ),
                ),

              // ===================== WHATSAPP ADMIN =====================
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6,
                        color: Colors.black12,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hubungi Admin",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(
                      "Jika Anda butuh bantuan terkait booking ini, silakan hubungi admin.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => contactAdmin(data),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shape4.withOpacity(0.85),
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.chat_bubble, color: Colors.white),
                      label: Text(
                        "Chat Admin via WhatsApp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================== UI HELPERS ===========================

  Widget summaryRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // =========================== ACTIONS ===========================

  void cancelBooking(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Batalkan Booking?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Anda yakin ingin membatalkan booking ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Tidak"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Ya, Batalkan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection("clinic_bookings")
        .doc(bookingId)
        .update({
      "status": "cancel",
      "updatedAt": FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Booking berhasil dibatalkan"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void contactAdmin(Map<String, dynamic> order) async {
    final adminNumber = "085710546602";

    final invoice = order["invoice"];
    final service = order["serviceName"];
    final date = order["date"];
    final time = order["time"];
    final price = order["price"];

    final message = """
Halo Admin 👋

Saya ingin menanyakan booking klinik hewan saya.

➡️ *No. Pesanan:* $invoice
➡️ *Layanan:* $service
➡️ *Tanggal:* $date
➡️ *Waktu:* $time
➡️ *Harga:* Rp$price

Mohon bantuannya ya 🙏
""";

    final url = Uri.parse(
        "https://wa.me/62${adminNumber.substring(1)}?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
