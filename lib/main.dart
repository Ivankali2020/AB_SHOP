import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/BannerProvider.dart';
import 'package:ab_shop/Provider/CartProvider.dart';
import 'package:ab_shop/Provider/CategoryProvider.dart';
import 'package:ab_shop/Provider/DIscountProvider.dart';
import 'package:ab_shop/Provider/OrderProvider.dart';
import 'package:ab_shop/Provider/ProductProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Provider/navProvider.dart';
import 'package:ab_shop/material-theme/color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final data = await AuthManager.getUserAndToken();

  runApp(ChangeNotifierProvider.value(
    value: UserProvider(data),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NavProvider()),
        ChangeNotifierProvider(create: (context) => BannerProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => DiscountProvider()),
        ChangeNotifierProxyProvider<UserProvider, ProductProvider>(
            create: (context) => ProductProvider(''),
            update: (context, userProvider, productProvider) {
              final token = userProvider.token;
              return ProductProvider(token!);
            }),
        // ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const Main(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    return DefaultTextStyle(
      style: GoogleFonts.orbitron(),
      child: Scaffold(
        body: navProvider.pages[navProvider.activeIndex]['page'],
        bottomNavigationBar: NavigationBar(
          selectedIndex: navProvider.activeIndex,
          destinations: [
            ...navProvider.pages
                .map(
                  (e) => NavigationDestination(
                    icon: Icon(e['icon']),
                    selectedIcon: Icon(e['active_icon']),
                    label: e['name'],
                  ),
                )
                .toList()
          ],
          height: 80,
          onDestinationSelected: (value) {
            navProvider.changeIndex(value);
          },
        ),
      ),
    );
  }
}
