import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:flutter_custom_analyzers/add_type_annotation.dart';
import 'package:flutter_custom_analyzers/always_specify_property_types.dart';
import 'package:flutter_custom_analyzers/specify_types_on_closure_parameters.dart';

final plugin = FlutterCustomAnalyzer();

class FlutterCustomAnalyzer extends Plugin {
  @override
  String get name => 'Flutter custom analyzer';

  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(AlwaysSpecifyPropertyTypesRule());
    registry.registerFixForRule(AlwaysSpecifyPropertyTypesRule.code, AddTypeAnnotation.new);

    registry.registerWarningRule(SpecifyClosureParameterTypesRule());
    registry.registerFixForRule(SpecifyClosureParameterTypesRule.code, AddTypeAnnotation.new);
  }
}
