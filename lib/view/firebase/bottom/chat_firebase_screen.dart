import 'package:flutter/material.dart';
import 'package:furtopia/style/app_colors.dart';
import 'package:furtopia/style/app_images.dart';

class CSChatFirebaseScreen extends StatefulWidget {
  const CSChatFirebaseScreen({super.key});

  @override
  State<CSChatFirebaseScreen> createState() => _CSChatFirebaseScreenState();
}

class _CSChatFirebaseScreenState extends State<CSChatFirebaseScreen> {
  final TextEditingController messageController = TextEditingController();

  // Pesan awal dari customer service
  final List<Map<String, String>> messages = [
    {
      "sender": "cs",
      "text":
          "Halo! 👋\nSelamat datang di layanan Customer Service FurTopia.\nAda yang bisa kami bantu hari ini?",
      "time": "09:00",
    },
  ];

  // SEND MESSAGE
  void sendMessage() {
    final msg = messageController.text.trim();
    if (msg.isEmpty) return;

    setState(() {
      messages.add({
        "sender": "me",
        "text": msg,
        "time": "Now",
      });
    });

    messageController.clear();

    // Balasan otomatis sederhana
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        messages.add({
          "sender": "cs",
          "text":
              "Baik! Pesan Anda sudah kami terima ✅\nSilakan tunggu sebentar, tim kami sedang memproses... 💬",
          "time": "Now",
        });
      });
    });
  }

  // MAIN UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Service", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
    ), backgroundColor: AppColors.shape4.withOpacity(0.75),), 
    body: Stack(children: [buildBackground(), buildLayer()])
    );
  }

  SafeArea buildLayer(){
    return SafeArea(child: Column(
      children: [
        // CHAT MESSAGES AREA
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              final bool mine = msg["sender"] == "me";
    
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  constraints: const BoxConstraints(maxWidth: 260),
                  decoration: BoxDecoration(
                    gradient: mine
                        ? const LinearGradient(
                            colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                          )
                        : null,
                    color: mine ? null : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: mine
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 3),
                            )
                          ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg["text"]!,
                        style: TextStyle(
                          color: mine ? Colors.white : Colors.black87,
                          fontFamily: "Nunito",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        msg["time"]!,
                        style: TextStyle(
                          color: mine ? Colors.white70 : Colors.grey,
                          fontSize: 11,
                          fontFamily: "Nunito",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
    
        // INPUT AREA
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1))),
          ),
          child: Row(
            children: [
              Icon(Icons.image, color: AppColors.shape4),
              const SizedBox(width: 8),
              Icon(Icons.attach_file, color: AppColors.shape4),
              const SizedBox(width: 8),
    
              // TEXTFIELD
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: "Ketik pesan...",
                    filled: true,
                    fillColor: const Color(0xFFFCE4EC).withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => sendMessage(),
                ),
              ),
    
              const SizedBox(width: 8),
              Icon(Icons.emoji_emotions, color: AppColors.shape4),
              const SizedBox(width: 8),
    
              // SEND BUTTON
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFB76E79), Color(0xFFD4A5B0)],
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              )
            ],
          ),
        )
      ],
    ));
  }

    Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.background4),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
