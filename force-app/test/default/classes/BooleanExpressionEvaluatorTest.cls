@IsTest
public class BooleanExpressionEvaluatorTest {
  @IsTest
  static void testBasicOperations() {
    Assert.areEqual(
      false,
      BooleanExpressionEvaluator.evaluate(
        new List<Boolean>{ true, false },
        '1 AND 2'
      ),
      'Test AND Expression'
    );

    Assert.areEqual(
      true,
      BooleanExpressionEvaluator.evaluate(
        new List<Boolean>{ true, false },
        '1 OR 2'
      ),
      'Test OR Expression'
    );

    Assert.areEqual(
      false,
      BooleanExpressionEvaluator.evaluate(new List<Boolean>{ true }, 'NOT 1'),
      'Test NOT Expression'
    );
  }

  @IsTest
  static void testEdgeCases() {
    Assert.areEqual(
      false,
      BooleanExpressionEvaluator.evaluate(
        new List<Boolean>{ true, false },
        'NOT (1 OR NOT 2)'
      ),
      'NOT operand should work with nested expressions'
    );

    Assert.areEqual(
      true,
      BooleanExpressionEvaluator.evaluate(new List<Boolean>{ true }, '1'),
      'Single operand 1 should be true'
    );

    Assert.areEqual(
      false,
      BooleanExpressionEvaluator.evaluate(
        new List<Boolean>{ true, true, false },
        '1 AND 2 AND 3'
      ),
      'All operands should be validated'
    );
  }

  @IsTest
  static void testComplexEdgeCase() {
    List<Boolean> VALUES = new List<Boolean>{ true, false, true, false };
    Map<String, Boolean> TEST_SCENARIOS = new Map<String, Boolean>{
      '1 AND 2 OR 3' => true,
      '1 OR 2 AND 3' => true,
      'NOT (1 AND 2)' => true,
      'NOT 1 OR 2' => false,
      '(1 AND 2) OR 3' => true,
      '1 AND (2 OR 3)' => true,
      '(1 OR 2) AND (3 OR 4)' => true,
      '1 OR (2 AND 3)' => true,
      'NOT (1 OR 2) AND 3' => false,
      '1 AND (NOT 2 OR 3)' => true
    };

    for (String expression : TEST_SCENARIOS.keySet()) {
      Boolean expected = TEST_SCENARIOS.get(expression);
      Boolean actual = BooleanExpressionEvaluator.evaluate(VALUES, expression);

      Assert.areEqual(
        expected,
        actual,
        'should match expected result ' + expression
      );
    }

    Assert.areEqual(
      true,
      BooleanExpressionEvaluator.evaluate(VALUES, '1 AND (NOT 2 OR 3)'),
      'should be retrieve using cache'
    );

    Assert.areEqual(
      false,
      BooleanExpressionEvaluator.evaluate(
        new List<Boolean>{ true, true, false },
        '1 AND (NOT 2 OR 3)'
      ),
      'should not be retrieved from cache'
    );
  }
}
