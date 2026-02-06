# Whisper AI Integration Guide

## Setup Instructions

### 1. Get OpenAI API Key
1. Go to https://platform.openai.com/api-keys
2. Create a new API key
3. Copy the key

### 2. Enable Whisper in App

Add this code in your home screen or settings:

```dart
// Enable Whisper AI
final voiceAgent = Provider.of<VoiceAgentController>(context, listen: false);
voiceAgent.enableWhisper('YOUR_OPENAI_API_KEY');
```

### 3. Permissions

**Android** - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

**iOS** - Add to `ios/Runner/Info.plist`:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access for voice commands</string>
```

## Features

✅ **Better Accuracy**: Whisper AI provides superior transcription
✅ **Multilingual**: Supports 99+ languages
✅ **Offline Fallback**: Falls back to speech_to_text if API fails
✅ **Toggle**: Can switch between Whisper and native STT

## Usage

```dart
// In voice_assistant_overlay.dart or settings
ElevatedButton(
  onPressed: () {
    final voiceAgent = Provider.of<VoiceAgentController>(context, listen: false);
    if (voiceAgent.useWhisper) {
      voiceAgent.disableWhisper();
    } else {
      voiceAgent.enableWhisper('sk-...');
    }
  },
  child: Text(voiceAgent.useWhisper ? 'Use Native STT' : 'Use Whisper AI'),
)
```

## Cost

- Whisper API: $0.006 per minute
- Free tier: $5 credit for first 3 months
- Native STT: Free (but less accurate)

## Recommendation

Use Whisper AI for production for better accuracy, especially for Indian languages and accents.
