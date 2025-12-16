import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/data/entity/products.dart';
import 'package:inventory_management/ui/cubit/detailPageCubit.dart';
import 'package:inventory_management/ui/views/updatePage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailPage extends StatefulWidget {
  Products product;

  DetailPage({required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detay"),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ürün Adı : ${widget.product.name}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Stok : ${widget.product.stock}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                "Kategori : ${widget.product.categoryName}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 20),
              Center(
                child: QrImageView(
                  data: widget.product.id.toString(),
                  size: 180,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  "Ürün Kodu: ${widget.product.id}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit,color: Colors.white,),
                      label: Text("Güncelle",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(product: widget.product,)));
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.delete,color: Colors.white,),
                      label: Text("Sil",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
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
                                  context.read<DetailPageCubit>().delete(widget.product.id);
                                  Navigator.pop(context);
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
                    ),
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