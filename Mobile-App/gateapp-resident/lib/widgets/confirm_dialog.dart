import 'package:flutter/material.dart';

class ConfirmDialog {
  static showConfirmation(BuildContext context, Widget titleWidget,
          Widget contentWidget, String? noButtonText, String yesButtonText) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          //backgroundColor: gradientColor2,
          title: titleWidget,
          content: contentWidget,
          actions: <Widget>[
            if (noButtonText != null)
              MaterialButton(
                textColor: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70)),
                onPressed: () => Navigator.pop(context, false),
                child: Text(noButtonText),
              ),
            MaterialButton(
              textColor: Theme.of(context).primaryColor,
              shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70)),
              onPressed: () => Navigator.pop(context, true),
              child: Text(yesButtonText),
            ),
          ],
        ),
      );
}
