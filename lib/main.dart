import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

final plugin = SimplePlugin();

class SimplePlugin extends Plugin {
  @override
  String get name => 'Simple Plugin';

  @override
  void register(PluginRegistry registry) {
    // Register diagnostics, quick fixes, and assists.
  }
}
