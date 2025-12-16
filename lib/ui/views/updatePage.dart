import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/ui/cubit/updatePageCubit.dart';

class UpdatePage extends StatefulWidget {
Products product;

UpdatePage({required this.product});

@override
State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  final tfName = TextEditingController();
  final tfStock = TextEditingController();

  Categories? selectedCategory;
  List<Categories> categoryList = [];

  @override
  void initState() {
    super.initState();

    tfName.text = widget.product.name;
    tfStock.text = widget.product.stock.toString();

    context.read<UpdatePageCubit>().loadCategories().then((list) {
      setState(() {
        categoryList = list;
        selectedCategory = categoryList.firstWhere(
              (c) => c.id == widget.product.categoryId,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ürün Güncelle")),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            TextField(
              controller: tfName,
              decoration: const InputDecoration(
                labelText: "Ürün Adı",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: tfStock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Stok",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<Categories>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(),
              ),
              items: categoryList.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.read<UpdatePageCubit>().update(
                  widget.product.id,
                  tfName.text,
                  int.parse(tfStock.text),
                  selectedCategory!.id,
                );
                Navigator.pop(context, true);
                Navigator.pop(context, true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ürün güncellendi")),
                );
              },
              child: const Text("GÜNCELLE"),
            ),
          ],
        ),
      ),
    );
  }
}