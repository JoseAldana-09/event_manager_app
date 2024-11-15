import 'package:flutter/material.dart';
import 'event_model.dart';

class EventProvider with ChangeNotifier {
  final List<Evento> _eventos = [];

  List<Evento> get eventos => _eventos;

  void agregarEvento(Evento evento) {
    _eventos.add(evento);
    notifyListeners();
  }

  void eliminarEvento(Evento evento) {
    _eventos.remove(evento);
    notifyListeners();
  }
}
