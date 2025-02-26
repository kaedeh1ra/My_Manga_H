import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_manga_h/manga_data.dart';
import 'package:my_manga_h/theme.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.manga});
  final MangaData manga;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                // Background (Purple rounded rectangle)
                Container(
                  width: 150,
                  height: 210,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.black, width: 1), // Black border
                  ),
                ),

                // Foreground (White rounded rectangle with image)
                Container(
                  width: 130, // Slightly smaller than the background
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(manga.pagePaths.first),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              manga.title,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
