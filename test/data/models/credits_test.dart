import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mimbo/bloc/cubits/credits_wallet_cubit.dart';
import 'package:mimbo/bloc/cubits/project_cubit.dart';
import 'package:mimbo/bloc/cubits/user_cubit.dart';
import 'package:mimbo/data/constants.dart';
import 'package:mimbo/data/models/credits.dart';
import 'package:mimbo/data/models/projects.dart';

// import 'package:gnomee/constants/enums.dart';
// import 'package:gnomee/data/models/user.dart';
// import 'package:gnomee/data/repositories/firebase_manager.dart';
// import 'package:gnomee/data/repositories/user_manager.dart';
// import 'package:gnomee/utils/date_tools.dart';
import 'package:mimbo/data/models/users.dart';
import 'package:mimbo/data/repositories/firebase_manager.dart';
import 'package:mimbo/data/repositories/project_manager.dart';
import 'package:mimbo/data/repositories/user_manager.dart';

void main() {
  group('Tests MimCredit operations', () {
    test('Validates coherence when instantiating MimCredit object', () async {
      String userId = 'userId';
      String testId1 = 'testId1';

      bool catchTestId = false;
      try {
        MimCredit credit = MimCredit(
          id: 'id',
          createdAt: DateTime.now(),
          attributedToTestId: testId1,
          consumedAt: DateTime.now(),
          consumedWithAnswerId: 'mockId',
          earnedWithTestId: 'mockId',
          earnedByUserId: userId,
        );
      } on AssertionError {
        catchTestId = true;
      }

      try {
        MimCredit credit = MimCredit(
          id: 'id',
          createdAt: DateTime.now(),
          attributedToTestId: 'testId2',
          consumedAt: DateTime.now(),
          consumedWithAnswerId: 'mockId',
          earnedWithTestId: 'testId1',
          earnedByUserId: userId,
        );
      } on AssertionError {
        catchTestId = true;
      }

      expect(catchTestId, true,
          reason: 'Test ID must be different for consumed and earned tests');

      DateTime firstDate = DateTime(2021, 1, 1);
      DateTime secondDate = DateTime(2021, 1, 2);
      bool catchDate = false;
      try {
        MimCredit credit1 = MimCredit(
          id: 'id',
          createdAt: secondDate,
          attributedToTestId: 'test3',
          consumedAt: firstDate,
          consumedWithAnswerId: 'test1',
          earnedWithTestId: 'test2',
          earnedByUserId: userId,
        );
      } on AssertionError {
        catchDate = true;
      }
      expect(catchDate, true,
          reason: 'Consumed date must be after earned date');

      bool catchEmptyId = false;
      try {
        MimCredit credit = MimCredit(
          id: '',
          createdAt: firstDate,
          attributedToTestId: '',
          consumedAt: secondDate,
          consumedWithAnswerId: '',
          earnedWithTestId: '',
          earnedByUserId: '',
        );
      } on AssertionError {
        catchEmptyId = true;
      }
      expect(catchEmptyId, true, reason: 'ID must not be empty');
    });
  });

  group('Tests CreditsWallet', () {
    test('Test wallet search operations', () async {
      DateTime earlyDate = DateTime(2021, 1, 1);
      DateTime lateDate = DateTime(2021, 1, 2);

      List<MimCredit> mimCredits = [
        MimCredit(
          id: 'id1',
          createdAt: earlyDate,
          attributedToTestId: 'test1',
          consumedAt: lateDate,
          consumedWithAnswerId: 'consumedTestId1',
          earnedWithTestId: 'earnedTestId1',
          earnedByUserId: 'userId',
        ),
        MimCredit(
          id: 'id2',
          createdAt: earlyDate,
          attributedToTestId: 'test2',
          consumedAt: lateDate,
          consumedWithAnswerId: 'consumedTestId2',
          earnedWithTestId: 'earnedTestId2',
          earnedByUserId: 'userId',
        ),
        MimCredit(
          id: 'id3',
          createdAt: earlyDate,
          attributedToTestId: 'test3',
          consumedAt: lateDate,
          consumedWithAnswerId: 'consumedTestId3',
          earnedWithTestId: 'earnedTestId3',
          earnedByUserId: 'userId',
        ),
        MimCredit(
          id: 'id4',
          createdAt: earlyDate,
          attributedToTestId: 'test3',
          consumedAt: null,
          consumedWithAnswerId: null,
          earnedWithTestId: 'earnedTestId3',
          earnedByUserId: 'userId',
        ),
        MimCredit(
          id: 'id5',
          createdAt: earlyDate,
          attributedToTestId: 'test3',
          consumedAt: null,
          consumedWithAnswerId: null,
          earnedWithTestId: 'earnedTestId3',
          earnedByUserId: 'userId',
        ),
      ];

      CreditsWallet creditsWallet = CreditsWallet(mimCredits: mimCredits);
      expect(creditsWallet.getTotalOfAvailableCredits(), 2,
          reason: 'MimCredit must be the same as the one searched');

      expect(creditsWallet.getTotalOfConsumedCredits(), 3,
          reason: 'MimCredit must be the same as the one searched');

      creditsWallet.consumeAvailableCredit('newAnswerId');
      expect(creditsWallet.getTotalOfAvailableCredits(), 1,
          reason: 'MimCredit must be the same as the one searched');

      expect(creditsWallet.getTotalOfConsumedCredits(), 4,
          reason: 'MimCredit must be the same as the one searched');

      // add new credit
      creditsWallet.addCredit(MimCredit(
        id: 'id6',
        createdAt: earlyDate,
        attributedToTestId: 'test1',
        consumedAt: null,
        consumedWithAnswerId: null,
        earnedWithTestId: 'earnedTestId1',
        earnedByUserId: 'userId',
      ));

      // balance should be increased
      expect(creditsWallet.getTotalOfAvailableCredits(), 2,
          reason: 'MimCredit must be the same as the one searched');

      bool catchDuplicateIdBeingAdded = false;
      try {
        creditsWallet.addCredit(MimCredit(
          id: 'id1',
          createdAt: earlyDate,
          attributedToTestId: 'test1',
          consumedAt: lateDate,
          consumedWithAnswerId: 'consumedTestId1',
          earnedWithTestId: 'earnedTestId1',
          earnedByUserId: 'userId',
        ));
      } on ErrorTryingAddConsumedCredit {
        catchDuplicateIdBeingAdded = true;
      }

      expect(catchDuplicateIdBeingAdded, true,
          reason: 'Cannot add a credit with the same ID');

      bool catchConsumedCreditBeingAdded = false;
      try {
        creditsWallet.addCredit(MimCredit(
          id: 'id6',
          createdAt: earlyDate,
          attributedToTestId: 'test1',
          consumedAt: lateDate,
          consumedWithAnswerId: 'consumedTestId1',
          earnedWithTestId: 'earnedTestId1',
          earnedByUserId: 'userId',
        ));
      } on ErrorTryingAddConsumedCredit {
        catchConsumedCreditBeingAdded = true;
      }
      expect(catchConsumedCreditBeingAdded, true,
          reason: 'Cannot add a consumed credit');

      bool catchDuplicatesIds = false;
      try {
        List<MimCredit> mimCredits = [
          MimCredit(
            id: 'id1',
            createdAt: earlyDate,
            attributedToTestId: 'test1',
            consumedAt: lateDate,
            consumedWithAnswerId: 'consumedTestId1',
            earnedWithTestId: 'earnedTestId1',
            earnedByUserId: 'userId',
          ),
          // using deliberately the same ID
          MimCredit(
            id: 'id1',
            createdAt: earlyDate,
            attributedToTestId: 'test2',
            consumedAt: lateDate,
            consumedWithAnswerId: 'consumedTestId2',
            earnedWithTestId: 'earnedTestId2',
            earnedByUserId: 'userId',
          ),
          MimCredit(
            id: 'id3',
            createdAt: earlyDate,
            attributedToTestId: 'test3',
            consumedAt: lateDate,
            consumedWithAnswerId: 'consumedTestId3',
            earnedWithTestId: 'earnedTestId3',
            earnedByUserId: 'userId',
          ),
          MimCredit(
            id: 'id4',
            createdAt: earlyDate,
            attributedToTestId: 'test3',
            consumedAt: null,
            consumedWithAnswerId: null,
            earnedWithTestId: 'earnedTestId3',
            earnedByUserId: 'userId',
          ),
          MimCredit(
            id: 'id5',
            createdAt: earlyDate,
            attributedToTestId: 'test3',
            consumedAt: null,
            consumedWithAnswerId: null,
            earnedWithTestId: 'earnedTestId3',
            earnedByUserId: 'userId',
          ),
        ];
        CreditsWallet(mimCredits: mimCredits);
      } on AssertionError {
        catchDuplicatesIds = true;
      }
      expect(catchDuplicatesIds, true,
          reason: 'List of MimCredit cannot have duplicated IDs');

      // consume an available credit
      creditsWallet.consumeAvailableCredit('newAnswerId');
      expect(creditsWallet.getTotalOfAvailableCredits(), 1,
          reason: 'MimCredit must be the same as the one searched');

      while (true) {
        try {
          await creditsWallet.consumeAvailableCredit('newAnswerId');
        } on NoCreditsAvailableException {
          expect(creditsWallet.getTotalOfAvailableCredits(), 0,
              reason: 'Balance should be zero when all credits are consumed');
          break;
        }
      }
    });
  });
}
