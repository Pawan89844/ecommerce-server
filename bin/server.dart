import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'router.dart';

// Configure routes.

// Router _router = Router()
//   ..get('/', _rootHandler)
//   ..get('/products', _products)
//   ..get('/echo/<message>', _echoHandler);

// final fbDatabase = core.FirebaseDatabase();

void main(List<String> args) async {
  // MyRouter routers = MyRouter();
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server url:- ${server.address.host} ${server.address.host}');
  print('Server listening on port ${server.port}');
}
