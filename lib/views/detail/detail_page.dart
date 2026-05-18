import 'package:flutter/material.dart';
import 'widgets/banner.dart';
import 'widgets/trailer_button.dart';
import 'widgets/rating_display.dart';
import 'widgets/category_chip.dart';

class DetailPage extends StatelessWidget {
  final String filmId;

  const DetailPage({Key? key, required this.filmId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BannerWidget(filmId: filmId),
            const SizedBox(height: 16),
            TrailerButton(filmId: filmId),
            const SizedBox(height: 16),
            RatingDisplay(rating: 8.5),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                CategoryChip(label: "Action"),
                CategoryChip(label: "Drama"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
