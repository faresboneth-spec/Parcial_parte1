import 'package:flutter/material.dart';

void main() {
  runApp(const MuseumCatalogApp());
}

class MuseumCatalogApp extends StatelessWidget {
  const MuseumCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF202A30);
    const accent = Color(0xFF5C8490);

    return MaterialApp(
      title: 'Museos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          primary: accent,
          surface: const Color(0xFFF5F6F5),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: ink,
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.1,
          ),
          titleMedium: TextStyle(
            color: ink,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF788187),
            fontSize: 13,
            height: 1.55,
          ),
        ),
      ),
      home: const MuseumsPage(),
    );
  }
}

class Museum {
  const Museum({
    required this.name,
    required this.description,
    required this.coordinates,
    required this.website,
    required this.imageUrl,
  });

  final String name;
  final String description;
  final String coordinates;
  final String website;
  final String imageUrl;
}

const museums = [
  Museum(
    name: 'Museo de Arte del Río',
    description: 'Colección de pintura y escultura moderna, con salas dedicadas al arte del siglo XX y a exposiciones temporales.',
    coordinates: '4.5981, -74.0760',
    website: 'https://museodelrio.example',
    imageUrl: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1200&q=85',
  ),
  Museum(
    name: 'Museo de Historia Natural Andina',
    description: 'Especímenes de fauna, flora y geología de la región andina, organizados para consulta del público y de investigadores.',
    coordinates: '6.2518, -75.5636',
    website: 'https://historianatural.example',
    imageUrl: 'https://images.unsplash.com/photo-1577083552431-6e5fd01aa342?auto=format&fit=crop&w=1200&q=85',
  ),
  Museum(
    name: 'Museo Arqueológico del Altiplano',
    description: 'Piezas arqueológicas de cerámica, orfebrería y piedra, conservadas como patrimonio de las culturas del altiplano.',
    coordinates: '5.0701, -75.5318',
    website: 'https://arqueologico.example',
    imageUrl: 'https://images.unsplash.com/photo-1572947650440-e8a97ef053b2?auto=format&fit=crop&w=1200&q=85',
  ),
  Museum(
    name: 'Casa Museo del Patrimonio Local',
    description: 'Casa histórica con objetos de la vida cotidiana, documentos y fotografías de la comunidad.',
    coordinates: '3.4516, -76.5320',
    website: 'https://casamuseo.example',
    imageUrl: 'https://www.istockphoto.com/es/foto/pura-ulun-templo-de-danu-bratan-en-bali-gm675172642-123800549',
  ),
];

class MuseumsPage extends StatefulWidget {
  const MuseumsPage({super.key});

  @override
  State<MuseumsPage> createState() => _MuseumsPageState();
}

class _MuseumsPageState extends State<MuseumsPage> {
  final _searchController = TextEditingController();
  String _query = '';

  List<Museum> get _filteredMuseums {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return museums;

    return museums.where((museum) {
      return museum.name.toLowerCase().contains(query) ||
          museum.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = constraints.maxWidth < 600
                    ? 20.0
                    : 36.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    36,
                    horizontalPadding,
                    48,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Museos',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Inventario de museos registrados en el sistema.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 22),
                          _SearchField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _query = value),
                            onClear: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, gridConstraints) {
                              final columns = gridConstraints.maxWidth >= 680
                                  ? 2
                                  : 1;
                              final spacing = 20.0;
                              final itemWidth =
                                  (gridConstraints.maxWidth -
                                      spacing * (columns - 1)) /
                                  columns;
                              final imageHeight = (itemWidth * .56).clamp(
                                190.0,
                                260.0,
                              );
                              final cardHeight = imageHeight + 192;

                              if (_filteredMuseums.isEmpty) {
                                return const _EmptySearchResult();
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _filteredMuseums.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: columns,
                                      crossAxisSpacing: spacing,
                                      mainAxisSpacing: spacing,
                                      mainAxisExtent: cardHeight,
                                    ),
                                itemBuilder: (context, index) => MuseumCard(
                                  museum: _filteredMuseums[index],
                                  imageHeight: imageHeight,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
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

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        return Container(
          height: 62,
          color: const Color(0xFF202A30),
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance_outlined,
                      color: Color(0xFFDCE4E5),
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Text(
                      'Sistema de Administración de Museos',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFFE6EAEB),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .1,
                      ),
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.circle, color: Color(0xFF87AB9A), size: 7),
                    const SizedBox(width: 8),
                    const Text(
                      'Catálogo',
                      style: TextStyle(color: Color(0xFFB8C2C5), fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: SizedBox(
        height: 48,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Buscar por nombre',
            hintStyle: const TextStyle(color: Color(0xFF9AA2A5), fontSize: 13),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF899296),
              size: 19,
            ),
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Limpiar búsqueda',
                    onPressed: onClear,
                    icon: const Icon(Icons.close, size: 18),
                  ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFE7EAEA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFFE7EAEA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Color(0xFF8DA8AD)),
            ),
          ),
        ),
      ),
    );
  }
}

class MuseumCard extends StatelessWidget {
  const MuseumCard({
    super.key,
    required this.museum,
    required this.imageHeight,
  });

  final Museum museum;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EAEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B263238),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: imageHeight,
            child: Image.network(
              museum.imageUrl,
              fit: BoxFit.cover,
              semanticLabel: museum.name,
              errorBuilder: (context, error, stackTrace) =>
                  const _ImageFallback(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(17, 15, 17, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    museum.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontSize: 15, letterSpacing: -.15),
                  ),
                  const SizedBox(height: 7),
                  Expanded(
                    child: Text(
                      museum.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 12, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _MetadataRow(
                    icon: Icons.location_on_outlined,
                    text: museum.coordinates,
                  ),
                  const SizedBox(height: 7),
                  _MetadataRow(
                    icon: Icons.open_in_new,
                    text: museum.website,
                    isLink: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.text,
    this.isLink = false,
  });

  final IconData icon;
  final String text;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    final color = isLink ? const Color(0xFF628997) : const Color(0xFF778287);

    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 10.5),
          ),
        ),
      ],
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3E7E5),
      alignment: Alignment.center,
      child: const Icon(
        Icons.museum_outlined,
        color: Color(0xFF9AA9A5),
        size: 42,
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 52, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EAEA)),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, color: Color(0xFF9AA5A7), size: 30),
          SizedBox(height: 12),
          Text(
            'No encontramos museos con ese nombre.',
            style: TextStyle(
              color: Color(0xFF687478),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Prueba con otra búsqueda.',
            style: TextStyle(color: Color(0xFF929B9E), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
