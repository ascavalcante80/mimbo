part of 'credits_wallet_cubit.dart';

class CreditsWalletState {
  final CreditsWallet creditsWallet;

  CreditsWalletState({required this.creditsWallet});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreditsWalletState &&
        other.creditsWallet == creditsWallet;
  }

  @override
  int get hashCode => creditsWallet.hashCode;
}