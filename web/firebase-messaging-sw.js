// web/firebase-messaging-sw.js

importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyBtVyRFbhndOZIdWI_7hsgAUcOsbgkloDc",
  authDomain: "game-mobile-26ab5.firebaseapp.com",
  projectId: "game-mobile-26ab5",
  storageBucket: "game-mobile-26ab5.firebasestorage.app",
  messagingSenderId: "290076135744",
  appId: "1:290076135744:web:ce5e2d9a22eedb4ec96aa5",
});


const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Mensagem recebida no background: ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png',
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
