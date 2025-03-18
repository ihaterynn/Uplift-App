import 'package:flutter/material.dart';

/// A collection of reusable form widgets to be used across the app
class FormWidgets {
  
  /// Creates a standard section title with consistent styling
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Creates a standardized text form field with consistent styling
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    bool isRequired = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(label),
        TextFormField(
          controller: controller,
          decoration: inputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            contentPadding: maxLines > 1 
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
                : null,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator ?? (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  /// Creates a button with standard styling
  static Widget buildButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isPrimary = true,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF4ECDC4) : Colors.grey[200],
          foregroundColor: isPrimary ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: isPrimary ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  /// Creates a chip for skills or tags with consistent styling
  static Widget buildSkillChip({
    required String label,
    VoidCallback? onDelete,
    VoidCallback? onTap,
  }) {
    return Chip(
      label: Text(label),
      deleteIcon: onDelete != null ? const Icon(Icons.close, size: 16) : null,
      onDeleted: onDelete,
      backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
      labelStyle: const TextStyle(
        color: Color(0xFF4ECDC4),
      ),
    );
  }
  
  /// Creates a consistent input decoration for form fields
  static InputDecoration inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4ECDC4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
    );
  }
}