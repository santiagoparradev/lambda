public virtual class Objects implements IObjects {
  protected List<Object> objects { get; private set; }

  {
    objects = new List<Object>();
  }

  public class LoopElement {
    public Object obj;
    public Integer index;
    public Object accumulator;
    public Object state;
    public Objects objects;

    public LoopElement(Object obj, Integer index, Objects objects) {
      this.obj = obj;
      this.index = index;
      this.objects = objects;
    }
  }

  public Objects(List<Object> objects) {
    this.objects = objects.clone();
  }

  public List<Object> getObjects() {
    return this.objects;
  }

  public Integer size() {
    return this.objects.size();
  }

  public virtual Objects filter(Evaluator evaluator) {
    if (evaluator.isEmpty()) {
      return new Objects(this.objects);
    }

    List<Object> result = this.objects.clone(); // Correct way to clone a list in Apex

    for (Integer i = 0; i < result.size(); i++) {
      Object obj = result[i];
      LoopElement loopElement = new LoopElement(obj, i, this);

      if (!evaluator.evaluate(loopElement)) {
        result.remove(i);
        i--;
      }
    }

    return new Objects(result);
  }

  public Boolean some(Evaluator evaluator) {
    if (evaluator.isEmpty()) {
      return false;
    }

    for (Integer i = 0; i < this.objects.size(); i++) {
      Object obj = this.objects[i];
      LoopElement loopElement = new LoopElement(obj, i, this);

      if (evaluator.evaluate(loopElement)) {
        return true;
      }
    }

    return false;
  }

  public Boolean every(Evaluator evaluator) {
    if (evaluator.isEmpty()) {
      return false;
    }

    for (Integer i = 0; i < this.objects.size(); i++) {
      Object obj = this.objects[i];
      LoopElement loopElement = new LoopElement(obj, i, this);

      if (!evaluator.evaluate(loopElement)) {
        return false;
      }
    }

    return true;
  }

  public Object find(Evaluator evaluator) {
    if (evaluator.isEmpty()) {
      return null;
    }

    for (Integer i = 0; i < this.objects.size(); i++) {
      Object obj = this.objects[i];
      LoopElement loopElement = new LoopElement(obj, i, this);

      if (evaluator.evaluate(loopElement)) {
        return obj;
      }
    }

    return null;
  }

  public Integer findIndex(Evaluator evaluator) {
    if (evaluator.isEmpty()) {
      return -1;
    }

    for (Integer i = 0; i < this.objects.size(); i++) {
      Object obj = this.objects[i];
      LoopElement loopElement = new LoopElement(obj, i, this);

      if (evaluator.evaluate(loopElement)) {
        return i;
      }
    }

    return -1;
  }

  // public Objects forEach(Lambdas.Callbacks callbacks) {
  //   if (callbacks.isEmpty()) {
  //     return this;
  //   }

  //   for (Object obj : this.objects) {
  //     for (Lambdas.ICallback callback : callbacks.callbacks) {
  //       Lambdas.Input input = new Lambdas.Input();
  //       input.obj = obj;
  //       callback.call(input);
  //     }
  //   }

  //   return this;
  // }

  // public Objects mapTo(Lambdas.Callbacks callbacks) {
  //   if (callbacks.isEmpty()) {
  //     return new Objects(this.objects);
  //   }

  //   List<Object> result = new List<Object>();

  //   for (Object obj : this.objects) {
  //     Object transformed = obj;

  //     for (Lambdas.ICallback callback : callbacks.callbacks) {
  //       Lambdas.Input input = new Lambdas.Input();
  //       input.obj = transformed;
  //       transformed = callback.call(input);
  //     }

  //     result.add(transformed);
  //   }
  //   return new Objects(result);
  // }

  // public Object reduceTo(Lambdas.ICallback callback, Object initialValue) {
  //   if (initialValue == null) {
  //     throw new IllegalArgumentException('Initial value cannot be null');
  //   }
  //   Object accumulator = initialValue;

  //   for (Object obj : this.objects) {
  //     Lambdas.Input input = new Lambdas.Input();
  //     input.obj = obj;
  //     input.accumulator = accumulator;
  //     accumulator = callback.call(input);
  //   }

  //   return accumulator;
  // }

  // public Objects reduce(Lambdas.ICallback callback, Object initialValue) {
  //   if (initialValue == null) {
  //     throw new IllegalArgumentException('Initial value cannot be null');
  //   }
  //   return new Objects((List<Object>) reduceTo(callback, initialValue));
  // }

  // public List<SObject> getSObjects() {
  //   List<SObject> result = new List<SObject>();

  //   for (Object obj : this.getObjects()) {
  //     if (obj instanceof SObject) {
  //       result.add((SObject) obj);
  //     }
  //   }

  //   return result;
  // }
}
