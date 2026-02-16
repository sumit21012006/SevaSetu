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
      {
        'title': 'Income Certificate (Revenue GR)',
        'pdfAsset':
            'assets/pdfs/Fees, Procedure, Checklist_Income Certificate.pdf',
        'en': '''INCOME CERTIFICATE ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Must be permanent resident of Maharashtra
   - Valid address proof required
   - Income details of all family members needed
   - Self-employed must provide business documents
   - Salaried individuals need salary slips

2. CERTIFICATE VALIDITY:
   - Valid for 6 months to 1 year
   - Renewable with updated income details
   - Required for various government schemes

3. REQUIRED DOCUMENTS:
   - Aadhaar Card (mandatory)
   - Ration Card
   - Salary Slips (last 6 months) for salaried
   - Business registration for self-employed
   - Property tax receipts
   - Bank statements (last 6 months)
   - Electricity bill for address proof

4. HOW TO APPLY:
   - Visit Aaple Sarkar portal (aaplesarkar.mahaonline.gov.in)
   - Select "Income Certificate" service
   - Fill online application form
   - Upload required documents
   - Pay application fees (Rs. 20-50)
   - Submit for Tehsildar verification
   - Certificate issued within 7-15 days''',
        'hi': '''आय प्रमाणपत्र पात्रता एवं विवरण

1. पात्रता मानदंड:
   - महाराष्ट्र का स्थायी निवासी
   - वैध पता प्रमाण आवश्यक
   - परिवार के सभी सदस्यों की आय
   - स्व-रोजगार के लिए व्यवसाय दस्तावेज
   - वेतनभोगी के लिए वेतन पर्ची

2. प्रमाणपत्र वैधता:
   - 6 महीने से 1 वर्ष तक वैध
   - नवीनीकरण योग्य
   - सरकारी योजनाओं के लिए आवश्यक

3. आवश्यक दस्तावेज:
   - आधार कार्ड (अनिवार्य)
   - राशन कार्ड
   - वेतन पर्ची (6 महीने)
   - व्यवसाय पंजीकरण
   - संपत्ति कर रसीद
   - बैंक स्टेटमेंट
   - बिजली बिल

4. आवेदन कैसे करें:
   - आपले सरकार पोर्टल पर जाएं
   - आय प्रमाणपत्र सेवा चुनें
   - फॉर्म भरें, दस्तावेज अपलोड करें
   - शुल्क भुगतान (20-50 रुपये)
   - तहसीलदार सत्यापन
   - 7-15 दिनों में प्रमाणपत्र''',
        'mr': '''उत्पन्न प्रमाणपत्र पात्रता व तपशील

1. पात्रता निकष:
   - महाराष्ट्राचा कायमचा रहिवासी
   - वैध पत्ता प्रमाण आवश्यक
   - कुटुंबातील सर्व सदस्यांचे उत्पन्न
   - स्वयंरोजगारासाठी व्यवसाय कागदपत्रे
   - पगारदारांसाठी पगार पावत्या

2. प्रमाणपत्र वैधता:
   - 6 महिने ते 1 वर्ष वैध
   - नूतनीकरण करता येईल
   - सरकारी योजनांसाठी आवश्यक

3. आवश्यक कागदपत्रे:
   - आधार कार्ड (अनिवार्य)
   - रेशन कार्ड
   - पगार पावत्या (6 महिने)
   - व्यवसाय नोंदणी
   - मालमत्ता कर पावती
   - बँक स्टेटमेंट
   - वीज बिल

4. अर्ज कसा करावा:
   - आपले सरकार पोर्टलवर जा
   - उत्पन्न प्रमाणपत्र सेवा निवडा
   - फॉर्म भरा, कागदपत्रे अपलोड
   - शुल्क भरणे (20-50 रुपये)
   - तहसीलदार पडताळणी
   - 7-15 दिवसात प्रमाणपत्र''',
      },
      {
        'title': 'Caste Certificate (Social Welfare GR)',
        'pdfAsset': 'assets/pdfs/caste_certificate_GR.pdf',
        'en': '''CASTE CERTIFICATE ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Must belong to SC/ST/OBC/NT/VJ/SBC category
   - Parents must have valid caste certificate
   - Permanent resident of Maharashtra
   - Birth certificate showing parents names
   - Family tree documentation required

2. CERTIFICATE VALIDITY:
   - Permanent validity (no expiry)
   - Caste Validity Certificate required for education/jobs
   - One-time issuance per person

3. REQUIRED DOCUMENTS:
   - Birth Certificate (mandatory)
   - School Leaving Certificate
   - Parents Caste Certificate (original)
   - Aadhaar Card
   - Ration Card
   - Domicile Certificate
   - Passport size photographs (3 copies)
   - Family tree affidavit

4. HOW TO APPLY:
   - Visit Aaple Sarkar portal
   - Select "Caste Certificate" service
   - Fill application with family details
   - Upload all required documents
   - Pay fees (Rs. 20-30)
   - Submit to Tehsildar office
   - Verification by Caste Scrutiny Committee
   - Certificate issued within 30-45 days''',
        'hi': '''जाति प्रमाणपत्र पात्रता एवं विवरण

1. पात्रता मानदंड:
   - SC/ST/OBC/NT/VJ/SBC वर्ग से संबंधित
   - माता-पिता का वैध जाति प्रमाणपत्र
   - महाराष्ट्र का स्थायी निवासी
   - जन्म प्रमाणपत्र (माता-पिता के नाम)
   - पारिवारिक वृक्ष दस्तावेज

2. प्रमाणपत्र वैधता:
   - स्थायी वैधता (कोई समाप्ति नहीं)
   - शिक्षा/नौकरी के लिए जाति वैधता आवश्यक
   - प्रति व्यक्ति एक बार जारी

3. आवश्यक दस्तावेज:
   - जन्म प्रमाणपत्र (अनिवार्य)
   - स्कूल छोड़ने का प्रमाणपत्र
   - माता-पिता का जाति प्रमाणपत्र
   - आधार कार्ड
   - राशन कार्ड
   - अधिवास प्रमाणपत्र
   - पासपोर्ट फोटो (3 प्रति)
   - पारिवारिक वृक्ष शपथपत्र

4. आवेदन कैसे करें:
   - आपले सरकार पोर्टल पर जाएं
   - जाति प्रमाणपत्र सेवा चुनें
   - परिवार विवरण के साथ फॉर्म भरें
   - दस्तावेज अपलोड करें
   - शुल्क भुगतान (20-30 रुपये)
   - जाति जांच समिति द्वारा सत्यापन
   - 30-45 दिनों में प्रमाणपत्र''',
        'mr': '''जात प्रमाणपत्र पात्रता व तपशील

1. पात्रता निकष:
   - SC/ST/OBC/NT/VJ/SBC वर्गातील
   - आई-वडिलांचे वैध जात प्रमाणपत्र
   - महाराष्ट्राचा कायमचा रहिवासी
   - जन्म दाखला (आई-वडिलांची नावे)
   - कौटुंबिक वृक्ष कागदपत्रे

2. प्रमाणपत्र वैधता:
   - कायमची वैधता (कालबाह्यता नाही)
   - शिक्षण/नोकरीसाठी जात वैधता आवश्यक
   - प्रति व्यक्ती एकदाच जारी

3. आवश्यक कागदपत्रे:
   - जन्म दाखला (अनिवार्य)
   - शाळा सोडल्याचा दाखला
   - आई-वडिलांचे जात प्रमाणपत्र
   - आधार कार्ड
   - रेशन कार्ड
   - अधिवास प्रमाणपत्र
   - पासपोर्ट फोटो (3 प्रती)
   - कौटुंबिक वृक्ष प्रतिज्ञापत्र

4. अर्ज कसा करावा:
   - आपले सरकार पोर्टलवर जा
   - जात प्रमाणपत्र सेवा निवडा
   - कुटुंब तपशीलासह फॉर्म भरा
   - कागदपत्रे अपलोड करा
   - शुल्क भरणे (20-30 रुपये)
   - जात छाननी समितीद्वारे पडताळणी
   - 30-45 दिवसात प्रमाणपत्र''',
      },
      {
        'title': 'Domicile Certificate (Revenue GR)',
        'pdfAsset': 'assets/pdfs/domicile_GR.pdf',
        'en': '''DOMICILE CERTIFICATE ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Must be residing in Maharashtra for 15+ years
   - Birth in Maharashtra qualifies automatically
   - Parents domicile certificate can be used
   - Education records showing 7+ years in state
   - Property ownership in Maharashtra

2. CERTIFICATE VALIDITY:
   - Permanent validity (lifetime)
   - Required for state quota admissions
   - Needed for state government jobs

3. REQUIRED DOCUMENTS:
   - Birth Certificate (if born in Maharashtra)
   - School Leaving Certificates (7+ years)
   - Aadhaar Card
   - Ration Card
   - Property documents (if applicable)
   - Parents domicile certificate (if applicable)
   - Electricity/Water bill (15+ years old)
   - Passport size photographs (2 copies)

4. HOW TO APPLY:
   - Visit Aaple Sarkar portal
   - Select "Domicile Certificate" service
   - Fill application with residence proof
   - Upload all supporting documents
   - Pay fees (Rs. 20-30)
   - Submit to Tehsildar office
   - Verification of residence records
   - Certificate issued within 15-30 days''',
        'hi': '''अधिवास प्रमाणपत्र पात्रता एवं विवरण

1. पात्रता मानदंड:
   - महाराष्ट्र में 15+ वर्ष निवास
   - महाराष्ट्र में जन्म स्वतः योग्य
   - माता-पिता का अधिवास प्रमाणपत्र उपयोग
   - राज्य में 7+ वर्ष शिक्षा रिकॉर्ड
   - महाराष्ट्र में संपत्ति स्वामित्व

2. प्रमाणपत्र वैधता:
   - स्थायी वैधता (जीवनभर)
   - राज्य कोटा प्रवेश के लिए आवश्यक
   - राज्य सरकारी नौकरियों के लिए जरूरी

3. आवश्यक दस्तावेज:
   - जन्म प्रमाणपत्र (महाराष्ट्र में जन्म)
   - स्कूल छोड़ने का प्रमाणपत्र (7+ वर्ष)
   - आधार कार्ड
   - राशन कार्ड
   - संपत्ति दस्तावेज
   - माता-पिता का अधिवास प्रमाणपत्र
   - बिजली/पानी बिल (15+ वर्ष पुराना)
   - पासपोर्ट फोटो (2 प्रति)

4. आवेदन कैसे करें:
   - आपले सरकार पोर्टल पर जाएं
   - अधिवास प्रमाणपत्र सेवा चुनें
   - निवास प्रमाण के साथ फॉर्म भरें
   - दस्तावेज अपलोड करें
   - शुल्क भुगतान (20-30 रुपये)
   - निवास रिकॉर्ड सत्यापन
   - 15-30 दिनों में प्रमाणपत्र''',
        'mr': '''अधिवास प्रमाणपत्र पात्रता व तपशील

1. पात्रता निकष:
   - महाराष्ट्रात 15+ वर्षे वास्तव्य
   - महाराष्ट्रात जन्म स्वयंचलित पात्र
   - आई-वडिलांचे अधिवास प्रमाणपत्र वापर
   - राज्यात 7+ वर्षे शिक्षण रेकॉर्ड
   - महाराष्ट्रात मालमत्ता मालकी

2. प्रमाणपत्र वैधता:
   - कायमची वैधता (आजीवन)
   - राज्य कोटा प्रवेशासाठी आवश्यक
   - राज्य सरकारी नोकऱ्यांसाठी गरजेचे

3. आवश्यक कागदपत्रे:
   - जन्म दाखला (महाराष्ट्रात जन्म)
   - शाळा सोडल्याचा दाखला (7+ वर्षे)
   - आधार कार्ड
   - रेशन कार्ड
   - मालमत्ता कागदपत्रे
   - आई-वडिलांचे अधिवास प्रमाणपत्र
   - वीज/पाणी बिल (15+ वर्षे जुने)
   - पासपोर्ट फोटो (2 प्रती)

4. अर्ज कसा करावा:
   - आपले सरकार पोर्टलवर जा
   - अधिवास प्रमाणपत्र सेवा निवडा
   - निवास पुराव्यासह फॉर्म भरा
   - कागदपत्रे अपलोड करा
   - शुल्क भरणे (20-30 रुपये)
   - निवास रेकॉर्ड पडताळणी
   - 15-30 दिवसात प्रमाणपत्र''',
      },
      {
        'title': 'Ration Card (Food & Civil Supplies GR)',
        'pdfAsset': 'assets/pdfs/ratio_card_gr.pdf',
        'en': '''RATION CARD ELIGIBILITY & DETAILS

1. ELIGIBILITY CRITERIA:
   - Permanent resident of Maharashtra
   - Family income below specified limits
   - No existing ration card in family name
   - Valid address proof required
   - Aadhaar linking mandatory for all members

2. TYPES OF RATION CARDS:
   - Antyodaya (AAY) - Poorest families
   - Priority Household (PHH) - Below Poverty Line
   - Non-Priority Household (NPHH) - Above Poverty Line

3. REQUIRED DOCUMENTS:
   - Aadhaar Card (all family members)
   - Income Certificate
   - Address Proof (Electricity/Water bill)
   - Bank Passbook
   - Passport size photographs (all members)
   - Marriage Certificate (if applicable)
   - Birth Certificate (for children)

4. HOW TO APPLY:
   - Visit Aaple Sarkar portal
   - Select "Ration Card" service
   - Fill application with family details
   - Upload documents for all members
   - Pay fees (Rs. 10-20)
   - Submit to Food Supply Office
   - Verification by Inspector
   - Card issued within 30 days

5. BENEFITS:
   - Subsidized food grains (wheat, rice, sugar)
   - Kerosene at subsidized rates
   - Serves as address and identity proof''',
        'hi': '''राशन कार्ड पात्रता एवं विवरण

1. पात्रता मानदंड:
   - महाराष्ट्र का स्थायी निवासी
   - निर्धारित सीमा से कम पारिवारिक आय
   - परिवार के नाम पर कोई मौजूदा राशन कार्ड नहीं
   - वैध पता प्रमाण आवश्यक
   - सभी सदस्यों के लिए आधार लिंकिंग अनिवार्य

2. राशन कार्ड के प्रकार:
   - अंत्योदय (AAY) - सबसे गरीब परिवार
   - प्राथमिकता परिवार (PHH) - गरीबी रेखा से नीचे
   - गैर-प्राथमिकता परिवार (NPHH) - गरीबी रेखा से ऊपर

3. आवश्यक दस्तावेज:
   - आधार कार्ड (सभी सदस्य)
   - आय प्रमाणपत्र
   - पता प्रमाण (बिजली/पानी बिल)
   - बैंक पासबुक
   - पासपोर्ट फोटो (सभी सदस्य)
   - विवाह प्रमाणपत्र
   - जन्म प्रमाणपत्र (बच्चों के लिए)

4. आवेदन कैसे करें:
   - आपले सरकार पोर्टल पर जाएं
   - राशन कार्ड सेवा चुनें
   - परिवार विवरण के साथ फॉर्म भरें
   - सभी सदस्यों के दस्तावेज अपलोड
   - शुल्क भुगतान (10-20 रुपये)
   - निरीक्षक द्वारा सत्यापन
   - 30 दिनों में कार्ड जारी

5. लाभ:
   - सब्सिडी वाले खाद्यान्न (गेहूं, चावल, चीनी)
   - सब्सिडी दरों पर मिट्टी का तेल
   - पता और पहचान प्रमाण के रूप में''',
        'mr': '''रेशन कार्ड पात्रता व तपशील

1. पात्रता निकष:
   - महाराष्ट्राचा कायमचा रहिवासी
   - निर्दिष्ट मर्यादेपेक्षा कमी कौटुंबिक उत्पन्न
   - कुटुंबाच्या नावावर विद्यमान रेशन कार्ड नाही
   - वैध पत्ता प्रमाण आवश्यक
   - सर्व सदस्यांसाठी आधार लिंकिंग अनिवार्य

2. रेशन कार्डाचे प्रकार:
   - अंत्योदय (AAY) - सर्वात गरीब कुटुंबे
   - प्राधान्य कुटुंब (PHH) - दारिद्र्यरेषेखाली
   - गैर-प्राधान्य कुटुंब (NPHH) - दारिद्र्यरेषेवर

3. आवश्यक कागदपत्रे:
   - आधार कार्ड (सर्व सदस्य)
   - उत्पन्न प्रमाणपत्र
   - पत्ता प्रमाण (वीज/पाणी बिल)
   - बँक पासबुक
   - पासपोर्ट फोटो (सर्व सदस्य)
   - विवाह प्रमाणपत्र
   - जन्म दाखला (मुलांसाठी)

4. अर्ज कसा करावा:
   - आपले सरकार पोर्टलवर जा
   - रेशन कार्ड सेवा निवडा
   - कुटुंब तपशीलासह फॉर्म भरा
   - सर्व सदस्यांची कागदपत्रे अपलोड
   - शुल्क भरणे (10-20 रुपये)
   - निरीक्षकाद्वारे पडताळणी
   - 30 दिवसात कार्ड जारी

5. फायदे:
   - अनुदानित धान्य (गहू, तांदूळ, साखर)
   - अनुदानित दरात रॉकेल
   - पत्ता आणि ओळख पुरावा म्हणून''',
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
    switch (index % 6) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.teal;
      case 5:
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

  List<Color> _getGradientColors(int index) {
    switch (index % 6) {
      case 0:
        return [Colors.blue.shade100, Colors.blue.shade50];
      case 1:
        return [Colors.orange.shade100, Colors.orange.shade50];
      case 2:
        return [Colors.green.shade100, Colors.green.shade50];
      case 3:
        return [Colors.purple.shade100, Colors.purple.shade50];
      case 4:
        return [Colors.teal.shade100, Colors.teal.shade50];
      case 5:
        return [Colors.pink.shade100, Colors.pink.shade50];
      default:
        return [Colors.blue.shade100, Colors.blue.shade50];
    }
  }
}
