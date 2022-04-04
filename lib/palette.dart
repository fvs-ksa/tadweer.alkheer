import 'package:flutter/material.dart'; 
class Palette { 
  static const MaterialColor kToDark = const MaterialColor( 
    0xff006400, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    const <int, Color>{ 
      50: const Color(0xff005a00),//10% 
      100: const Color(0xff005000),//20% 
      200: const Color(0xff004600),//30% 
      300: const Color(0xff003c00),//40% 
      400: const Color(0xff003200),//50% 
      500: const Color(0xff002800),//60% 
      600: const Color(0xff001e00),//70% 
      700: const Color(0xff001400),//80% 
      800: const Color(0xff000a00),//90% 
      900: const Color(0xff000000),//100% 
    }, 
  ); 
} 