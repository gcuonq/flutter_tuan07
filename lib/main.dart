import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/product_list_page.dart';
import '../screens/product_detail_page.dart';
import '../screens/product_create_page.dart';
import '../screens/product_update_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const ProductListPage());

          case '/detail':
            final args = settings.arguments;
            if (args is int) {
              return MaterialPageRoute(
                builder: (_) => ProductDetailPage(productId: args),
              );
            }
            return _errorRoute('Invalid or missing product ID for /detail');

          case '/create':
            return MaterialPageRoute(builder: (_) => const ProductCreatePage());

          case '/update':
            final args = settings.arguments;
            if (args is int) {
              return MaterialPageRoute(
                builder: (_) => ProductUpdatePage(productId: args),
              );
            }
            return _errorRoute('Invalid or missing product ID for /update');

          default:
            return _errorRoute('Route not found: ${settings.name}');
        }
      },
    );
  }

  Route _errorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text(message)),
          ),
    );
  }
}
