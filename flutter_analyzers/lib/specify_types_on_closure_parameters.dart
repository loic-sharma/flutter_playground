import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

class SpecifyClosureParameterTypesRule extends AnalysisRule {
  static const LintCode code = LintCode(
    'specify_closure_parameter_types',
    'Missing type annotation',
    correctionMessage: 'Try adding a type annotation.',
  );

  SpecifyClosureParameterTypesRule()
    : super(
        name: 'specify_closure_parameter_types',
        description: 'Annotate types for function expression parameters.',
      );

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    var visitor = _Visitor(this, context);
    registry.addFunctionExpression(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;

  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitFunctionExpression(FunctionExpression node) {
    for (var parameter in node.parameters?.parameters ?? <FormalParameter>[]) {
      if (!parameter.isExplicitlyTyped) {
        rule.reportAtNode(parameter);
      }
    }
  }
}
