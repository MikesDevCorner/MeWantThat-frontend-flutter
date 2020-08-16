import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService {

  static final Color prime = const Color(0xff2A628F);
  static final Color back = const Color(0xffFCF9ED);
  static final Color accent = const Color(0xff13293D);
  static final Color text = const Color(0xff3B2D29);
  static final Color textAlt = const Color(0xff7A0F0F);

  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      primaryColor: ThemeService.prime,
      accentColor: ThemeService.accent,
      backgroundColor: ThemeService.back,
      scaffoldBackgroundColor: ThemeService.back,
      buttonColor: ThemeService.accent,
      cursorColor: ThemeService.textAlt,
      focusColor: ThemeService.accent,
      highlightColor: ThemeService.text,
      indicatorColor: ThemeService.textAlt,
      dividerColor: ThemeService.prime,
      hintColor: ThemeService.text,
      //fontFamily: 'Georgia', //openSansTextTheme //ubuntuTextTheme //latoTextTheme //robotoTextTheme
      primaryTextTheme: GoogleFonts.ubuntuTextTheme(
        TextTheme( //contrasts with primary color
          headline1: TextStyle(color: ThemeService.back),
          headline2: TextStyle(color: ThemeService.back),
          headline3: TextStyle(color: ThemeService.back),
          headline4: TextStyle(color: ThemeService.back),
          headline5: TextStyle(color: ThemeService.back),
          headline6: TextStyle(color: ThemeService.back),
          subtitle1: TextStyle(color: ThemeService.back),
          subtitle2: TextStyle(color: ThemeService.back),
          bodyText1: TextStyle(color: ThemeService.text),
          bodyText2: TextStyle(color: ThemeService.back),
          button: TextStyle(color: ThemeService.back),
          caption: TextStyle(color: ThemeService.back),
          overline: TextStyle(color: ThemeService.back),
        ),
      ),
      textTheme: GoogleFonts.ubuntuTextTheme(
        TextTheme(
          headline1: TextStyle(color: ThemeService.text),
          headline2: TextStyle(color: ThemeService.text),
          headline3: TextStyle(color: ThemeService.text),
          headline4: TextStyle(color: ThemeService.text),
          headline5: TextStyle(color: ThemeService.text),
          headline6: TextStyle(color: ThemeService.text),
          subtitle1: TextStyle(color: ThemeService.text),
          subtitle2: TextStyle(color: ThemeService.textAlt),
          bodyText1: TextStyle(color: ThemeService.back),
          bodyText2: TextStyle(color: ThemeService.text),
          button: TextStyle(color: ThemeService.back),
          caption: TextStyle(color: ThemeService.text),
          overline: TextStyle(color: ThemeService.text),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ThemeService.accent,
        foregroundColor: ThemeService.back,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: ThemeService.accent, // Background color (orange in my case).
        textTheme: ButtonTextTheme.accent,
        colorScheme: Theme.of(context).colorScheme.copyWith(secondary: ThemeService.back)
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: TinyColor(ThemeService.accent).lighten(12).color),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ThemeService.accent),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: TinyColor(ThemeService.accent).lighten(12).color),
          )
      )
    );
  }

}