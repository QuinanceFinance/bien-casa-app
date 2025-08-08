import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller that was injected by the binding
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BienCasa',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example of using Obx for reactive UI updates
            Obx(
              () => Text(
                'Welcome ${controller.username.value}',
                style: const TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 20),

            // Example of using Obx to reactively update counter
            Obx(
              () => Text(
                'Counter: ${controller.count.value}',
                style: const TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: controller.increment,
              child: const Text('Increment'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                controller.updateUsername('BienCasa User');
                Get.snackbar(
                  'Updated',
                  'Username updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Update Username'),
            ),

            const SizedBox(height: 20),

            // Example of conditional UI with Obx
            Obx(
              () =>
                  controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () {
                          controller.toggleLoading();
                          Future.delayed(const Duration(seconds: 2), () {
                            controller.toggleLoading();
                            Get.snackbar(
                              'Done',
                              'Loading complete!',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          });
                        },
                        child: const Text('Show Loading'),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
