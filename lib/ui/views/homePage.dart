import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/ui/cubit/addProductPageCubit.dart';
import 'package:inventory_management/ui/views/addProductPage.dart';
import 'package:inventory_management/ui/views/productsPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenSize.height * 0.05),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: screenSize.height * 0.05,
                  bottom: screenSize.height * 0.04,
                ),
                child: SizedBox(
                  width: screenSize.width * 0.35,
                  child: Image.asset("images/logo.png"),
                ),
              ),
              Row(
                children: [
                  HomeCard(
                    title: "Ürün Listesi",
                    subtitle: "Kayıtlı ürünleri görüntüle",
                    imageName: "box.png",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsPage()));
                    },
                  ),
                  HomeCard(
                    title: "Ürün Ekle",
                    subtitle: "Yeni ürün oluştur",
                    imageName: "add.png",
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
              Row(
                children: [
                  HomeCard(
                    title: "QR Tara",
                    subtitle: "Ürünün QR kodunu okut",
                    imageName: "qrscan.png",
                    onTap: () {
                    },
                  ),
                  HomeCard(
                    title: "Ayarlar",
                    subtitle: "Uygulama ayarları",
                    imageName: "settings.png",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageName;
  final VoidCallback onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Column(
              children: [
                Image.asset(
                  "images/$imageName",
                  height: size.height * 0.15,
                ),
                SizedBox(height: size.height * 0.015),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.005),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: size.width * 0.025,
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