import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/ui/cubit/addProductPageCubit.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  var tfUrunAdi = TextEditingController();
  var tfStock = TextEditingController();

  Categories? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Ekle", style: TextStyle(fontFamily: "Lexend"),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              SizedBox(height: 30),
              TextField(
                controller: tfUrunAdi,
                decoration: InputDecoration(hintText: "Ürün Adı",border: OutlineInputBorder()),),
              SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: tfStock,
                decoration: InputDecoration(hintText: "Stok",border: OutlineInputBorder()),),
              SizedBox(height: 30),
              BlocBuilder<AddProductPageCubit, List<Categories>>(
                builder: (context, categoryList) {
                  if (categoryList.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<Categories>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      hintText: "Kategori",
                      border: OutlineInputBorder(),
                    ),
                    items: categoryList.map((category) {
                      return DropdownMenuItem<Categories>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(onPressed: () {
                context.read<AddProductPageCubit>().save(tfUrunAdi.text, int.parse(tfStock.text), selectedCategory!.id);
                setState(() {
                  tfUrunAdi.text = "";
                  tfStock.text = "";
                  selectedCategory = null;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Ürün eklendi"),
                      backgroundColor: Colors.black87,
                    ),
                  );
                });
              }, child: Text("KAYDET")),
            ],
          ),
        ),
      ),
    );
  }
}