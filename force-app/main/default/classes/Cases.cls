public class Cases extends SObjects {
  public Cases(List<SObject> cases) {
    super(cases);
  }

  public List<Case> getCases() {
    return (List<Case>) this.getRecords();
  }

  public Cases withSubjectFor() {
    List<Case> result = new List<Case>();

    for (Case record : getCases()) {
      if (String.isNotBlank(record.Subject)) {
        result.add(record);
      }
    }

    return new Cases(result);
  }

  public Cases withCommentFor(Set<String> values) {
    List<Case> result = new List<Case>();

    for (Case record : getCases()) {
      if (values.contains(record.Comments)) {
        result.add(record);
      }
    }

    return new Cases(result);
  }

  public Cases selection(Evaluator evaluator) {
    return new Cases(filterRecords(evaluator).getRecords());
  }

  public static WithSubject withSubject() {
    return new WithSubject();
  }

  public static WithComments withComment(Set<String> values) {
    WithComments withComments = new WithComments();
    withComments.values = values;
    return withComments;
  }

  public class WithSubject implements Evaluator.Evaluation {
    public Boolean evaluate(Object input) {
      Objects.LoopElement element = (Objects.LoopElement) input;
      Case record = (Case) element.obj;
      return String.isNotBlank(record.Subject);
    }
  }

  public class WithComments implements Evaluator.Evaluation {
    Set<String> values = new Set<String>();

    public Boolean evaluate(Object input) {
      Objects.LoopElement element = (Objects.LoopElement) input;
      Case record = (Case) element.obj;
      return values.contains(record.Comments);
    }
  }
}
