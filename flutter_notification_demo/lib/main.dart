import 'package:flutter/material.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa notificações
  await NotificationService.init();

  // Solicita permissões automaticamente
  await NotificationService.requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Escuta clique na notificação
    NotificationService
        .onNotificationClick
        .stream
        .listen((String? payload) {

      if (payload != null &&
          payload.isNotEmpty) {

        navigatorKey.currentState
            ?.pushNamed(payload);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificações Flutter',

      debugShowCheckedModeBanner: false,

      navigatorKey: navigatorKey,

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const HomeScreen(),

        '/details': (context) =>
            const DetailsScreen(),
      },
    );
  }
}

/// =========================
/// HOME
/// =========================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificações Locais',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          crossAxisAlignment:
              CrossAxisAlignment.stretch,

          children: [

            /// NOTIFICAÇÃO IMEDIATA
            ElevatedButton(
              onPressed: () async {

                await NotificationService
                    .showInstantNotification(
                  id: 1,

                  title:
                      'Notificação Imediata',

                  body:
                      'Essa notificação apareceu imediatamente.',
                );
              },

              child: const Text(
                'Notificação Imediata',
              ),
            ),

            const SizedBox(height: 16),

            /// NOTIFICAÇÃO AGENDADA
            ElevatedButton(
              onPressed: () async {

                await NotificationService
                    .scheduleNotification(
                  id: 2,

                  title:
                      'Notificação Agendada',

                  body:
                      'Passaram 30 segundos.',

                  secondsDelay: 30,
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  const SnackBar(
                    content: Text(
                      'Notificação agendada para 30 segundos.',
                    ),
                  ),
                );
              },

              child: const Text(
                'Agendar Notificação',
              ),
            ),

            const SizedBox(height: 16),

            /// NOTIFICAÇÃO COM AÇÃO
            ElevatedButton(
              onPressed: () async {

                await NotificationService
                    .showNotificationWithAction(
                  id: 3,

                  title:
                      'Abrir Tela',

                  body:
                      'Clique para abrir a tela de detalhes.',

                  payloadRoute:
                      '/details',
                );
              },

              child: const Text(
                'Notificação com Ação',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =========================
/// TELA DE DETALHES
/// =========================
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tela de Detalhes',
        ),
      ),

      body: const Center(
        child: Text(
          'Você abriu a tela pela notificação 🚀',

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}