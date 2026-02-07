import 'package:flutter/material.dart';
import '../screens/gr_detail_screen.dart';
import '../widgets/global_voice_assistant.dart';

class GRExplanationScreen extends StatelessWidget {
  const GRExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final grItems = [
      {
        'title': 'OBC Scholarship (MAHADBT GR)',
        'pdfAsset': 'assets/pdfs/OBC_MAHADBT_GR.pdf',
        'en': '''SCHOLARSHIP ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Must belong to OBC category
   - Family annual income below Rs. 8 Lakhs
   - Must be Maharashtra resident
   - Must be pursuing education in recognized institution

2. SCHOLARSHIP BENEFITS:
   - Tuition fee reimbursement
   - Maintenance allowance
   - Examination fee coverage

3. REQUIRED DOCUMENTS:
   - Caste Certificate (OBC)
   - Income Certificate
   - Previous year marksheet
   - Aadhaar Card linked with Bank Account

4. HOW TO APPLY:
   - Visit MAHADBT portal (mahadbt.maharashtra.gov.in)
   - Register with Aadhaar number
   - Fill online application form
   - Upload required documents
   - Submit for verification''',
        'hi': '''छात्रवृत्ति पात्रता एवं विवरण

1. पात्रता मानदंड:
   - ओबीसी वर्ग का होना चाहिए
   - पारिवारिक आय 8 लाख से कम होनी चाहिए
   - महाराष्ट्र का निवासी होना चाहिए
   - मान्यता प्राप्त संस्थान में शिक्षा

2. छात्रवृत्ति लाभ:
   - शुल्क प्रतिपूर्ति
   - भत्ता रखरखाव
   - परीक्षा शुल्क कवरेज

3. आवश्यक दस्तावेज:
   - जाति प्रमाणपत्र (ओबीसी)
   - आय प्रमाणपत्र
   - मार्कशीट
   - आधार-बैंक खाता लिंक

4. आवेदन कैसे करें:
   - MAHADBT पोर्टल पर जाएं
   - आधार से पंजीकरण करें
   - फॉर्म भरें, दस्तावेज अपलोड करें
   - सबमिट करें''',
        'mr': '''शिष्यवृत्ती पात्रता व तपशील

1. पात्रता निकष:
   - ओबीसी वर्गातील असावा
   - कौटुंबिक उत्पन्न 8 लाखांपेक्षा कमी
   - महाराष्ट्राचा रहिवासी
   - मान्यताप्राप्त संस्थेत शिक्षण

2. शिष्यवृत्ती लाभ:
   - शुल्क परतावा
   - भत्ता राखीव
   - परीक्षा शुल्क कवर

3. आवश्यक कागदपत्रे:
   - जात प्रमाणपत्र (ओबीसी)
   - उत्पन्न प्रमाणपत्र
   - गुणपत्रक
   - आधार-बँक लिंक

4. अर्ज कसा करावा:
   - MAHADBT पोर्टलवर जा
   - आधाराने नोंदणी
   - फॉर्म भरा, कागदपत्रे अपलोड
   - सबमिट करा''',
      },
      {
        'title': 'Driving Licence (Motor Vehicle GR)',
        'pdfAsset': 'assets/pdfs/ISSUE_OF_DRIVING_LICENSES.pdf',
        'en': '''DRIVING LICENCE ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Minimum 16 years for two-wheeler (without gear)
   - Minimum 18 years for four-wheeler (with gear)
   - Valid identity proof (Aadhaar, PAN, Passport)
   - Must be physically and mentally fit
   - Basic knowledge of traffic rules

2. TYPES OF LICENCES:
   - Two Wheeler (without gear) - Age 16+
   - Two Wheeler (with gear) - Age 18+
   - Four Wheeler (LMV) - Age 18+
   - Commercial Vehicle - Age 20+

3. REQUIRED DOCUMENTS:
   - Aadhaar Card (mandatory)
   - Passport size photographs (5 copies)
   - Age Proof (Birth Certificate, 10th Marksheet)
   - Address Proof (Electricity Bill, Ration Card)
   - Vehicle Insurance Certificate
   - Medical Certificate (Form 1-A for commercial)

4. HOW TO APPLY:
   - Visit Parivahan Sewa portal (parivahan.gov.in)
   - Click "Apply for Driving Licence"
   - Fill online form (Form 2 for private)
   - Upload documents
   - Book slot for Learners Test (LLR)
   - After LLR valid 6 months, book driving test
   - Pass driving test at RTO
   - Pay fees and collect licence

5. FEES:
   - Learners Licence (LLR): Rs. 200-500
   - Driving Licence: Rs. 300-500
   - International Permit: Rs. 1000''',
        'hi': '''ड्राइविंग लाइसेंस पात्रता एवं विवरण

1. पात्रता मानदंड:
   - 16 वर्ष (दोपहिया बिना गियर)
   - 18 वर्ष (चार पहिया/गियर सहित)
   - पहचान प्रमाण (आधार, पैन, पासपोर्ट)
   - शारीरिक और मानसिक रूप से फिट
   - यातायात नियमों का ज्ञान

2. लाइसेंस के प्रकार:
   - दोपहिया बिना गियर - 16 वर्ष
   - दोपहिया गियर सहित - 18 वर्ष
   - चार पहिया (LMV) - 18 वर्ष
   - वाणिज्यिक वाहन - 20 वर्ष

3. आवश्यक दस्तावेज:
   - आधार कार्ड (अनिवार्य)
   - पासपोर्ट फोटो (5 कॉपी)
   - आय प्रमाण (जन्म प्रमाणपत्र)
   - पता प्रमाण (बिजली बिल, राशन कार्ड)
   - वाहन बीमा प्रमाणपत्र
   - चिकित्सा प्रमाणपत्र

4. आवेदन कैसे करें:
   - Parivahan Sewa पोर्टल पर जाएं
   - ऑनलाइन फॉर्म भरें
   - दस्तावेज अपलोड करें
   - LLR टेस्ट स्लॉट बुक करें
   - 6 महीने बाद ड्राइविंग टेस्ट
   - RTO में टेस्ट पास करें
   - शुल्क भरें और लाइसेंस लें''',
        'mr': '''ड्राइविंग लाइसेंस पात्रता व तपशील

1. पात्रता निकष:
   - 16 वर्ष (दोनचाकी बिना गिअर)
   - 18 वर्ष (चारचाकी/गिअरसहित)
   - ओळख प्रमाण (आधार, पॅन, पासपोर्ट)
   - शारीरिक आणि मानसिक फिट
   - वाहतूक नियमांचे ज्ञान

2. लाइसेंस प्रकार:
   - दोनचाकी बिना गिअर - 16 वर्ष
   - दोनचाकी गिअरसहित - 18 वर्ष
   - चारचाकी (LMV) - 18 वर्ष
   - व्यावसायिक वाहन - 20 वर्ष

3. आवश्यक कागदपत्रे:
   - आधार कार्ड (अनिवार्य)
   - पासपोर्ट फोटो (5 प्रती)
   - वय प्रमाण (जन्म प्रमाणपत्र)
   - पत्ता प्रमाण (वीज बिल, रेशन कार्ड)
   - वाहन विमा प्रमाणपत्र
   - वैद्यकीय प्रमाणपत्र

4. अर्ज कसा करावा:
   - Parivahan Sewa पोर्टलवर जा
   - ऑनलाइन फॉर्म भरा
   - कागदपत्रे अपलोड करा
   - LLR टेस्ट स्लॉट बुक करा
   - 6 महिन्यानंतर ड्राइव्हिंग टेस्ट
   - RTO मध्ये टेस्ट उत्तीर्ण
   - शुल्क भरा आणि लाइसेंस घ्या''',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GR Explanation'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grItems.length,
            itemBuilder: (context, index) {
              final gr = grItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GRDetailScreen(
                          title: gr['title'] as String,
                          pdfAsset: gr['pdfAsset'] as String,
                          enSummary: gr['en'] as String,
                          hiSummary: gr['hi'] as String,
                          mrSummary: gr['mr'] as String,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getGradientColors(index),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                gr['title'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to view GR details, PDF & summaries',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _getGradientColor(index),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Color _getGradientColor(int index) {
    switch (index % 3) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  List<Color> _getGradientColors(int index) {
    switch (index % 3) {
      case 0:
        return [Colors.blue.shade100, Colors.blue.shade50];
      case 1:
        return [Colors.orange.shade100, Colors.orange.shade50];
      case 2:
        return [Colors.green.shade100, Colors.green.shade50];
      default:
        return [Colors.blue.shade100, Colors.blue.shade50];
    }
  }
}
