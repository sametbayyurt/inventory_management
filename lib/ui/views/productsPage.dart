import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/ui/cubit/productsPageCubit.dart';
import 'package:inventory_management/ui/views/detailPage.dart';

class ProductsPage extends StatefulWidget {

  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsGageState();
}

class _ProductsGageState extends State<ProductsPage> {

  bool search = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductsPageCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: search ? TextField(
          decoration: const InputDecoration(hintText: "Ara"),
          onChanged: (searchResult) {
            context.read<ProductsPageCubit>().search(searchResult);
          },
        ) : const Text("Ürünler"),
        actions: [
          search ?
          IconButton(onPressed: () {
            setState(() {
              search = false;
            });
            context.read<ProductsPageCubit>().loadProducts();
          }, icon: Icon(Icons.clear)) :
          IconButton(onPressed: () {
            setState(() {
              search = true;
            });
          }, icon: Icon(Icons.search)),
        ],
      ),
      body: BlocBuilder<ProductsPageCubit, List<Products>>(
        builder: (context, productsList) {
          if (productsList.isNotEmpty) {
            return ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, i) {
                var product = productsList[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(product: product))).
                    then((value){
                      context.read<ProductsPageCubit>().loadProducts();
                    })
                    ;
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ürün Adı : ${product.name}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text("Stok : ${product.stock.toString()}"),
                                Text("Kategori : ${product.categoryName}"),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Silme Onayı"),
                                content: Text("Bu ürünü silmek istediğinize emin misiniz?"),
                                actions: [
                                  TextButton(
                                    child: Text("İptal",style: TextStyle(color: Colors.black),),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text("Sil",style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      context.read<ProductsPageCubit>().delete(product.id);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Ürün silindi"),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                            icon: const Icon(Icons.delete, color: Colors.black54,),)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Ürün bulunamadı"),
            );
          }
        },
      ),
    );
  }
}