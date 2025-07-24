import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda Calendar')),
      body: Center(
        child: Obx(() {
          return controller.isSignedIn.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hello, ${controller.currentUser?.displayName}'),
                    ElevatedButton(
                      onPressed: controller.handleSignOut,
                      child: const Text('Sign Out'),
                    ),
                  ],
                )
              : ElevatedButton(
                  onPressed: controller.handleSignIn,
                  child: const Text('Sign in with Google'),
                );
        }),
      ),
    );
  }
}
