import 'package:cuaca_app/models/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/weather_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/location_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Fokus otomatis ke TextField saat layar dibuka
    _focusNode.requestFocus();
    // Listener untuk memicu pencarian setiap kali teks berubah
    _controller.addListener(() {
      context.read<SearchViewModel>().search(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih lokasi: simpan ke riwayat, update ViewModel cuaca, lalu kembali
  void _selectLocation(Location location) {
    final weatherVm = context.read<WeatherViewModel>();
    final searchVm = context.read<SearchViewModel>();

    searchVm.addToHistory(location);
    weatherVm.selectLocation(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Kota')),
      body: Column(
        children: [
          // 1. Search bar berbentuk pil
          _buildSearchBar(context),
          const SizedBox(height: 16),
          // 2. Konten dinamis: favorit/riwayat atau hasil pencarian
          Expanded(
            child: Consumer<SearchViewModel>(
              builder: (context, vm, child) {
                final query = _controller.text.trim();
                if (query.isEmpty) {
                  return _buildFavoritesAndHistory(context, vm);
                } else {
                  return _buildSearchResults(context, vm);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Search Bar Pil
  // ==========================================
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Cari kota...',
          prefixIcon: const Icon(Icons.search),
          // Tombol hapus teks hanya muncul jika ada input
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _controller.clear();
                    context.read<SearchViewModel>().search('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  // ==========================================
  // Tampilan Favorit & Riwayat (saat input kosong)
  // ==========================================
  Widget _buildFavoritesAndHistory(BuildContext context, SearchViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasFavorites = vm.favorites.isNotEmpty;
    final hasHistory = vm.history.isNotEmpty;

    // Jika keduanya kosong, tampilkan pesan kosong
    if (!hasFavorites && !hasHistory) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada favorit atau riwayat pencarian',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // Section Favorit
        if (hasFavorites) ...[
          Text('Favorit', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          ...vm.favorites.map(
            (loc) => LocationTile(
              location: loc,
              isFavorite: true,
              onTap: () => _selectLocation(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
          ),
          const SizedBox(height: 24),
        ],
        // Section Riwayat
        if (hasHistory) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Pencarian',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => vm.clearHistory(),
                child: const Text('Hapus semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...vm.history.map(
            (loc) => LocationTile(
              location: loc,
              isFavorite: vm.isFavorite(loc),
              onTap: () => _selectLocation(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
          ),
        ],
      ],
    );
  }

  // ==========================================
  // Tampilan Hasil Pencarian (saat input terisi)
  // ==========================================
  Widget _buildSearchResults(BuildContext context, SearchViewModel vm) {
    final colorScheme = Theme.of(context).colorScheme;

    // Loading
    if (vm.state == SearchState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (vm.state == SearchState.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cloud_off, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Gagal mencari lokasi. Periksa koneksi Anda.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty (kota tidak ditemukan)
    if (vm.state == SearchState.empty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Kota tidak ditemukan',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    // Success: tampilkan hasil
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: vm.results.length,
      itemBuilder: (context, index) {
        final loc = vm.results[index];
        return LocationTile(
          location: loc,
          isFavorite: vm.isFavorite(loc),
          onTap: () => _selectLocation(loc),
          onToggleFavorite: () => vm.toggleFavorite(loc),
        );
      },
    );
  }
}
