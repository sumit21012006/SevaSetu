import 'package:flutter/material.dart';
import '../widgets/global_voice_assistant.dart';

class GRExplanationScreen extends StatelessWidget {
  const GRExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grSummaries = [
      {
        'title': 'Scholarship Rules (GR-2023-45)',
        'en': 'Students from OBC category with family income below 8 lakhs are eligible for scholarship.',
        'hi': 'ओबीसी श्रेणी के छात्र जिनकी पारिवारिक आय 8 लाख से कम है, छात्रवृत्ति के लिए पात्र हैं।',
        'mr': 'ओबीसी वर्गातील विद्यार्थी ज्यांचे कौटुंबिक उत्पन्न 8 लाखांपेक्षा कमी आहे ते शिष्यवृत्तीसाठी पात्र आहेत.',
      },
      {
        'title': 'Driving License Rules (GR-2022-78)',
        'en': 'Applicants must be 18 years or older and pass both written and practical driving tests.',
        'hi': 'आवेदकों की आयु 18 वर्ष या उससे अधिक होनी चाहिए और लिखित और व्यावहारिक ड्राइविंग परीक्षा दोनों पास करनी चाहिए।',
        'mr': 'अर्जदारांचे वय 18 वर्षे किंवा त्याहून अधिक असावे आणि लेखी आणि व्यावहारिक ड्रायव्हिंग चाचण्या उत्तीर्ण झाल्या पाहिजेत.',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('GR Explanation')),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grSummaries.length,
            itemBuilder: (context, index) {
              final gr = grSummaries[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(gr['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('English:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(gr['en']!),
                          const SizedBox(height: 12),
                          const Text('हिंदी:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(gr['hi']!),
                          const SizedBox(height: 12),
                          const Text('मराठी:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(gr['mr']!),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }
}
