import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:othello/controllers/user_profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

class UserProfilePage extends GetView<UserProfileController> {
  UserProfilePage({super.key});
  final UserProfileController userController =
      Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "User Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person, size: 100, color: Colors.white70),
            const SizedBox(height: 20),

            TextField(
              controller: controller.usernameCtrl,
              onChanged: (val) => controller.username.value = val,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Username'),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildDropdown(
                'Gender',
                controller.gender.value,
                ['Male', 'Female', 'Other'],
                (val) => controller.gender.value = val ?? '',
              ),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildDatePicker(
                'Date of Birth',
                context,
                controller.birthDate.value,
                (date) => controller.birthDate.value = date,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: controller.cityCtrl,
              onChanged: (val) => controller.city.value = val,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('City'),
            ),
            const SizedBox(height: 20),

            Obx(
              () => _buildCountryPicker(
                'Country',
                controller.country.value,
                (country) => controller.country.value = country.name,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: controller.emailCtrl,
              onChanged: (val) => controller.email.value = val,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 20),

            Obx(
              () => TextField(
                controller: controller.passwordCtrl,
                onChanged: (val) => controller.password.value = val,
                obscureText: controller.obscurePassword.value,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed:
                        () =>
                            controller.obscurePassword.value =
                                !controller.obscurePassword.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: controller.saveProfile,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.black54,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      onChanged: onChanged,
      dropdownColor: Colors.black,
      items:
          items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
      decoration: _inputDecoration(label),
    );
  }

  Widget _buildDatePicker(
    String label,
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: _inputDecoration(label),
        child: Text(
          DateFormat('yyyy-MM-dd').format(selectedDate),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCountryPicker(
    String label,
    String selectedCountry,
    Function(Country) onCountrySelected,
  ) {
    return GestureDetector(
      onTap: () {
        showCountryPicker(context: Get.context!, onSelect: onCountrySelected);
      },
      child: InputDecorator(
        decoration: _inputDecoration(label),
        child: Text(
          selectedCountry.isEmpty ? 'Select Country' : selectedCountry,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
