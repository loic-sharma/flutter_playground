import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class AlwaysSpecifyPropertyTypesRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'always_specify_property_types',
    'Missing type annotation',
    correctionMessage: "Try adding a type annotation.",
  );

  AlwaysSpecifyPropertyTypesRule()
    : super(
        name: 'always_specify_property_types',
        description:
            'Specify type annotations for top-level variables, static fields, and instance fields.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    var visitor = _Visitor(this, context);
    registry.addFieldDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (node.fields.type == null) {
      rule.reportAtNode(node);
    }
  }
}
