const admin = require('firebase-admin');
const serviceAccount = require('D:/flutter/projects/wordling/services/new-firebase-admin.json');
const cron = require('node-cron');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://wordling-d49b8.firebaseio.com',
});

const messaging = admin.messaging();

function sendDailyNotification() {
  const message = {
    notification: {
      title: 'Günlük Bildirim',
      body: 'Bu bir günlük bildirimdir.',
    },
    topic: 'all',
  };

  messaging.send(message)
    .then((response) => {
      console.log('Günlük bildirim başarıyla gönderildi:', response);
    })
    .catch((error) => {
      console.error('Bildirim gönderme hatası:', error);
    })
    .finally(() => {
      console.log('Günlük bildirim gönderme işlemi tamamlandı.');
    });
}



cron.schedule('25 14 * * *', () => {
  sendDailyNotification();
  console.log('Günlük bildirim gönderildi.');
});
function sendInstantNotification() {
  const message = {
    notification: {
      title: 'Anlık Bildirim',
      body: 'Bu bir anlık bildirimdir.',
    },
    topic:'all'
  };

  messaging.send(message)
    .then((response) => {
      console.log('Anlık bildirim başarıyla gönderildi:', response);
    })
    .catch((error) => {
      console.error('Bildirim gönderme hatası:', error);
    })
    .finally(() => {
      console.log('Anlık bildirim gönderme işlemi tamamlandı.');
    });
}

// Anlık bildirim göndermek için aşağıdaki satırı ekleyin
sendInstantNotification();
