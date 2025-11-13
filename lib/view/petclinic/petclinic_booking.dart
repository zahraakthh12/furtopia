import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String icon;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String image;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.image,
  });
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final customFont = 'Poppins';
  int currentStep = 1;

  final List<Service> services = [
    Service(id: "grooming", name: "Grooming", icon: "✨", description: "Perawatan dan kebersihan hewan"),
    Service(id: "vaccine", name: "Vaksinasi", icon: "💉", description: "Vaksin rutin dan khusus"),
    Service(id: "sterilization", name: "Sterilisasi", icon: "🏥", description: "Prosedur sterilisasi aman"),
    Service(id: "checkup", name: "Medical Check-Up", icon: "🩺", description: "Pemeriksaan kesehatan lengkap"),
  ];

  final List<Doctor> doctors = [
    Doctor(id: "dr1", name: "drh. Amanda Putri", specialty: "Grooming Specialist", rating: 4.9, image: "👩‍⚕️"),
    Doctor(id: "dr2", name: "drh. Budi Santoso", specialty: "Veterinarian", rating: 4.8, image: "👨‍⚕️"),
    Doctor(id: "dr3", name: "drh. Citra Dewi", specialty: "Surgery Specialist", rating: 5.0, image: "👩‍⚕️"),
  ];

  String? selectedService;
  String? selectedServiceType;
  String? selectedDoctor;
  String? selectedDate;
  String? selectedTime;

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking berhasil dikonfirmasi!")),
      );
    }
  }

  void previousStep() {
    if (currentStep > 1) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF5E9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFB76E79),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: previousStep,
        ),
        title: Text(
          "Booking Layanan",
          style: TextStyle(
            fontFamily: customFont,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: currentStep / 4,
                color: Color(0xFFB76E79),
                backgroundColor: Colors.grey.shade300,
                minHeight: 6,
              ),
              SizedBox(height: 20),

              if (currentStep == 1) buildStep1(),
              if (currentStep == 2) buildStep2(),
              if (currentStep == 3) buildStep3(),
              if (currentStep == 4) buildStep4(),
            ],
          ),
        ),
      ),
    );
  }

  // STEP 1: Pilih Layanan
  Widget buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pilih Layanan",
            style: TextStyle(
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        SizedBox(height: 12),
        ...services.map((service) => GestureDetector(
              onTap: () {
                setState(() => selectedService = service.id);
                Future.delayed(Duration(milliseconds: 300), () => nextStep());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedService == service.id
                        ? Color(0xFFB76E79)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: selectedService == service.id
                      ? Color(0xFFFFF0F3)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Text(service.icon, style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name,
                              style: TextStyle(
                                  color: Color(0xFFB76E79),
                                  fontWeight: FontWeight.w600)),
                          Text(service.description,
                              style: TextStyle(
                                  color: Colors.black54)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Color(0xFFB76E79)),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  // STEP 2: Pilih Jenis Layanan
  Widget buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pilih Jenis Layanan",
            style: TextStyle(
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        SizedBox(height: 12),
        buildServiceTypeCard("Home Service", "Dokter datang ke rumah", "home"),
        buildServiceTypeCard("Offline Visit", "Datang langsung ke klinik", "offline"),
      ],
    );
  }

  Widget buildServiceTypeCard(String title, String desc, String value) {
    final isSelected = selectedServiceType == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedServiceType = value);
        Future.delayed(Duration(milliseconds: 300), () => nextStep());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFFB76E79) : Colors.grey.shade300,
            width: 2,
          ),
          color: isSelected ? Color(0xFFFFF0F3) : Colors.white,
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.home : Icons.location_on,
                color: Color(0xFFB76E79)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: Color(0xFFB76E79),
                            fontWeight: FontWeight.w600)),
                    Text(desc,
                        style: TextStyle(
                            color: Colors.black54)),
                  ]),
            ),
            Icon(Icons.chevron_right, color: Color(0xFFB76E79)),
          ],
        ),
      ),
    );
  }

  // STEP 3: Pilih Dokter dan Jadwal
  Widget buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pilih Dokter/Terapis",
            style: TextStyle(
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        SizedBox(height: 12),
        ...doctors.map((d) => GestureDetector(
              onTap: () => setState(() => selectedDoctor = d.id),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selectedDoctor == d.id
                        ? Color(0xFFB76E79)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: selectedDoctor == d.id
                      ? Color(0xFFFFF0F3)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Text(d.image, style: TextStyle(fontSize: 32)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.name,
                                style: TextStyle(
                                    color: Color(0xFFB76E79),
                                    fontWeight: FontWeight.w600)),
                            Text(d.specialty,
                                style: TextStyle(
                                    color: Colors.black54)),
                            Text("⭐ ${d.rating}",
                                style: TextStyle(
                                    color: Colors.orange)),
                          ]),
                    ),
                  ],
                ),
              ),
            )),
        SizedBox(height: 20),
        Text("Pilih Jadwal",
            style: TextStyle(
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: "Tanggal",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(Icons.calendar_today, color: Color(0xFFB76E79)),
          ),
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
              initialDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => selectedDate = "${picked.year}-${picked.month}-${picked.day}");
            }
          },
          controller: TextEditingController(text: selectedDate ?? ""),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ["09:00", "11:00", "13:00", "15:00", "17:00"].map((time) {
            final isSelected = selectedTime == time;
            return ChoiceChip(
              label: Text(time,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black)),
              selected: isSelected,
              selectedColor: Color(0xFFB76E79),
              onSelected: (_) => setState(() => selectedTime = time),
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: (selectedDoctor != null && selectedDate != null && selectedTime != null)
              ? nextStep
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB76E79),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text("Lanjut ke Pembayaran",
              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  // STEP 4: Ringkasan Pembayaran
  Widget buildStep4() {
    final selectedServiceData = services.firstWhere((s) => s.id == selectedService);
    final selectedDoctorData = doctors.firstWhere((d) => d.id == selectedDoctor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ringkasan Booking",
            style: TextStyle(
                fontFamily: "Poppins",
                color: Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
                fontSize: 18)),
        SizedBox(height: 12),
        summaryTile("Layanan", selectedServiceData.name),
        summaryTile("Tipe Layanan",
            selectedServiceType == "home" ? "Home Service" : "Offline Visit"),
        summaryTile("Dokter", selectedDoctorData.name),
        summaryTile("Jadwal", "$selectedDate - $selectedTime"),
        summaryTile("Total Pembayaran", "Rp 250.000", highlight: true),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: nextStep,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB76E79),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text("Konfirmasi & Bayar",
              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget summaryTile(String title, String value, {bool highlight = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? Color(0xFFB76E79) : Color(0xFFFFF0F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                color: highlight ? Colors.white70 : Colors.black87,
              )),
          Text(value,
              style: TextStyle(
                color: highlight ? Colors.white : Color(0xFFB76E79),
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
