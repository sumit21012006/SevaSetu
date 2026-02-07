// Give the service worker access to Firebase Messaging.
// Note that you can access Firebase Messaging via firebase.messaging() in index.html.
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: "AIzaSyB8Z8Qq4Z8QZ8QZ8QZ8QZ8QZ8QZ8QZ8QZ8",
  authDomain: "sevasetu-app.firebaseapp.com",
  projectId: "sevasetu-app",
  storageBucket: "sevasetu-app.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:1234567890abcdef"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});