import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFlatmatePage extends StatelessWidget {
  const AddFlatmatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Flatmate',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'ProductSans',
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text(
          'Add Flatmate Form Coming Soon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'ProductSans',
          ),
        ),
      ),
    );
  }
}
