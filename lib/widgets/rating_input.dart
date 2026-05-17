import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(double) onRatingChanged;

  const RatingInput({
    super.key,
    required this.controller,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⭐ Rating Film',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0 - 10',
                  prefixIcon: const Icon(Icons.star, color: Colors.amber),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating harus diisi';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null) {
                    return 'Masukkan angka yang valid';
                  }
                  if (rating < 0 || rating > 10) {
                    return 'Rating harus antara 0 - 10';
                  }
                  return null;
                },
                onChanged: (value) {
                  final rating = double.tryParse(value);
                  if (rating != null) {
                    onRatingChanged(rating);
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            // Live star preview
            Expanded(
              flex: 1,
              child: Obx(() {
                final ratingValue = double.tryParse(controller.text) ?? 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starValue = index + 1;
                    if (ratingValue >= starValue * 2) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                      );
                    } else if (ratingValue >= (starValue * 2) - 1) {
                      return const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 28,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      );
                    }
                  }),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
