import 'package:bloc/bloc.dart';

import '../../data/models/credits.dart';

part 'credits_wallet_state.dart';

class CreditsWalletCubit extends Cubit<CreditsWalletState> {
  CreditsWalletCubit()
      : super(
          CreditsWalletState(
            creditsWallet: CreditsWallet(mimCredits: []),
          ),
        );

  void consumeCredit(String answerId) async {
    await state.creditsWallet.consumeAvailableCredit(answerId);
    emit(
      CreditsWalletState(
        creditsWallet: state.creditsWallet,
      ),
    );
  }

  void addCredit(MimCredit credit) async {
    await state.creditsWallet.addCredit(credit);
    emit(
      CreditsWalletState(
        creditsWallet: state.creditsWallet,
      ),
    );
  }
}
