import 'package:flutter/material.dart';
import 'package:furtopia/database/db_helper.dart';
import 'package:furtopia/model/clinic_model.dart';
import 'package:furtopia/model/pet_model.dart';
import 'package:furtopia/style/app_colors.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int step = 1;

  // Pet list
  List<PetModel> petList = [];
  PetModel? selectedPet;

  // Data booking
  String? selectedService;
  String? selectedType; // home / offline
  String? selectedPayment;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String address = "";

  // Harga
  int basePrice = 0;
  int adminFee = 0;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    final pets = await DBHelper.getAllPet();
    setState(() {
      petList = pets;
    });
  }

  // Hitung harga berdasarkan service
  void calculatePrice() {
    switch (selectedService) {
      case "Grooming":
        basePrice = 100000;
        break;
      case "Vaksin":
        basePrice = 500000;
        break;
      case "Steril Betina":
        basePrice = 350000;
        break;
      case "Steril Jantan":
        basePrice = 300000;
        break;
      case "Check Up":
        basePrice = 150000;
        break;
      default:
        basePrice = 0;
    }

    adminFee = (selectedType == "Home Service") ? 50000 : 0;

    setState(() {});
  }

  // Simpan ke database
  Future<void> saveBooking() async {
    if (selectedService == null ||
        selectedType == null ||
        selectedPet == null ||
        selectedDate == null ||
        selectedTime == null ||
        selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data terlebih dahulu.")),
      );
      return;
    }

    final data = ClinicModel(
      service: selectedService!,
      servicetype: selectedType!,
      date: selectedDate.toString().split(" ")[0],
      time: selectedTime!.format(context),
      payment: selectedPayment!,
      petdata: selectedPet!.name,
      address: selectedType == "Home Service" ? address : "-",
      price: (basePrice + adminFee).toString(),
    );

    await DBHelper.createBooking(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking berhasil!")),
    );

    Navigator.pop(context); // kembali ke halaman sebelumnya
  }

  // Widget judul
  Widget title(String s) => Text(
        s,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Booking Layanan"),
        backgroundColor: AppColors.shape4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              step1(),
              step2(),
              step3(),
              step4(),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== STEP 1 =====================
  Widget step1() {
    if (step != 1) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Pilih Hewan"),
        DropdownButton<PetModel>(
          value: selectedPet,
          hint: const Text("Pilih Hewan"),
          items: petList.map((pet) {
            return DropdownMenuItem(
              value: pet,
              child: Text(pet.name),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedPet = v),
        ),

        const SizedBox(height: 25),
        title("Pilih Layanan"),
        DropdownButton<String>(
          value: selectedService,
          hint: const Text("Pilih Layanan"),
          items: const [
            "Grooming",
            "Vaksin",
            "Steril Betina",
            "Steril Jantan",
            "Check Up",
          ].map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s),
            );
          }).toList(),
          onChanged: (v) {
            setState(() {
              selectedService = v;
            });

            calculatePrice();
          },
        ),

        const SizedBox(height: 25),
        nextButton(() => setState(() => step = 2)),
      ],
    );
  }

  // ===================== STEP 2 =====================
  Widget step2() {
    if (step != 2) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Tipe Layanan"),
        DropdownButton<String>(
          value: selectedType,
          hint: const Text("Pilih Tipe"),
          items: const [
            "Home Service",
            "Offline Visit",
          ].map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s),
            );
          }).toList(),
          onChanged: (v) {
            selectedType = v;
            calculatePrice();
            setState(() {});
          },
        ),

        if (selectedType == "Home Service") ...[
          const SizedBox(height: 20),
          title("Alamat"),
          TextField(
            decoration: const InputDecoration(
              hintText: "Masukkan alamat...",
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => address = v,
          )
        ],

        const SizedBox(height: 25),
        nextButton(() => setState(() => step = 3)),
        backButton(() => setState(() => step = 1)),
      ],
    );
  }

  // ===================== STEP 3 =====================
  Widget step3() {
    if (step != 3) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Pilih Tanggal"),
        GestureDetector(
          onTap: pickDate,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              selectedDate == null
                  ? "Pilih Tanggal"
                  : selectedDate.toString().split(" ")[0],
            ),
          ),
        ),

        const SizedBox(height: 25),
        title("Pilih Waktu"),
        GestureDetector(
          onTap: pickTime,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              selectedTime == null
                  ? "Pilih Waktu"
                  : selectedTime!.format(context),
            ),
          ),
        ),

        const SizedBox(height: 25),
        nextButton(() => setState(() => step = 4)),
        backButton(() => setState(() => step = 2)),
      ],
    );
  }

  // ===================== STEP 4 =====================
  Widget step4() {
    if (step != 4) return const SizedBox();

    final total = basePrice + adminFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Metode Pembayaran"),
        DropdownButton<String>(
          value: selectedPayment,
          hint: const Text("Pilih Pembayaran"),
          items: const [
            "Transfer Bank",
            "E-Wallet",
            "COD",
          ].map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(s),
            );
          }).toList(),
          onChanged: (v) => setState(() => selectedPayment = v),
        ),

        const SizedBox(height: 25),
        Text(
          "Total: Rp $total",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: saveBooking,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.shape4,
            minimumSize: const Size(double.infinity, 45),
          ),
          child: const Text(
            "Konfirmasi Booking",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backButton(() => setState(() => step = 3)),
      ],
    );
  }

  // ===================== PICKERS =====================
  Future pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future pickTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedTime = picked);
  }

  // ===================== BUTTONS =====================
  Widget nextButton(VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.shape4,
        minimumSize: const Size(double.infinity, 45),
      ),
      child: const Text(
        "Lanjut",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget backButton(VoidCallback onTap) {
    return TextButton(onPressed: onTap, child: const Text("Kembali"));
  }
}
