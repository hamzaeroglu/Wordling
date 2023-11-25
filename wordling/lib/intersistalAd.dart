import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static final adUnitId = 'ca-app-pub-4065499643683154/2679873342';

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('Interstitial ad is not loaded. Loading the ad...');
      loadInterstitialAd();
    } else {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          debugPrint('Interstitial ad dismissed.');
          // Reklam kapatıldıktan sonra tekrar yüklenmesi gerekebilir
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          debugPrint('Interstitial ad failed to show: $error');
          // Reklam gösterilemezse tekrar yüklenmesi gerekebilir
          loadInterstitialAd();
        },
      );

      _interstitialAd!.show();
    }
  }
}
