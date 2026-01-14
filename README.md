# Wordling 🌍🔤

**Wordling**, hem kelime davarcığınızı geliştirebileceğiniz hem de eğlenceli vakit geçirebileceğiniz kapsamlı bir Flutter kelime oyunudur. Klasik Wordle deneyimini, testler ve sözlük özellikleriyle birleştirir.

![App Banner](assets/images/banner_placeholder.png)


## 🚀 Özellikler

### 1. 🧩 Wordle (Kelime Bulmaca)
Klasik Wordle deneyimi şimdi cebinizde!
- **Çoklu Dil Desteği:** İster **Türkçe** ister **İngilizce** oynayın.
- **Zorluk Seviyeleri:**
  - **Easy (Kolay):** 4 harfli kelimeler
  - **Medium (Orta):** 5 harfli kelimeler
  - **Hard (Zor):** 6 harfli kelimeler
- **Görsel İpuçları:** Doğru harf (Yeşil), Yanlış yer (Sarı), Yanlış harf (Gri).

### 2. ❓ Kelime Testi (Quiz)
Kelime bilginizi test edin!
- Size bir kelime verilir ve anlamı sorulur (veya tam tersi).
- 3 şık arasından doğruyu bulmaya çalışın.
- Hatalı cevaplarda doğrusunu öğrenerek gelişin.

### 3. 📚 Sözlük & Rastgele Kelime
- **Rastgele Kelime:** Her gün veya istediğiniz an yeni bir kelime öğrenin.
- **Detaylı Arama:** Veritabanındaki binlerce kelime arasında arama yapın.
- **Örnek Cümleler:** Kelimelerin cümle içinde kullanımlarını görerek pekiştirin.

### 4. ❤️ Favorilerim
- Öğrendiğiniz veya sevdiğiniz kelimeleri favorilerinize ekleyin.
- Daha sonra tekrar etmek için favoriler listenize erişin.
- SQLite veritabanı sayesinde internet olmasa bile favorilerinize ulaşın.

---

## 🛠️ Teknolojiler & Kütüphaneler

Bu proje **Flutter** kullanılarak geliştirilmiştir.

- **Frontend:** Flutter (Dart)
- **State & UI Yönetimi:** `grock`, `flutter_animate`, `circular_menu`
- **Veri Tabanı (Lokal):** `sqflite` (Favoriler için)
- **Backend & Servisler:**
  - **Firebase Core & Firestore:** Uzak konfigürasyon ve veri.
  - **Firebase Messaging:** Push bildirimleri.
  - **OneSignal:** Gelişmiş bildirim yönetimi.
- **Reklam:** `google_mobile_ads` (AdMob Banner & Interstitial)
- **Veri Kaynağı:** JSON tabanlı yerel sözlük veritabanı.

---

## 📸 Ekran Görüntüleri

| Ana Sayfa | Wordle Oyunu | Quiz Ekranı |
|-----------|--------------|-------------|
| ![Home](assets/ss/home.png) | ![Wordle](assets/ss/wordle.png) | ![Quiz](assets/ss/quiz.png) |


---