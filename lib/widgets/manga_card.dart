import 'package:flutter/material.dart';
import 'package:my_manga_h/theme.dart';

class MangaCard extends StatelessWidget {
  const MangaCard({super.key, required this.imagePath});
  final String imagePath;

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
                    border: Border.all(
                        color: Colors.black, width: 1), // Black border
                  ),
                  child: ClipRRect(
                    // Clip the image to the rounded rectangle
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
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
              'mangaTitle',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
