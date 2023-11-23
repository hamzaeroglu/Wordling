import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {

  static BannerAd? myBanner;
  static void initialize() {
    if (myBanner == null) {
      myBanner = createBannerAd();
      myBanner!.load();
    }
  }

  static BannerAd? createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-4065499643683154/3910120574",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('Reklam yüklendi');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Reklam yüklenemedi: $error');
        },
      ),
    );
  }
}
