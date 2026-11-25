import 'package:flutter/material.dart';

void main() {
  runApp(const KosFinderApp());
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KosListPage(),
    );
  }
}

class Kos {
  const Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.monthlyPrice,
  });

  final String id;
  final String name;
  final String location;
  final String monthlyPrice;
}

const List<Kos> sampleKosList = [
  Kos(
    id: 'kos-melati',
    name: 'Kos Melati',
    location: 'Jl. Merdeka, Bandung',
    monthlyPrice: 'Rp1.200.000',
  ),
  Kos(
    id: 'kos-anggrek',
    name: 'Kos Anggrek',
    location: 'Jl. Diponegoro, Yogyakarta',
    monthlyPrice: 'Rp950.000',
  ),
  Kos(
    id: 'kos-kenanga',
    name: 'Kos Kenanga',
    location: 'Jl. Sudirman, Jakarta',
    monthlyPrice: 'Rp1.800.000',
  ),
  Kos(
    id: 'kos-mawar',
    name: 'Kos Mawar',
    location: 'Jl. Gajah Mada, Surabaya',
    monthlyPrice: 'Rp1.100.000',
  ),
  Kos(
    id: 'kos-flamboyan',
    name: 'Kos Flamboyan',
    location: 'Jl. Siliwangi, Semarang',
    monthlyPrice: 'Rp850.000',
  ),
  Kos(
    id: 'kos-cempaka',
    name: 'Kos Cempaka',
    location: 'Jl. Dipatiukur, Bandung',
    monthlyPrice: 'Rp1.500.000',
  ),
];

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _favoriteKosIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  List<Kos> get _filteredKos {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return sampleKosList;
    }

    return sampleKosList
        .where((kos) => kos.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredKos = _filteredKos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KosFinder Mini'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration:
                  const InputDecoration(
                    labelText: 'Cari nama kos',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ).copyWith(
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear),
                          ),
                  ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredKos.isEmpty
                ? const Center(child: Text('Kos tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredKos.length,
                    itemBuilder: (context, index) {
                      final kos = filteredKos[index];
                      final isFavorite = _favoriteKosIds.contains(kos.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      kos.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: isFavorite
                                        ? 'Hapus dari favorit'
                                        : 'Tambahkan ke favorit',
                                    onPressed: () {
                                      setState(() {
                                        if (isFavorite) {
                                          _favoriteKosIds.remove(kos.id);
                                        } else {
                                          _favoriteKosIds.add(kos.id);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(kos.location),
                              const SizedBox(height: 8),
                              Text(
                                '${kos.monthlyPrice} / bulan',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
