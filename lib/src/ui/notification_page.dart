import 'package:flutter/material.dart';
import 'package:p2p_pay/src/ui/widgets/ripples_animation%20.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPagetate();
}

class _NotificationPagetate extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification")),
      body: const RipplesAnimation(),
    );
  }
}
