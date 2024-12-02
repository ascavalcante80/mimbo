import 'package:emoji_regex/emoji_regex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputValidator {
  static String? validateUsernameField(String? username, BuildContext context) {
    /// The [validateUsernameField] method validates the username of a user.
    /// The username must not be empty, must not contain special characters,
    /// must not contain emojis, and must not be longer than 100 characters. It
    /// is important to normalize the username before validating it.
    /// Usernames must be lower case and can contain numbers, letters,
    /// and single '.' (between letters and numbers) .

    int maxLength = 100;
    String usernameNormalized = usernameNormalizer(username);

    // check if username contains spaces
    if (usernameNormalized.contains(' ')) {
      // return AppLocalizations.of(context)!.usernameInputValidatorSpaces;
      return 'error validating username';
    }

    if (usernameNormalized.isEmpty) {
      // return AppLocalizations.of(context)!.usernameInputValidatorEmpty;
      return 'error validating username';

    }

    if (usernameNormalized.startsWith(r'.') ||
        usernameNormalized.endsWith(r'.')) {
      // return AppLocalizations.of(context)!.usernameInputValidatorStartByDot;
      return 'error validating username';

    }

    if (usernameNormalized.contains('..')) {
      // return AppLocalizations.of(context)!.usernameInputValidatorDoubleDot;
      return 'error validating username';

    }

    // check if us
    RegExp usernameRx = RegExp(r'^[a-z0-9]+(?:\.[a-z0-9]+)*$');
    if (!usernameRx.hasMatch(usernameNormalized)) {
      // return AppLocalizations.of(context)!.usernameInputValidatorLowerCase;
      return 'error validating username';

    }

    if (usernameNormalized.length > maxLength) {
      // return AppLocalizations.of(context)!
      //     .usernameInputValidatorTooLong(maxLength);
      return 'error validating username';

    }

    // Add check for emojis
    final emojiRx = emojiRegex();
    if (emojiRx.hasMatch(usernameNormalized)) {
      // return AppLocalizations.of(context)!.usernameInputValidatorEmoji;
      return 'error validating username';

    }

    return null;
  }

  static String? validateProperNounsField(
      String? properNoun, BuildContext context) {
    String properNounNormalized = normalizeProperNouns(properNoun);

    if (properNounNormalized.isEmpty) {
      // return AppLocalizations.of(context)!
      //     .nameInputValidatorProperNounCannotBeEmpty;
      return 'error validating username';

    }

    // Add a check for special characters
    if (properNounNormalized
        .contains(RegExp(r'[!@#<>?":_;[\]\\|=+)(*&^%0-9]'))) {
      // return AppLocalizations.of(context)!
      //     .nameInputValidatorProperNounCannotSpecialChars;
      return 'error validating username';

    }

    //  Add check for emojis
    final emojiRx = emojiRegex();
    if (emojiRx.hasMatch(properNounNormalized)) {
      // return AppLocalizations.of(context)!.nameInputValidatorProperNounEmojis;
      return 'error validating username';

    }
    return null;
  }

  static String normalizeProperNouns(String? properNoun) {
    if (properNoun == null) {
      return '';
    }
    properNoun = properNoun.trim();
    properNoun = properNoun.replaceAll(RegExp(r'\s+'), ' ');
    return properNoun;
  }

  static String usernameNormalizer(String? username) {
    /// The [usernameNormalizer] method normalizes the username of a user.
    /// It trims the username and removes multiple spaces in the username.

    if (username == null) {
      return '';
    }
    username = username.trim();
    return username;
  }
}
