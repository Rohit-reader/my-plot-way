import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/property/property_list_screen.dart';
import 'screens/property/add_edit_property_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
  '/properties': (_) => const PropertyListScreen(),
  '/add_property': (_) => const AddEditPropertyScreen(),
};
