import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/ui/cubit/qrPageCubit.dart';
import 'package:inventory_management/ui/views/detailPage.dart';
import 'package:inventory_management/ui/views/qrState.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  bool showScanner = false;
  bool isScanned = false;

  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrPageCubit, QrState>(
      listener: (context, state) {
        if (state is QrSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(product: state.product),
            ),
          );
        }
        if (state is QrError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          setState(() {
            showScanner = false;
            isScanned = false;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("QR Tara"),
          centerTitle: true,
        ),
        body: showScanner ? _scannerView() : _introView(),
      ),
    );
  }
  Widget _introView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  size: 90,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  "QR Kod Okut",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Ürünün QR kodunu kameraya göstererek\nhızlıca detaylarını görüntüleyebilirsin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt,color: Colors.blueAccent,),
                    label: const Text("QR Okut",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showScanner = true;
                        isScanned = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _scannerView() {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          onDetect: (capture) {
            if (isScanned) return;

            final String? code =
                capture.barcodes.first.rawValue;

            if (code != null) {
              isScanned = true;
              controller.stop();

              context
                  .read<QrPageCubit>()
                  .getProductById(int.parse(code));
            }
          },
        ),
        Center(
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.greenAccent,
                width: 3,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                controller.stop();
                setState(() {
                  showScanner = false;
                  isScanned = false;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 24,
          child: FloatingActionButton(
            heroTag: "flash",
            backgroundColor: Colors.black87,
            child: const Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleTorch();
            },
          ),
        ),
        Positioned(
          bottom: 90,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "QR kodu çerçevenin içine hizala",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}