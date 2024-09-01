import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    //adding this multiprovider widget so that providers can be used anywhere in our application
    MultiProvider(
      providers: [
        //we need to provide a list of all the providers we are using
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MyApp(scaffoldMessengerKey: scaffoldMessengerKey),
    ),
  );
}

//we are using myApp as stateful widget since we are going to use init here to initialize the app, meaning if we want homepage or singin page on app launch
class MyApp extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const MyApp({Key? key, required this.scaffoldMessengerKey}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    //initializing the signed in user
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      //theme data is used to configure the theme off entire application
      theme: ThemeData(
          //we are specifying that the color scheme for our app will be a light one with the color being the primary color
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          //sets the default appbar theme, we are not adding the default appbar color here even though ewe can because we want our appbar color to be a gradient and normal color? does not support that
          appBarTheme: const AppBarTheme(
              elevation: 0,
              //sets default theme for all the icons used in the app
              iconTheme: IconThemeData(color: Colors.black))),
      //this ongenerateroute will run anytime we use something like pushNamed routes
      onGenerateRoute: (settings) => generateRoute(settings),
      //if the token is not empty, that means we have saved some token. Now if the user is not admin that means we can directly go to the homescreen
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          //if the user type is user, then we show the bottom bar otherwise the admin screen
          ? Provider.of<UserProvider>(context).user.type == 'user'
              ? BottomBar()
              : AdminScreen()
          : const AuthScreen(),
    );
  }
}
