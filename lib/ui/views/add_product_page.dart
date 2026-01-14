import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/categories.dart';
import 'package:inventory_management/ui/cubit/add_product_page_cubit.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  static const Color primaryBlue = Color(0xFF0B3C5D);
  static const Color pageBg = Color(0xFFF1F3F5);
  static const Color white = Colors.white;

  final TextEditingController tfName = TextEditingController();
  final TextEditingController tfStock = TextEditingController();

  Categories? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Ürün Ekle", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: tfName,
                  textCapitalization: TextCapitalization.words,
                  decoration: _decoration("Ürün Adı"),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: tfStock,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: _decoration("Stok"),
                ),

                const SizedBox(height: 20),

                BlocBuilder<AddProductPageCubit, List<Categories>>(
                  builder: (context, list) {
                    if (list.isEmpty) {
                      return const CircularProgressIndicator();
                    }

                    return DropdownButtonFormField<Categories>(
                      value: selectedCategory,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      decoration: _decoration("Kategori"),
                      dropdownColor: white,
                      items: list.map((c) {
                        return DropdownMenuItem<Categories>(
                          value: c,
                          child: Text(
                            c.name,
                            style: const TextStyle(color: Colors.black),
                          ),
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

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.read<AddProductPageCubit>().save(
                        tfName.text,
                        int.parse(tfStock.text),
                        selectedCategory!.id,
                      );

                      tfName.clear();
                      tfStock.clear();
                      setState(() => selectedCategory = null);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: primaryBlue,
                          content: Text("Ürün eklendi"),
                        ),
                      );
                    },
                    child: const Text(
                      "KAYDET",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),

      filled: true,
      fillColor: white,

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
    );
  }
}
