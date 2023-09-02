import 'package:logger/logger.dart';

class Logging {
  late Logger log;

  static Logging? _instance;
  factory Logging() => _instance ??= Logging._();

  Logging._() {
    log = Logger();
  }

  void dispose() {
    log.close();
  }
}
