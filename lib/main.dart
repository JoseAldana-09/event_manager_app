import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'event_provider.dart';
import 'event_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EventScreen(),
    );
  }
}

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos'),
      ),
      body: eventProvider.eventos.isEmpty
          ? const Center(
              child: Text(
                'No hay eventos registrados.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: eventProvider.eventos.length,
              itemBuilder: (context, index) {
                final evento = eventProvider.eventos[index];
                return ListTile(
                  title: Text(evento.descripcion),
                  subtitle:
                      Text(evento.fecha.toLocal().toString().split(' ')[0]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eventProvider.eliminarEvento(evento),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoEvento(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoNuevoEvento(BuildContext context) {
    final descripcionController = TextEditingController();
    final fechaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nuevo Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: fechaController,
                decoration:
                    const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final descripcion = descripcionController.text;
                final fecha = DateTime.tryParse(fechaController.text);
                if (descripcion.isNotEmpty && fecha != null) {
                  final nuevoEvento =
                      Evento(descripcion: descripcion, fecha: fecha);
                  Provider.of<EventProvider>(context, listen: false)
                      .agregarEvento(nuevoEvento);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}
