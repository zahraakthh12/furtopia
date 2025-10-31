import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  int currentStep = 1;

  final Map<String, dynamic> formData = {
    'icon': '🐱',
    'name': '',
    'type': '',
    'breed': '',
    'gender': '',
    'birthDate': '',
    'weight': '',
    'height': '',
    'color': '',
    'microchip': '',
    'notes': '',
  };

  final List<String> petIcons = ['🐱', '🐶', '🐰', '🐹', '🐦', '🐠', '🐢', '🦎'];

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hewan peliharaan berhasil ditambahkan! 🎉"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  void prevStep() {
    if (currentStep > 1) setState(() => currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5E9),
      body: Column(
        children: [
          // ==== HEADER ====
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Tambah Hewan Peliharaan",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          // ==== STEPPER ====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                final step = index + 1;
                final isDone = currentStep > step;
                final isActive = currentStep == step;

                return Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDone || isActive ? Colors.white : Colors.white.withOpacity(0.3),
                          shape: BoxShape.circle,
                          boxShadow: isActive
                              ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)]
                              : [],
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check_circle, color: Color(0xFFB76E79))
                              : Text(
                                  ['🎨', '📝', '📏', '✨'][index],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isActive ? const Color(0xFFB76E79) : Colors.white70,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ['Pilih Icon', 'Info Dasar', 'Detail Fisik', 'Tambahan'][index],
                        style: TextStyle(
                          color: isDone || isActive ? Colors.white : Colors.white60,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      if (index < 3)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          height: 2,
                          width: 50,
                          color: isDone ? Colors.white : Colors.white30,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // ==== KONTEN ====
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                key: ValueKey(currentStep),
                padding: const EdgeInsets.all(20),
                child: buildStepContent(),
              ),
            ),
          ),

          // ==== BUTTON NAVIGASI ====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                if (currentStep > 1)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: prevStep,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB76E79)),
                        foregroundColor: const Color(0xFFB76E79),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                if (currentStep > 1) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB76E79),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      currentStep == 4 ? "Tambah Hewan" : "Lanjut",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==== KONTEN PER LANGKAH ====
  Widget buildStepContent() {
    switch (currentStep) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Icon Hewan 🎨",
              style: TextStyle(
                color: Color(0xFFB76E79),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Pilih icon yang sesuai dengan hewan peliharaan Anda.",
              style: TextStyle(fontFamily: 'Nunito', color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: petIcons.map((icon) {
                  final selected = formData['icon'] == icon;
                  return GestureDetector(
                    onTap: () => setState(() => formData['icon'] = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                              )
                            : null,
                        color: selected ? null : const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: selected
                            ? [BoxShadow(color: Colors.black26, blurRadius: 6)]
                            : [],
                      ),
                      child: Center(
                        child: Text(icon, style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );

      case 2:
        return ListView(
          children: [
            buildTextField("Nama Hewan", "name", isRequired: true),
            buildTextField("Ras/Breed", "breed", isRequired: true),
            buildDropdown("Jenis Hewan", "type", [
              "Kucing 🐱",
              "Anjing 🐶",
              "Kelinci 🐰",
              "Hamster 🐹",
              "Burung 🐦",
              "Ikan 🐠",
              "Reptil 🦎",
              "Lainnya"
            ]),
            buildDropdown("Jenis Kelamin", "gender", ["Jantan ♂", "Betina ♀"]),
            buildTextField("Tanggal Lahir (opsional)", "birthDate", hint: "YYYY-MM-DD"),
          ],
        );

      case 3:
        return ListView(
          children: [
            buildTextField("Berat Badan (kg)", "weight", hint: "3.5"),
            buildTextField("Tinggi (cm)", "height", hint: "25"),
            buildTextField("Warna Bulu/Kulit", "color", hint: "Putih Abu-abu"),
          ],
        );

      case 4:
        return ListView(
          children: [
            buildTextField("Microchip ID (opsional)", "microchip", hint: "ID-001234567890"),
            buildTextField("Catatan Khusus", "notes", hint: "Alergi, kebiasaan, dll", maxLines: 4),
            const SizedBox(height: 12),
            buildSummaryCard(),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  // ==== FUNGSI REUSABLE ====
  Widget buildTextField(String label, String key, {String? hint, bool isRequired = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label${isRequired ? " *" : ""}",
            style: const TextStyle(
              color: Color(0xFFB76E79),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: formData[key]),
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFB76E79), width: 0.3),
              ),
            ),
            onChanged: (v) => formData[key] = v,
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String key, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                color: Color(0xFFB76E79),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: formData[key].isEmpty ? null : formData[key],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontFamily: 'Nunito'))))
                .toList(),
            onChanged: (v) => formData[key] = v,
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFCE4EC), Color(0xFFFAF5E9)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Ringkasan Data Hewan 🎉",
            style: TextStyle(
              color: Color(0xFFB76E79),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(formData['icon'], style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formData['name'] ?? "-",
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                  Text(
                    "${formData['breed'] ?? '-'} • ${formData['gender'] ?? '-'}",
                    style: const TextStyle(fontFamily: 'Nunito', color: Colors.grey),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
