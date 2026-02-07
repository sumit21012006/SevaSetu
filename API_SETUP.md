# API Configuration Guide

## 🎤 Whisper AI Setup (Optional - Better Voice Recognition)

### Step 1: Get OpenAI API Key
1. Go to https://platform.openai.com/api-keys
2. Sign up or log in
3. Click "Create new secret key"
4. Copy the key (starts with `sk-...`)

### Step 2: Add API Key to App
Open `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Replace with your actual API key
  static const String WHISPER_API_KEY = 'sk-proj-xxxxxxxxxxxxx';
  
  // Set to true to enable Whisper AI
  static const bool USE_WHISPER = true;
}
```

### Step 3: Run the App
```bash
flutter pub get
flutter run
```

**That's it!** Voice recognition will now use Whisper AI for better accuracy.

---

## 📄 ML Kit OCR (Already Working!)

### ✅ No Setup Needed!
ML Kit OCR is already integrated and working. It:
- Works offline
- No API key required
- Free to use
- Already extracting dates from documents

### How It Works:
1. User captures document with camera
2. ML Kit OCR extracts all text
3. App finds dates using pattern matching
4. Shows Issue Date and Expiry Date

### Test It:
1. Go to Service Selection
2. Select any service
3. Tap "Upload Documents"
4. Capture a document with visible dates
5. Watch OCR extract the dates automatically!

---

## 🔧 Current Configuration

### Voice Recognition:
- **Default**: Native Speech-to-Text (Free, works offline)
- **Optional**: Whisper AI (Better accuracy, requires API key)

### OCR:
- **ML Kit**: Already integrated and working
- **No configuration needed**

---

## 💰 Cost Information

### Whisper AI:
- $0.006 per minute of audio
- Free tier: $5 credit for 3 months
- Example: 100 voice commands = ~$0.60

### ML Kit OCR:
- **Completely FREE**
- No limits
- Works offline

---

## 🚀 Quick Start

### For Demo (No API Key):
```dart
// In app_config.dart
static const bool USE_WHISPER = false;
```
Uses native speech-to-text (works fine for demo)

### For Production (Better Accuracy):
```dart
// In app_config.dart
static const String WHISPER_API_KEY = 'sk-your-key-here';
static const bool USE_WHISPER = true;
```

---

## 📱 Testing

### Test Voice Recognition:
1. Tap mic button on any screen
2. Say: "Apply for scholarship"
3. App should navigate to service selection

### Test OCR:
1. Go to Upload Document screen
2. Capture any certificate/ID with dates
3. OCR will extract Issue Date and Expiry Date

---

## ⚠️ Important Notes

1. **Whisper AI requires internet** - Native STT works offline
2. **ML Kit OCR works offline** - No internet needed
3. **For 50 demos** - Native STT is sufficient
4. **For production** - Whisper AI recommended for better accuracy

---

## 🎯 Recommendation

**For Your Demo:**
- Keep `USE_WHISPER = false`
- Use native speech-to-text
- ML Kit OCR already works perfectly
- No API keys needed!

**After Demo:**
- Add Whisper API key for better voice accuracy
- ML Kit OCR continues to work as-is

---

## 📞 Support

**Whisper AI Issues:**
- Check API key is correct
- Ensure internet connection
- Verify OpenAI account has credits

**ML Kit OCR Issues:**
- Ensure good lighting
- Document text should be clear
- Camera permissions granted

---

**Current Status:**
✅ ML Kit OCR - Working
✅ Native STT - Working
⚠️ Whisper AI - Optional (add API key to enable)
