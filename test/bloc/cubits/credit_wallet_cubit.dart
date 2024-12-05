import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/bloc/cubits/credits_wallet_cubit.dart';
import 'package:mimbo/data/models/credits.dart';

void main() {
  group('CreditsWalletCubit', () {
    late CreditsWalletCubit creditsWalletCubit;
    DateTime earlyDate = DateTime(2021, 1, 1);
    DateTime lateDate = DateTime(2021, 1, 2);
    MimCredit mimCredit = MimCredit(
      id: 'id1',
      createdAt: earlyDate,
      attributedToTestId: 'test1',
      consumedAt: lateDate,
      consumedWithAnswerId: 'consumedTestId1',
      earnedWithTestId: 'earnedTestId1',
      earnedByUserId: 'userId',
    );
    setUp(() {
      creditsWalletCubit = CreditsWalletCubit();
    });

    tearDown(() {
      creditsWalletCubit.close();
    });

    test('initial state is CreditsWalletState with empty mimCredits', () {
      expect(
        creditsWalletCubit.state,
        CreditsWalletState(
          creditsWallet: CreditsWallet(mimCredits: []),
        ),
      );
    });

    MimCredit credit3 = MimCredit(
        id: 'id3',
        createdAt: earlyDate,
        attributedToTestId: 'test',
        consumedAt: lateDate,
        consumedWithAnswerId: 'consumedWithAnswerId',
        earnedWithTestId: 'fafa',
        earnedByUserId: 'earnedByUserId');

    // blocTest<CreditsWalletCubit, CreditsWalletState>(
    //   'emits updated state when a credit is added',
    //   build: () => creditsWalletCubit,
    //   act: (cubit) => cubit.addCredit(
    //     credit3,
    //   ),
    //   expect: () => [
    //     CreditsWalletState(
    //       creditsWallet: CreditsWallet(
    //         mimCredits: [credit3],
    //       ),
    //     ),
    //   ],
    // );
    //
    // blocTest<CreditsWalletCubit, CreditsWalletState>(
    //   'emits updated state when a credit is consumed',
    //   build: () {
    //     final cubit = CreditsWalletCubit();
    //     cubit.addCredit(mimCredit);
    //     return cubit;
    //   },
    //   act: (cubit) => cubit.consumeCredit('test-answer-id'),
    //   expect: () => [
    //     CreditsWalletState(
    //       creditsWallet: CreditsWallet(
    //         mimCredits: [],
    //       ),
    //     ),
    //   ],
    // );
    //
    // test('consumeCredit does nothing if answerId is not found', () {
    //   int total = creditsWalletCubit.state.creditsWallet.getTotalOfAvailableCredits();
    //   creditsWalletCubit.consumeCredit('non-existent-id');
    //
    //   expect(
    //     creditsWalletCubit.state,
    //     CreditsWalletState(
    //       creditsWallet: CreditsWallet(mimCredits: []),
    //     ),
    //   );
    // });

    // TODO add more test to add & consume credits
  });
}
