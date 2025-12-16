import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management/ui/cubit/addProductPageCubit.dart';
import 'package:inventory_management/ui/cubit/detailPageCubit.dart';
import 'package:inventory_management/ui/cubit/productsPageCubit.dart';
import 'package:inventory_management/ui/cubit/updatePageCubit.dart';
import 'package:inventory_management/ui/views/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AddProductPageCubit()),
        BlocProvider(create: (context) => ProductsPageCubit()),
        BlocProvider(create: (context) => DetailPageCubit()),
        BlocProvider(create: (context) => UpdatePageCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomePage(),
      ),
    );
  }
}