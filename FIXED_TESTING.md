# 🔧 FIXED - Testing Guide

## ✅ What Was Fixed

1. **Permissions Added** - Mic, Camera, Storage
2. **Gallery Picker** - Changed from camera to gallery (easier testing)
3. **Error Handling** - Shows error messages
4. **Voice Recognition** - Better initialization

---

## 📱 STEP-BY-STEP TEST

### 1. Install & Run
```bash
flutter pub get
flutter run
```

**First time:** App will ask for permissions - **ALLOW ALL**

---

### 2. Login
- Email: `test@test.com`
- Password: `123456`
- Tap "Sign In"

---

### 3. Test Voice (FIXED)

1. Tap **blue mic button** (bottom right)
2. **ALLOW microphone permission** if asked
3. Say clearly: **"Apply for scholarship"**
4. Wait 2 seconds

**✅ WORKING IF:** Goes to Service Selection screen

**If not working:**
- Check mic permission in phone settings
- Speak louder and clearer
- Try: "Upload document" or "Go home"

---

### 4. Test Document Upload (FIXED)

1. Select "OBC Scholarship"
2. Tap "Upload Documents"
3. Tap **"Select Document from Gallery"** (changed from camera)
4. **ALLOW storage permission** if asked
5. Select ANY image with text/dates from your gallery

**✅ WORKING IF:** 
- Image appears
- Shows "Scanning..."
- Extracts dates

**If not working:**
- Use image with clear printed text
- Try different image
- Check storage permission

---

### 5. Check OCR Results

After selecting image, you should see:
```
OCR Results:
Issue Date: DD/MM/YYYY (or "Not detected")
Expiry Date: DD/MM/YYYY (or "Not detected")
```

**✅ OCR WORKING IF:** Any date is detected

---

## 🎯 QUICK TEST (1 minute)

```bash
1. Run app
2. Login (test@test.com / 123456)
3. Tap mic → Say "Apply for scholarship"
4. Select service → Upload → Pick image from gallery
5. See OCR results
```

---

## 📸 Test Images

**Good test images:**
- ID cards (Aadhaar, PAN, License)
- Certificates (Birth, Education)
- Bills with dates
- Any document with printed dates

**Download test image:**
- Search Google: "sample certificate with date"
- Save to phone gallery
- Use in app

---

## ⚠️ Common Issues

### Mic Not Working
```
Solution:
1. Go to Phone Settings
2. Apps → SevaSetu → Permissions
3. Enable Microphone
4. Restart app
```

### OCR Not Detecting Dates
```
Solution:
1. Use image with CLEAR printed text
2. Ensure dates are in format: DD/MM/YYYY or DD-MM-YYYY
3. Try different image
```

### Gallery Not Opening
```
Solution:
1. Enable Storage permission
2. Restart app
3. Try again
```

---

## ✅ SUCCESS CHECKLIST

- [ ] App launches
- [ ] Permissions granted (Mic, Camera, Storage)
- [ ] Login works
- [ ] Mic button visible
- [ ] Voice command recognized
- [ ] Gallery opens
- [ ] Image selected
- [ ] OCR processes image
- [ ] Dates extracted (or "Not detected" shown)
- [ ] Status screen shows
- [ ] GR explanation displays

---

## 🎤 Voice Commands to Try

- "Apply for scholarship"
- "Upload document"
- "Go home"
- "Apply for driving license"
- "Apply for income certificate"

---

## 📊 Expected Behavior

### Voice:
```
Tap Mic → "Listening..." → Transcribes → Navigates
```

### OCR:
```
Select Image → "Scanning..." → Shows Dates → Check Status
```

---

## 🚀 NOW RUN:

```bash
flutter pub get
flutter run
```

**Grant all permissions when asked!**

**Test with gallery images (easier than camera)**
