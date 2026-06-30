import 'package:flutter/material.dart';

IconData materialIconFromCodePoint(
  int? codePoint, {
  IconData fallback = Icons.topic_rounded,
}) {
  switch (codePoint) {
    case 0xf5cc:
      return Icons.book_rounded;
    case 0xf650:
      return Icons.cloud_rounded;
    case 0xf772:
      return Icons.flight_rounded;
    case 0xf8b4:
      return Icons.menu_book_rounded;
    case 0xf8e7:
      return Icons.movie_rounded;
    case 0xf8ed:
      return Icons.music_note_rounded;
    case 0xf0077:
      return Icons.pets_rounded;
    case 0xf0108:
      return Icons.restaurant_rounded;
    case 0xf012e:
      return Icons.school_rounded;
    case 0xf01bc:
      return Icons.sports_esports_rounded;
    case 0xf01c7:
      return Icons.sports_soccer_rounded;
    case 0xf0244:
      return Icons.topic_rounded;
    default:
      return fallback;
  }
}
