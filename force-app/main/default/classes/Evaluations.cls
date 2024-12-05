public class Evaluations {
  public enum Logical {
    LOGICAL_AND,
    LOGICAL_OR,
    LOGICAL_EXPRESSION
  }
  public List<BooleanExpressionEvaluator.Evaluation> callbacks = new List<BooleanExpressionEvaluator.Evaluation>();
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

  public Evaluations anyMatch() {
    this.logicalAnd = false;
    return this;
  }

  public Evaluations allMatch() {
    this.logicalAnd = true;
    return this;
  }

  public Evaluations checkExpression(String logicalExpression) {
    if (String.isNotBlank(logicalExpression)) {
      this.logicalExpression = logicalExpression;
    }

    return this;
  }

  public Evaluations add(BooleanExpressionEvaluator.Evaluation callback) {
    callbacks.add(callback);
    return this;
  }

  public Boolean isEmpty() {
    return this.callbacks != null && this.callbacks.isEmpty();
  }
}
