import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/ui/cubit/products_page_cubit.dart';
import 'package:inventory_management/ui/views/detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool isSearch = false;

  static const Color primaryBlue = Color(0xFF0B3C5D);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color pageBg = Color(0xFFF1F3F5);

  @override
  void initState() {
    super.initState();
    context.read<ProductsPageCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearch
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ürün ara",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (v) => context.read<ProductsPageCubit>().search(v),
              )
            : const Text("Ürünler", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              isSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => isSearch = !isSearch);
              if (!isSearch) {
                context.read<ProductsPageCubit>().loadProducts();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductsPageCubit, List<Products>>(
        builder: (context, list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                "Ürün Bulunamadı",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = list[i];

              return Card(
                color: cardBg,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailPage(product: p)),
                    ).then((_) {
                      context.read<ProductsPageCubit>().loadProducts();
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 96,
                        decoration: const BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Stok: ${p.stock}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Kategori: ${p.categoryName}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: primaryBlue,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Silme Onayı"),
                              content: const Text(
                                "Bu ürünü silmek istediğinize emin misiniz?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "İptal",
                                    style: TextStyle(color: primaryBlue),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                  ),
                                  onPressed: () {
                                    context.read<ProductsPageCubit>().delete(
                                      p.id,
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: primaryBlue,
                                        content: Text("Ürün silindi"),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sil",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
