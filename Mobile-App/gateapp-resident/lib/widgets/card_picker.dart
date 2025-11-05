import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_button.dart';
import 'entry_field.dart';
import 'toaster.dart';

class CardPicker {
  static Future<dynamic> pickCard(
      BuildContext context, CardInfo? cardInfo, bool? saveCardInfo) {
    TextEditingController nameController =
        TextEditingController(text: cardInfo != null ? cardInfo.cardName : "");
    TextEditingController numberController = TextEditingController(
        text: cardInfo != null ? cardInfo.cardNumber : "");
    TextEditingController monthController = TextEditingController(
        text: cardInfo != null ? cardInfo.cardMonth.toString() : "");
    TextEditingController yearController = TextEditingController(
        text: cardInfo != null ? cardInfo.cardYear.toString() : "");
    TextEditingController cvcController = TextEditingController(
        text: cardInfo != null ? cardInfo.cardCvv.toString() : "");
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                AppLocalization.instance
                    .getLocalizationFor("card_info")
                    .toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.67,
                    ),
              ),
              children: [
                EntryField(
                  controller: nameController,
                  label:
                      AppLocalization.instance.getLocalizationFor("card_name"),
                ),
                EntryField(
                  controller: numberController,
                  label: AppLocalization.instance
                      .getLocalizationFor("card_number"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: monthController,
                  label: AppLocalization.instance
                      .getLocalizationFor("card_exp_month"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: yearController,
                  label: AppLocalization.instance
                      .getLocalizationFor("card_exp_year"),
                  keyboardType: TextInputType.number,
                ),
                EntryField(
                  controller: cvcController,
                  label:
                      AppLocalization.instance.getLocalizationFor("card_cvv"),
                  keyboardType: TextInputType.number,
                ),
                CustomButton(
                  onTap: () async {
                    int month = int.tryParse(monthController.text) ?? 0;
                    int year = int.tryParse(yearController.text) ?? 0;
                    if (month > 12 && month < 1) {
                      Toaster.showToastBottom(AppLocalization.instance
                          .getLocalizationFor("card_invalid_month"));
                    } else if (year < DateTime.now().year) {
                      Toaster.showToastBottom(AppLocalization.instance
                          .getLocalizationFor("card_invalid_year"));
                    } else if (numberController.text.length < 10) {
                      Toaster.showToastBottom(AppLocalization.instance
                          .getLocalizationFor("card_invalid_number"));
                    } else if (nameController.text.isEmpty) {
                      Toaster.showToastBottom(AppLocalization.instance
                          .getLocalizationFor("card_invalid_name"));
                    } else {
                      CardInfo cardInfo = CardInfo(
                        nameController.text,
                        numberController.text,
                        month,
                        year,
                        cvcController.text,
                      );
                      if (saveCardInfo != null && saveCardInfo == true) {
                        await CardInfo.saveCard(cardInfo);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, cardInfo);
                    }
                  },
                  title:
                      AppLocalization.instance.getLocalizationFor("continue"),
                )
              ],
            ));
  }

  static Future<CardInfo?> getSavedCard() {
    return CardInfo.getCard();
  }
}

class CardInfo {
  final String cardName, cardNumber, cardCvv;
  final int cardMonth, cardYear;

  CardInfo(this.cardName, this.cardNumber, this.cardMonth, this.cardYear,
      this.cardCvv);

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      json['cardName'] as String,
      json['cardNumber'] as String,
      json['cardMonth'] as int,
      json['cardYear'] as int,
      json['cardCvv'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cardName': cardName,
      'cardNumber': cardNumber,
      'cardMonth': cardMonth,
      'cardYear': cardYear,
      'cardCvv': cardCvv
    };
  }

  static Future<bool> saveCard(CardInfo cardInfo) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('payment_card', jsonEncode(cardInfo));
  }

  static Future<CardInfo?> getCard() async {
    CardInfo? toReturn;
    final prefs = await SharedPreferences.getInstance();
    String? paymentCard = prefs.getString("payment_card");
    if (paymentCard != null) {
      try {
        toReturn = CardInfo.fromJson(jsonDecode(paymentCard));
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    return toReturn;
  }
}
