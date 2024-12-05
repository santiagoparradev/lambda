public virtual class SObjects extends Objects implements ISObjects {
  public SObjects(List<SObject> records) {
    super(records);
  }

  public virtual List<SObject> getRecords() {
    return (List<SObject>) getObjects();
  }

  public virtual SObjects filterRecords(Evaluator evaluator) {
    return new SObjects((List<SObject>) filter(evaluator).getObjects());
  }
}
