import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:security/controllers/profile_controller.dart';
import 'package:security/widgets/nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    return Scaffold(
      backgroundColor: const Color(0xFFFCEACD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20.sp, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            // Profile Picture
            Padding(
              padding: EdgeInsets.all(5.h),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    return CircleAvatar(
                      radius: 10.h,
                      backgroundColor: const Color(0xFFDCC7FF),
                      backgroundImage: controller.profilePictureUrl.value != ''
                          ? FileImage(File(controller.profilePictureUrl.value))
                          : null,
                      child: controller.profilePictureUrl.value == ''
                          ? Icon(Icons.person, size: 10.h, color: Colors.white)
                          : null,
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                    onPressed: controller.pickProfilePicture,
                  ),
                ],
              ),
            ),

            // Name Field
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Obx(() {
                final nameController =
                    TextEditingController(text: controller.name.value)
                      ..selection = TextSelection.collapsed(
                          offset: controller.name.value.length);
                return TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    controller.name.value = value;
                  },
                  onSubmitted: (value) {
                    controller.updateName(value);
                  },
                );
              }),
            ),

            // Email Field
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Obx(() => TextField(
                    enabled: false,
                    controller:
                        TextEditingController(text: controller.email.value),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
            ),

            // Phone Number Field
            Padding(
              padding: EdgeInsets.all(2.h),
              child: Obx(() {
                final phoneController =
                    TextEditingController(text: controller.phoneNumber.value)
                      ..selection = TextSelection.collapsed(
                          offset: controller.phoneNumber.value.length);
                return TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone No.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    controller.phoneNumber.value = value;
                  },
                  onSubmitted: (value) {
                    controller.updatePhoneNumber(value);
                  },
                );
              }),
            ),

            SizedBox(height: 3.h),

            // Logout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/login');
              },
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
