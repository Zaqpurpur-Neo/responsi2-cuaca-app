import 'package:cuaca_app/widgets/weather_hero_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/weather_viewmodel.dart';

import '../widgets/info_tile.dart';
import '../widgets/daily_forecast_tile.dart';
import 'search_screen.dart'; // Akan dibuat di langkah 7

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => vm.refresh(),
            child: _buildBody(context, vm),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    // Handle state: loading, error, empty
    if (vm.state == ViewState.loading && vm.data == null) {
      return _buildLoading(context);
    }
    if (vm.state == ViewState.error && vm.data == null) {
      return _buildError(context, vm);
    }
    if (vm.state == ViewState.empty) {
      return _buildEmpty(context);
    }

    // State success (atau loading saat refresh dengan data lama tetap tampil)
    return _buildContent(context, vm);
  }

  // ==========================================
  // Konten Utama (Success)
  // ==========================================
  Widget _buildContent(BuildContext context, WeatherViewModel vm) {
    final data = vm.data!;
    final current = data.current;
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(), // Agar pull-to-refresh selalu aktif
      slivers: [
        // 1. SliverAppBar ala One UI: besar di atas, mengecil saat scroll
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          backgroundColor: colorScheme.surface,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            title: Text(
              vm.selectedLocation?.name ?? 'Cuaca',
              style: Theme.of(context).textTheme.headlineLarge
                  ?.copyWith(color: colorScheme.onSurface),
            ),
            centerTitle: false,
          ),
          actions: [
            // Tombol cari yang membuka SearchScreen
            IconButton(
              icon: const Icon(Icons.search),
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),

              // 2. Hero Card
              WeatherHeroCard(current: current),

              const SizedBox(height: 24),

              // 3. Baris Kartu Info Kecil
              Row(
                children: [
                  InfoTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Kelembapan',
                    value: '${current.humidity}%',
                  ),
                  const SizedBox(width: 12),
                  InfoTile(
                    icon: Icons.air,
                    label: 'Angin',
                    value: '${current.windSpeed.round()} km/h',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InfoTile(
                    icon: Icons.umbrella_outlined,
                    label: 'Curah Hujan',
                    value: '${current.precipitation} mm',
                  ),
                  const SizedBox(width: 12),
                  InfoTile(
                    icon: Icons.grain,
                    label: 'Peluang Hujan',
                    value: '${data.daily.first.precipitationProbabilityMax}%',
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 4. Judul Section Prakiraan 7 Hari
              Text(
                'Prakiraan 7 Hari',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // 5. List Prakiraan Harian
              ...data.daily.asMap().entries.map((entry) {
                return DailyForecastTile(
                  forecast: entry.value,
                  isToday: entry.key == 0,
                );
              }),

              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // State UI: Loading, Error, Empty
  // ==========================================
  Widget _buildLoading(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(BuildContext context, WeatherViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              vm.errorMessage ?? 'Gagal memuat data cuaca',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => vm.fetchWeather(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return const Center(child: Text('Tidak ada data cuaca.'));
  }
}

// Extension kecil agar bisa loop dengan index (seperti .asMap())
extension IterableExtension<T> on Iterable<T> {
  Iterable<MapEntry<int, T>> asMap() sync* {
    int i = 0;
    for (final element in this) {
      yield MapEntry(i++, element);
    }
  }
}
