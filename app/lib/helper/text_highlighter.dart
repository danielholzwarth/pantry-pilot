import 'package:flutter/material.dart';

class TextHiglighter {
  static Widget highlightText(BuildContext context, String text, String query, [double? fontSize, FontWeight? fontWeight]) {
    fontSize ?? 16;
    fontWeight ?? FontWeight.w100;

    if (query != "") {
      if (text.toLowerCase().contains(query.toLowerCase())) {
        int startIndex = text.toLowerCase().indexOf(query.toLowerCase());
        int endIndex = startIndex + query.length;

        return Row(
          children: [
            Text(
              startIndex > 0 ? text.substring(0, startIndex) : "",
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: fontSize, fontWeight: fontWeight),
            ),
            Text(
              text.substring(startIndex, endIndex),
              style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
            ),
            Text(
              endIndex < text.length ? text.substring(endIndex) : "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ],
        );
      }
      return Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
