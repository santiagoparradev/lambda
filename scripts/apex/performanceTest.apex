List<Case> listOfCases = new List<Case>();

// Define possible values for random selection
List<String> subjects = new List<String>{'santiago@gmail.com', 'juan@example.com', 'maria@example.com', 'pedro@example.com'};
List<String> comments = new List<String>{
  'Negative',
  'Positive',
  'Neutral',
  'Urgent',
  'Resolved',
  'Pending',
  'Escalated',
  'Closed',
  'In Progress',
  'On Hold',
  'Reopened',
  'Approved',
  'Rejected',
  'Under Investigation',
  'Waiting'
};

for (Integer i = 0; i < 77777; i++) {
    listOfCases.add(new Case(
            Subject = subjects[Math.mod(Math.abs(Crypto.getRandomInteger()), subjects.size())],
            Comments = comments[Math.mod(Math.abs(Crypto.getRandomInteger()), comments.size())]
        ));
}

// Start CPU tracking
Integer startCpu = Limits.getCpuTime();
Integer startHeapSize = Limits.getHeapSize();

Cases forCases = new Cases(listOfCases)
  .withSubjectFor()
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved', 'Rejected', 'Under Investigation', 'Waiting'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved', 'Rejected'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent'})
  .withCommentFor(new Set<String> {'Negative', 'Positive', 'Neutral'})
  .withCommentFor(new Set<String> {'Negative', 'Positive'})
  .withCommentFor(new Set<String> {'Negative'});



System.debug('CPU AFTER CALLBACKS: ' + (Limits.getCpuTime() - startCpu));
System.debug('HEAP AFTER CALLBACKS ' + (Limits.getHeapSize() - startHeapSize));
System.debug(forCases.size());

startCpu = Limits.getCpuTime();
startHeapSize = Limits.getHeapSize();

Cases callbacksCases = new Cases(listOfCases)
.selection(
  new Evaluator()
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved', 'Rejected', 'Under Investigation', 'Waiting'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved', 'Rejected'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened', 'Approved'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold', 'Reopened'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress', 'On Hold'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed', 'In Progress'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated', 'Closed'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending', 'Escalated'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved', 'Pending'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent', 'Resolved'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral', 'Urgent'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive', 'Neutral'}))
    .add(Cases.withComment(new Set<String> {'Negative', 'Positive'}))
    .add(Cases.withComment(new Set<String> {'Negative'}))
    .add('14')
);

System.debug('CPU AFTER CALLBACKS: ' + (Limits.getCpuTime() - startCpu));
System.debug('HEAP AFTER CALLBACKS ' + (Limits.getHeapSize() - startHeapSize));
System.debug(callbacksCases.size());
