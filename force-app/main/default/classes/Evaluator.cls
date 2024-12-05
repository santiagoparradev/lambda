public class Evaluator {
  private static final String LEFT_ASOCIATIVITY = 'left';
  private static final String AND_OPERATOR = 'AND';
  private static final String NOT_OPERATOR = 'NOT';
  private static final String OR_OPERATOR = 'OR';
  private static final String RIGHT_ASOCIATIVITY = 'right';
  private static final String OPEN_PARENTHESIS = '(';
  private static final String CLOSE_PARENTHESIS = ')';
  @TestVisible
  private static final Map<String, Boolean> CACHE = new Map<String, Boolean>();

  private static final Map<String, OperatorInfo> OPERATORS = new Map<String, OperatorInfo>{
    NOT_OPERATOR => new OperatorInfo(3, RIGHT_ASOCIATIVITY),
    AND_OPERATOR => new OperatorInfo(2, LEFT_ASOCIATIVITY),
    OR_OPERATOR => new OperatorInfo(1, LEFT_ASOCIATIVITY)
  };

  public interface Evaluation {
    Boolean evaluate(Object input);
  }

  public Boolean evaluate(Object obj) {
    if (type == Logical.LOGICAL_OR || type == Logical.LOGICAL_AND) {
      return evaluateWithCondition(obj, type == Logical.LOGICAL_OR);
    }

    if (String.isBlank(logicalExpression)) {
      throw new EvaluatorException('Invalid logicalExpression');
    }

    if (evaluations.isEmpty()) {
      throw new EvaluatorException(
        'You need to provide at least one evaluation'
      );
    }

    return evaluateExpression(obj);
  }

  private Boolean evaluateExpression(Object input) {
    List<Boolean> stack = new List<Boolean>();

    for (String token : getTokensAsReversePolishNotation()) {
      if (token.isNumeric()) {
        Integer index = Integer.valueOf(token) - 1;

        if (index < 0 || index >= evaluations.size()) {
          throw new EvaluatorException(
            'Index out of range for token: ' + token
          );
        }

        stack.add(evaluations[index].evaluate(input));
      } else if (token == NOT_OPERATOR) {
        if (stack.isEmpty()) {
          throw new EvaluatorException('NOT operation needs one operand.');
        }
        Boolean operand = stack.remove(stack.size() - 1);
        stack.add(!operand);
      } else if (token == AND_OPERATOR || token == OR_OPERATOR) {
        if (stack.size() < 2) {
          throw new EvaluatorException('AND/OR operation needs two operands.');
        }

        Boolean right = stack.remove(stack.size() - 1);
        Boolean left = stack.remove(stack.size() - 1);

        // short circuit
        if (token == AND_OPERATOR) {
          stack.add(!left ? false : right);
        } else if (token == OR_OPERATOR) {
          stack.add(left ? true : right);
        }
      } else {
        throw new EvaluatorException('Unknown operator: ' + token);
      }
    }

    if (stack.size() != 1) {
      throw new EvaluatorException('Invalid RPN logicalExpression.');
    }

    Boolean result = stack[0];
    return result;
  }

  private List<String> getTokensAsReversePolishNotation() {
    List<String> output = new List<String>(); // RPN output queue
    List<String> operatorStack = new List<String>(); // Operator operatorStack

    List<String> tokens = new List<String>();
    Pattern tokenPattern = Pattern.compile('\\d+|AND|OR|NOT|\\(|\\)'); // Matches numbers, operators, and parentheses
    Matcher matcher = tokenPattern.matcher(logicalExpression);

    while (matcher.find()) {
      tokens.add(matcher.group().trim()); // Add trimmed token to avoid extra spaces
    }

    for (String token : tokens) {
      if (token.isNumeric()) {
        output.add(token);
      } else if (OPERATORS.containsKey(token)) {
        OperatorInfo operator = OPERATORS.get(token);

        while (
          !operatorStack.isEmpty() &&
          !operatorStack.get(operatorStack.size() - 1).equals(OPEN_PARENTHESIS)
        ) {
          OperatorInfo topOperator = OPERATORS.get(
            operatorStack.get(operatorStack.size() - 1)
          );

          Boolean shouldPopForLeftAssociative =
            operator.associativity.equals(LEFT_ASOCIATIVITY) &&
            operator.precedence <= topOperator.precedence;

          Boolean shouldPopForRightAssociative =
            operator.associativity.equals(RIGHT_ASOCIATIVITY) &&
            operator.precedence < topOperator.precedence;

          if (shouldPopForLeftAssociative || shouldPopForRightAssociative) {
            output.add(operatorStack.remove(operatorStack.size() - 1));
          } else {
            break;
          }
        }

        operatorStack.add(token);
      } else if (token.equals(OPEN_PARENTHESIS)) {
        operatorStack.add(token);
      } else if (token.equals(CLOSE_PARENTHESIS)) {
        while (
          !operatorStack.isEmpty() &&
          !operatorStack[operatorStack.size() - 1].equals(OPEN_PARENTHESIS)
        ) {
          output.add(operatorStack.remove(operatorStack.size() - 1));
        }

        operatorStack.remove(operatorStack.size() - 1); // Remove the OPEN_PARENTHESIS
      } else {
        throw new EvaluatorException('Unknown token: ' + token);
      }
    }

    // Pop remaining operators in the operatorStack

    while (!operatorStack.isEmpty()) {
      output.add(operatorStack.remove(operatorStack.size() - 1));
    }

    return output;
  }

  private class OperatorInfo {
    private Integer precedence;
    private String associativity;
    private OperatorInfo(Integer precedence, String associativity) {
      this.precedence = precedence;
      this.associativity = associativity;
    }
  }

  private class EvaluatorException extends Exception {
  }

  public enum Logical {
    LOGICAL_AND,
    LOGICAL_OR,
    LOGICAL_EXPRESSION
  }

  private List<Evaluation> evaluations = new List<Evaluation>();
  public String logicalExpression = '';
  public Boolean logicalAnd = true;

  public Logical type {
    get {
      if (type == null) {
        type = String.isNotBlank(logicalExpression)
          ? Logical.LOGICAL_EXPRESSION
          : (logicalAnd ? Logical.LOGICAL_AND : Logical.LOGICAL_OR);
      }

      return type;
    }
    private set;
  }

  public Evaluator anyMatch() {
    this.logicalAnd = false;
    return this;
  }

  public Evaluator allMatch() {
    this.logicalAnd = true;
    return this;
  }

  public Evaluator checkExpression(String logicalExpression) {
    if (String.isNotBlank(logicalExpression)) {
      this.logicalExpression = logicalExpression;
    }

    return this;
  }

  public Evaluator add(Evaluation callback) {
    evaluations.add(callback);
    return this;
  }

  public Boolean isEmpty() {
    return this.evaluations != null && this.evaluations.isEmpty();
  }

  public List<Evaluation> getEvaluations() {
    return this.evaluations;
  }

  private Boolean evaluateWithCondition(Object obj, Boolean stopOnMatch) {
    for (Evaluation evaluation : evaluations) {
      Boolean result = evaluation.evaluate(obj);

      if (stopOnMatch == result) {
        return stopOnMatch;
      }
    }
    return !stopOnMatch;
  }
}
