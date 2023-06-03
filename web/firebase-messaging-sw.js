importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBEXaIvNt-O04PGwnLI6sE7JOul9YHTAXw",
  authDomain: "appwrite-hackathon.firebaseapp.com",
  databaseURL: "https://appwrite-hackathon-default-rtdb.firebaseio.com",
  projectId: "appwrite-hackathon",
  storageBucket: "appwrite-hackathon.appspot.com",
  messagingSenderId: "323737700336",
  appId: "1:323737700336:web:d79484c9b65c131f1f7f35",
  measurementId: "G-FB1BK4HF87"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});