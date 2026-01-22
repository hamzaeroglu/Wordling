# Wordling

## Proje Özeti
Wordling, kelime dağarcığını geliştirmeyi hedefleyen, içerisinde Wordle benzeri bir bulmaca, çoktan seçmeli bilgi yarışması (Quiz) ve kapsamlı bir sözlük modülü barındıran Flutter tabanlı mobil uygulamadır. Proje, tek bir uygulama içerisinde farklı oyun mekaniklerini barındırması ve yerel/uzak veri kaynaklarını hibrit bir yapıda kullanması ile öne çıkar.

## Teknik Öne Çıkanlar
*   **Hibrit Veri Yönetimi:**
    *   **Statik Veri:** Performans optimizasyonu için on binlerce kelimeyi içeren sözlük veritabanı, harf bazlı parçalanmış JSON dosyaları (`a.json`, `b.json` vb.) olarak tutulmaktadır. Bu yapı, tek bir büyük veritabanı dosyasını belleğe yüklemek yerine, ihtiyaç duyulan veri setinin anlık olarak parse edilmesini sağlar.
    *   **Kullanıcı Verisi:** Favorilere eklenen kelimeler gibi kullanıcıya özgü dinamik veriler için **SQLite (`sqflite`)** kullanılarak kalıcı veri saklama (persistence) sağlanmıştır.
    *   **Uzak Konfigürasyon:** Uygulama içi kritik güncellemeler ve bildirim yönetimi için **Firebase** altyapısı entegre edilmiştir.
*   **Oyun Mantığı ve Algoritmalar:**
    *   Wordle oyun motoru, kullanıcının girdiği kelimeleri harf-konum doğrulaması yapan ve oyun durumunu (kazanma/kaybetme/haklar) yöneten özel bir mantıkla geliştirilmiştir.
    *   Quiz modülü, mevcut sözlük veri setinden rastgele örneklem oluşturarak dinamik soru üretim algoritmasına sahiptir.
*   **Modüler Mimari:** Oyun modülleri (Wordle, Quiz) ve yardımcı araçlar (Sözlük, Arama), birbirinden bağımsız çalışabilecek şekilde ayrıştırılmış ancak ortak veri sağlayıcıları (`DataProvider`) üzerinden beslenen bir yapıda kurgulanmıştır.

## Kullanılan Teknolojiler
*   **Dil & Framework:** Dart, Flutter
*   **Backend & Servisler:**
    *   **Firebase:** Core, Firestore (NoSQL veritabanı), Authentication, Messaging (FCM).
    *   **OneSignal:** Gelişmiş push bildirim yönetimi.
*   **Yerel Veritabanı:** Sqflite (SQLite)
*   **UI & Animasyon:** `flutter_animate`, `circular_menu`, `grock` (UI kit/Navigation).
*   **Monetization:** Google Mobile Ads (AdMob).

## Bu Proje Neyi Gösteriyor
Bu proje aşağıdaki yazılım geliştirme yetkinliklerini örneklemektedir:
*   **Full-Stack Mobil Geliştirme:** UI tasarımından backend entegrasyonuna kadar uçtan uca uygulama geliştirme süreci.
*   **Veri Modelleme ve Optimizasyon:** Büyük veri setlerinin (sözlük) mobil cihaz kaynaklarını verimli kullanacak şekilde (JSON partitioning) yönetilmesi.
*   **Asenkron Programlama:** `Future` ve `Stream` yapıları ile veri okuma, veritabanı işlemleri ve ağ isteklerinin yönetimi.
*   **Üçüncü Parti Entegrasyonlar:** Reklam ağları, bildirim servisleri ve analitik araçlarının bir mobil projeye başarılı entegrasyonu.
*   **State Management:** Karmaşık oyun durumlarının ve kullanıcı etkileşimlerinin yönetimi.