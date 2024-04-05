import 'dart:ui';

import 'package:evoz_web/util/global.dart';
import 'package:evoz_web/util/routes.dart';
import 'package:evoz_web/view/balcao/balcao_view.dart';
import 'package:evoz_web/view/caixa_view.dart';
import 'package:evoz_web/view/cliente_view.dart';
import 'package:evoz_web/view/config_view.dart';
import 'package:evoz_web/view/dashboard_view.dart';
import 'package:evoz_web/view/estoque_view.dart';
import 'package:evoz_web/view/formaPagamento_view.dart';
import 'package:evoz_web/view/loja_view.dart';
import 'package:evoz_web/view/menu/menu_navigation.dart';
import 'package:evoz_web/view/mesa_view.dart';
import 'package:evoz_web/view/produtos/produto_view.dart';
import 'package:evoz_web/view/vendas_view.dart';
import 'package:flutter/material.dart';
import 'package:evoz_web/view/login_view.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final _flexSchemeLight = const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(56,106,227, 1),
    onPrimary: Color(0xffffffff),
    // primaryContainer: Color.fromRGBO(66, 95, 229, 1),
    primaryContainer: Color.fromRGBO(99, 124, 243, 1.0),
    onPrimaryContainer: Colors.white,
    secondary: Color(0xff202b6d),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff99ccf9),
    onSecondaryContainer: Color(0xff0d1114),
    tertiary: Color(0xff514239),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffbaa99d),
    onTertiaryContainer: Color(0xff100e0d),
    error: Color(0xffb00020),
    onError: Color(0xffffffff),
    errorContainer: Color(0xfffcd8df),
    onErrorContainer: Color(0xff141213),
    // background: Color(0xfffcfcfc),
    background: Color.fromRGBO(247, 247, 247, 1),
    onBackground: Color(0xff090909),
    surface: Color.fromRGBO(252, 252, 252, 1),
    onSurface: Color(0xff090909),
    surfaceVariant: Color(0xfff1f7fc),
    onSurfaceVariant: Color(0xff121313),
    outline: Color(0xff565656),
    shadow: Color(0xff000000),
    inverseSurface: Color(0xff121518),
    onInverseSurface: Color(0xfff5f5f5),
    inversePrimary: Color.fromRGBO(227,238,252, 1),
    surfaceTint: Color(0xff4496e0),
  );

  final _flexSchemeDark = const ColorScheme(
    brightness: Brightness.dark,
    // primary: Color.fromRGBO(91, 66, 234, 1),
    primary: Color.fromRGBO(56,106,227, 1),
    onPrimary: Color(0xffe4f6ff),
    // primaryContainer: Color.fromRGBO(44, 41, 51, 1.0),
    primaryContainer: Color.fromRGBO(56,106,227, 1),
    // primaryContainer: Color(0xff1e8fdb),
    onPrimaryContainer: Color.fromRGBO(255, 255, 255, 1.0),
    secondary: Color(0xff99ccf9),
    onSecondary: Color(0xff101414),
    secondaryContainer: Color(0xff0d162f),
    onSecondaryContainer: Color(0xffe4e6f0),
    tertiary: Color(0xffbaa99d),
    onTertiary: Color(0xff121110),
    tertiaryContainer: Color(0xff514239),
    onTertiaryContainer: Color(0xffeceae8),
    error: Color(0xffcf6679),
    onError: Color(0xff140c0d),
    errorContainer: Color(0xffb1384e),
    onErrorContainer: Color(0xfffbe8ec),
    background: Color(0xff1a1d1f),
    onBackground: Color(0xffededed),
    surface: Color(0xff1a1d1f),
    onSurface: Color(0xffededed),
    surfaceVariant: Color(0xff242a2d),
    onSurfaceVariant: Color(0xffdcddde),
    outline: Color(0xffa1a1a1),
    shadow: Color(0xff000000),
    inverseSurface: Color(0xfffafdff),
    onInverseSurface: Color(0xff131314),
    inversePrimary: Color(0xff5c7278),
    surfaceTint: Color(0xffb4e6ff),
  );


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse,PointerDeviceKind.touch},
      ),
      routes: {
        Routes.login: (context) => LoginView(),
        Routes.menu: (context) => MenuNavigation(),
        Routes.balcao: (context) => BalcaoView(),
        Routes.caixa: (context) => CaixaView(),
        Routes.cliente: (context) => ClienteView(),
        Routes.config: (context) => ConfigView(),
        Routes.dashboard: (context) => DashboardView(),
        Routes.estoque: (context) => EstoqueView(),
        Routes.formaPagamento: (context) => Global().empresa?.utilizaIfood == true ? FormaPagamentoView() : Container(),
        Routes.loja: (context) => LojaView(),
        Routes.mesa: (context) => MesaView(),
        Routes.produto: (context) => ProdutoView(),
        Routes.venda: (context) => VendaView(),
      },
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: _flexSchemeLight,
          cardTheme: CardTheme(
            surfaceTintColor: Theme.of(context).colorScheme.surface,
          ),
          dialogTheme: DialogTheme(
            surfaceTintColor: Theme.of(context).colorScheme.surface,
          )
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: _flexSchemeDark,
      ),
      title: 'EvozW',
      initialRoute: Routes.login,
      debugShowCheckedModeBanner: false,
    );
  }
}
