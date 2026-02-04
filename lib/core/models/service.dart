class Service {
  final String serviceId;
  final String name;
  final String description;
  final List<String> requiredDocuments;
  final Map<String, dynamic> eligibilityRules;
  final String grSummary;
  final String grSummaryMarathi;
  final String grSummaryHindi;
  final List<String> commonQuestions;

  Service({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.requiredDocuments,
    required this.eligibilityRules,
    required this.grSummary,
    required this.grSummaryMarathi,
    required this.grSummaryHindi,
    required this.commonQuestions,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'name': name,
      'description': description,
      'requiredDocuments': requiredDocuments,
      'eligibilityRules': eligibilityRules,
      'grSummary': grSummary,
      'grSummaryMarathi': grSummaryMarathi,
      'grSummaryHindi': grSummaryHindi,
      'commonQuestions': commonQuestions,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      serviceId: map['serviceId'],
      name: map['name'],
      description: map['description'],
      requiredDocuments: List<String>.from(map['requiredDocuments']),
      eligibilityRules: Map<String, dynamic>.from(map['eligibilityRules']),
      grSummary: map['grSummary'],
      grSummaryMarathi: map['grSummaryMarathi'],
      grSummaryHindi: map['grSummaryHindi'],
      commonQuestions: List<String>.from(map['commonQuestions']),
    );
  }
}

// Mock services for demo
class MockServices {
  static List<Service> getServices() {
    return [
      Service(
        serviceId: 'obc_scholarship',
        name: 'OBC Scholarship',
        description:
            'Financial assistance for OBC students pursuing higher education',
        requiredDocuments: [
          'Income Certificate',
          'Caste Certificate',
          'Aadhaar Card',
          'Bank Passbook',
          'Educational Certificates',
        ],
        eligibilityRules: {
          'caste': 'OBC',
          'incomeLimit': 'Below 8 LPA',
          'educationLevel': '10th pass and above',
          'ageLimit': '18-25 years',
        },
        grSummary:
            'The OBC Scholarship scheme provides financial assistance to students from Other Backward Classes who are pursuing higher education. The scheme aims to promote educational equity and social inclusion.',
        grSummaryMarathi:
            'OBC छात्रवृत्ती योजना उच्च शिक्षण घेत असलेल्या इतर मागासवर्गीय विद्यार्थ्यांना आर्थिक मदत प्रदान करते. या योजनेचा उद्देश शैक्षणिक समानता आणि सामाजिक समावेशन बढवणे आहे.',
        grSummaryHindi:
            'OBC छात्रवृत्ति योजना उच्च शिक्षा प्राप्त करने वाले अन्य पिछड़ा वर्ग के छात्रों को वित्तीय सहायता प्रदान करती है। इस योजना का उद्देश्य शैक्षिक समानता और सामाजिक समावेशन को बढ़ावा देना है।',
        commonQuestions: [
          'What documents are required for OBC scholarship?',
          'What is the income limit for OBC scholarship?',
          'How to apply for OBC scholarship online?',
        ],
      ),
      Service(
        serviceId: 'driving_license',
        name: 'Driving License',
        description: 'Apply for new driving license or renew existing one',
        requiredDocuments: [
          'Aadhaar Card',
          'PAN Card',
          'Passport Size Photographs',
          'Educational Certificates',
          'Medical Certificate',
        ],
        eligibilityRules: {
          'ageLimit': '18 years and above',
          'education': 'Minimum 8th pass',
          'medicalFitness': 'Required for commercial vehicles',
        },
        grSummary:
            'The driving license system regulates motor vehicle operation to ensure road safety and driver competency. Applicants must meet age, education, and medical fitness requirements.',
        grSummaryMarathi:
            'ड्राइविंग लायसन्स प्रणाली मोटर वाहन चालवण्याचे नियमन करते जेणेकरून रस्त्यावरील सुरक्षा आणि चालकाची पात्रता सुनिश्चित केली जाऊ शकेल.',
        grSummaryHindi:
            'ड्राइविंग लाइसेंस प्रणाली मोटर वाहनों के संचालन को विनियमित करती है ताकि सड़क सुरक्षा और ड्राइवर की योग्यता सुनिश्चित की जा सके।',
        commonQuestions: [
          'What documents are needed for driving license?',
          'How to book driving test online?',
          'What is the fee for driving license renewal?',
        ],
      ),
      Service(
        serviceId: 'income_certificate',
        name: 'Income Certificate',
        description:
            'Official document proving annual income for various government schemes',
        requiredDocuments: [
          'Aadhaar Card',
          'Ration Card',
          'Bank Statements',
          'Employment Proof',
        ],
        eligibilityRules: {
          'residency': 'Must be resident of the state',
          'incomeProof': 'Required for all family members',
        },
        grSummary:
            'Income certificate is an essential document required for availing various government schemes and benefits. It serves as proof of annual family income.',
        grSummaryMarathi:
            'उत्पन्न प्रमाणपत्र हे विविध सरकारी योजना आणि सवलतांसाठी आवश्यक असलेले एक महत्वाचे दस्तऐवज आहे. हे वार्षिक कुटुंब उत्पन्नाचा पुरावा म्हणून काम करते.',
        grSummaryHindi:
            'आय प्रमाण पत्र विभिन्न सरकारी योजनाओं और लाभों का लाभ उठाने के लिए आवश्यक एक महत्वपूर्ण दस्तावेज है। यह वार्षिक पारिवारिक आय के प्रमाण के रूप में कार्य करता है।',
        commonQuestions: [
          'How to apply for income certificate online?',
          'What is the validity of income certificate?',
          'Where to get income certificate from?',
        ],
      ),
    ];
  }
}

extension ServiceExtensions on Service {
  static List<Service> getServices() {
    return MockServices.getServices();
  }
}
