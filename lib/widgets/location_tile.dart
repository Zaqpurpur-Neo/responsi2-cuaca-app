import 'package:flutter/material.dart';

import '../models/location.dart';

class LocationTile extends StatelessWidget {
  final Location location;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final bool showFavoriteButton;

  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Susun teks lokasi: "Nama Kota" + "Provinsi, Negara" (jika ada)
    String subtitle = '';
    if (location.admin1 != null && location.admin1!.isNotEmpty) {
      subtitle = '${location.admin1}, ${location.country}';
    } else {
      subtitle = location.country;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Ikon lokasi di kiri
              Icon(
                Icons.location_on_outlined,
                color: colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 16),
              // Teks nama kota & subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              // Tombol bintang untuk favorit
              if (showFavoriteButton)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                  onPressed: onToggleFavorite,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
