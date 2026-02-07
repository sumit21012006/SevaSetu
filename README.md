# SevaSetu - Voice-First Civic Intelligence System

A production-quality Flutter mobile application implementing a voice-first civic intelligence system with agentic reasoning, global voice navigation, and Firebase backend.

## 🎯 Core Concept

SevaSetu is a digital seva kendra operator that listens, thinks, asks clarifying questions, and guides users to the right information and services through an intuitive voice-first interface.

## 🎤 Key Features

### Voice-First Navigation

- **Global Microphone Button**: Floating mic icon visible on every screen
- **Voice Assistant Overlay**: Bottom sheet for voice interaction with real-time transcription
- **Speech-to-Text**: Integration with platform STT for live transcription
- **Text-to-Speech**: Flutter TTS for voice responses and guidance

### Agentic Intent Engine

- **Intent Recognition**: Advanced pattern matching for complex user commands
- **Context-Aware Navigation**: Routes to appropriate screens based on intent
- **Follow-up Questions**: Asks clarifying questions when information is missing
- **Multilingual Support**: Ready for English, Marathi, and Hindi

### Complete Service Ecosystem

- **Authentication**: Firebase Auth with email/phone login and registration
- **Document Vault**: Firebase Storage integration with document management and validity tracking
- **Service Guidance**: Detailed service information, eligibility rules, and required documents
- **GR Explanation**: Simplified government rule summaries in multiple languages

## 🏗️ Architecture

### Clean MVVM Architecture

- **Provider**: State management for services and data
- **Central Controllers**: VoiceAgentController, NavigationService, AuthService
- **Decoupled UI and Logic**: Scalable and maintainable code

### Core Services

- **VoiceAgentController**: Voice processing, intent analysis, and navigation
- **AuthService**: Firebase authentication and user management
- **NavigationService**: App navigation with route management
- **DocumentService**: Document management with Firebase Storage

## 📱 Screens

1. **Authentication Screen**: Firebase Auth with email/phone login and registration
2. **Home Dashboard**: Quick services, document readiness indicators, and voice assistant intro
3. **Document Vault**: Firebase Storage integration with document management and validity tracking
4. **Service Guidance**: Detailed service information, eligibility rules, and required documents
5. **GR Explanation**: Simplified government rule summaries in multiple languages

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest version)
- Android Studio/VS Code with Flutter extension
- Firebase project (optional for demo mode)

### Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd sevasetu_app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Firebase Setup (Optional):**
   - Create Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android app with package name: `com.sevasetu.sevasetu_app`
   - Download `google-services.json` and place in `android/app/` folder
   - Enable Authentication, Firestore, and Storage in Firebase console
   - Update Firebase config with real credentials

4. **Run the application:**

   ```bash
   # For Android
   flutter run

   # For Web
   flutter run -d chrome
   ```

## 🎙️ Voice Commands

Try these commands with the voice assistant:

- "Open my documents"
- "Apply for scholarship"
- "What is driving license?"
- "Show expired documents"
- "Open document vault"
- "Check my document validity"
- "Show my document vault"

## 🔧 Firebase Integration

### Required Firebase Services

- **Authentication**: Email/Password and Phone Auth
- **Firestore**: User profiles, document metadata, and services
- **Storage**: Document file storage
- **Security Rules**: User-scoped access control

### Security Rules

```javascript
// Firestore Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /users/{userId}/documents/{documentId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}

// Storage Rules
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{documentId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 📦 Dependencies

### Core Flutter Packages

- `firebase_core`: Firebase core functionality
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `firebase_storage`: File storage
- `provider`: State management
- `speech_to_text`: Voice recognition
- `flutter_tts`: Text-to-speech

## 🎨 Design Principles

### Accessibility First

- Large, readable fonts
- High contrast colors
- Simple, intuitive navigation
- Voice-first interface for users with limited digital literacy

### User Experience

- Global microphone button for instant voice access
- Context-aware responses
- Multilingual support
- Progressive disclosure of information

## 🚀 Production Features

### Voice Intelligence

- Real-time speech transcription
- Intent recognition and routing
- Contextual follow-up questions
- Multilingual TTS support

### Document Management

- Upload and organize documents
- Automatic validity tracking
- Expiry date notifications
- Categorized document storage

### Service Guidance

- Step-by-step service procedures
- Required document checklists
- Eligibility criteria explanations
- Common question answers

## 📱 Platform Support

- **Android**: Full native support with Firebase integration
- **iOS**: Full native support with Firebase integration
- **Web**: Demo mode with mock data (Firebase optional)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Firebase for backend services
- Speech-to-Text and TTS plugin developers
- All contributors and testers

## 📞 Contact

For support and questions:

- Email: [your-email@example.com]
- Project Link: [https://github.com/yourusername/sevasetu_app]

---

**SevaSetu** - Bridging the digital divide through voice-first technology! 🎙️✨
