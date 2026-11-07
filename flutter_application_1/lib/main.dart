import 'package:flutter/material.dart';

void main() {
  runApp(const MuseumApp());
}

class MuseumApp extends StatelessWidget {
  const MuseumApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF182534);

    return MaterialApp(
      title: 'Museos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MuseumCatalogPage(),
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
    imageUrl: 'https://images.unsplash.com/photo-1577083552431-6e5fd01aa342?auto=format&fit=crop&w=1000&q=85',
  ),
  Museum(
    name: 'Museo de Historia Natural Andina',
    description: 'Especímenes de fauna, flora y geología de la región andina, organizados para consulta del público y de investigadores.',
    coordinates: '6.2518, -75.5636',
    website: 'https://historianatural.example',
    imageUrl: 'https://images.unsplash.com/photo-1565060169194-19fabf63012d?auto=format&fit=crop&w=1000&q=85',
  ),
  Museum(
    name: 'Museo Arqueológico del Altiplano',
    description: 'Piezas arqueológicas de cerámica, orfebrería y piedra, conservadas como patrimonio de las culturas del altiplano.',
    coordinates: '5.0701, -75.5318',
    website: 'https://arqueologico.example',
    imageUrl: 'https://images.unsplash.com/photo-1561214115-f2f134cc4912?auto=format&fit=crop&w=1000&q=85',
  ),
  Museum(
    name: 'Casa Museo del Patrimonio Local',
    description: 'Casa histórica con objetos de la vida cotidiana, documentos y fotografías de la comunidad.',
    coordinates: '3.4516, -76.5320',
    website: 'https://casamuseo.example',
    imageUrl: 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?auto=format&fit=crop&w=1000&q=85',
  ),
];

class MuseumCatalogPage extends StatefulWidget {
  const MuseumCatalogPage({super.key});

  @override
  State<MuseumCatalogPage> createState() => _MuseumCatalogPageState();
}

class _MuseumCatalogPageState extends State<MuseumCatalogPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final visibleMuseums = museums
        .where((museum) => museum.name.toLowerCase().contains(_query))
        .toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 58,
        backgroundColor: const Color(0xFF182534),
        foregroundColor: Colors.white,
        titleSpacing: 24,
        title: const Row(
          children: [
            Icon(Icons.account_balance_outlined, size: 19),
            SizedBox(width: 10),
            Text(
              'Sistema de Administración de Museos',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth < 600 ? 20.0 : 36.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              30,
              horizontalPadding,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Museos',
                      style: TextStyle(
                        color: Color(0xFF202833),
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Inventario de museos registrados en el sistema.',
                      style: TextStyle(color: Color(0xFF7C858D), fontSize: 14),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: 470,
                      child: TextField(
                        key: const ValueKey('museum-search'),
                        onChanged: (value) {
                          setState(() => _query = value.trim().toLowerCase());
                        },
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre',
                          hintStyle: const TextStyle(
                            color: Color(0xFF858D95),
                            fontSize: 13,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF87919A),
                            size: 20,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E6E9),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E6E9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              color: Color(0xFF526879),
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (visibleMuseums.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(
                          child: Text(
                            'No se encontraron museos.',
                            style: TextStyle(color: Color(0xFF727C85)),
                          ),
                        ),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, gridConstraints) {
                          final columns = gridConstraints.maxWidth >= 680
                              ? 2
                              : 1;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: visibleMuseums.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 22,
                                  mainAxisSpacing: 22,
                                  mainAxisExtent: 390,
                                ),
                            itemBuilder: (context, index) =>
                                MuseumCard(museum: visibleMuseums[index]),
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
      bottomNavigationBar: const MuseumBottomBar(),
    );
  }
}

class MuseumCard extends StatelessWidget {
  const MuseumCard({super.key, required this.museum});

  final Museum museum;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0x18000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Image.network(
              museum.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const ColoredBox(
                color: Color(0xFFE6EAEC),
                child: Center(
                  child: Icon(
                    Icons.museum_outlined,
                    color: Color(0xFF8C969D),
                    size: 44,
                  ),
                ),
              ),
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
                    style: const TextStyle(
                      color: Color(0xFF29323B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    museum.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF7B848C),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: Color(0xFF82909A),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        museum.coordinates,
                        style: const TextStyle(
                          color: Color(0xFF737D86),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Text(
                        'Sitio web:',
                        style: TextStyle(
                          color: Color(0xFF7B848C),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          museum.website,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF52748D),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.open_in_new,
                        size: 13,
                        color: Color(0xFF52748D),
                      ),
                    ],
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

class MuseumBottomBar extends StatelessWidget {
  const MuseumBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF182534),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _BottomBarButton(
                label: 'Información',
                icon: Icons.info_outline,
                onPressed: () => _showMessage(context, 'Catálogo de museos'),
              ),
              const SizedBox(width: 34),
              _BottomBarButton(
                label: 'Escanear',
                icon: Icons.qr_code_scanner,
                onPressed: () => _showMessage(context, 'Escáner de museos'),
              ),
              const SizedBox(width: 34),
              _BottomBarButton(
                label: 'Cámara',
                icon: Icons.photo_camera_outlined,
                onPressed: () => _showMessage(context, 'Cámara de museos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BottomBarButton extends StatelessWidget {
  const _BottomBarButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      color: Colors.white,
      icon: Icon(icon, size: 25),
    );
  }
}
