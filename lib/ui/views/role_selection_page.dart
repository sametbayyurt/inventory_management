import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/repo/inventorydao_repository.dart';
import 'package:inventory_management/ui/cubit/add_product_page_cubit.dart';
import 'package:inventory_management/ui/cubit/qr_page_cubit.dart';
import 'package:inventory_management/ui/views/add_product_page.dart';
import 'package:inventory_management/ui/views/products_page.dart';
import 'package:inventory_management/ui/views/qr_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04),

                SizedBox(
                  width: size.width * 0.4,
                  child: Image.asset("images/logo.png"),
                ),

                SizedBox(height: size.height * 0.06),

                Row(
                  children: [
                    HomeCard(
                      title: "Ürün Listesi",
                      subtitle: "Ürünleri görüntüle",
                      icon: Icons.inventory_2_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProductsPage(),
                          ),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Ürün Ekle",
                      subtitle: "Yeni ürün oluştur",
                      icon: Icons.add_box_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) =>
                                  AddProductPageCubit()..loadCategory(),
                              child: const AddProductPage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.02),

                Row(
                  children: [
                    HomeCard(
                      title: "QR Tara",
                      subtitle: "Ürünün QR kodunu okut",
                      icon: Icons.qr_code_scanner_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) =>
                                  QrPageCubit(InventoryDaoRepository()),
                              child: const QrPage(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  static const Color corporateBlue = Color(0xFF265786);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Card(
          color: corporateBlue,
          elevation: 6,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: size.height * 0.065,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.008),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: size.width * 0.028,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
