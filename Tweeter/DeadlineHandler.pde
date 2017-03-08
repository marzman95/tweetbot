public class Deadline {
    private final String item;
    private final Calendar time;
   
    public Deadline(String item, Calendar time) {
        this.item = item;
        this.time = time;
    }

    public String getItem() { return item; }
    public Calendar getCal() { return time; }
}

public class DeadlineHandler {

  // Methods to add a deadline, must be in chronological order!
  void setDeadlines() {
    addDeadline("the mini-PDP", 2017, 1, 13, 8, 45);
    addDeadline("Challenge 1", 2017, 2, 10, 17, 0);
    addDeadline("Challenge 2", 2017, 3, 10, 17, 0);
  }
  void addDeadline(String item, int year, int month, int day, int hour, int minute) {
    Calendar cal = Calendar.getInstance();
    cal.set(year, month, day, hour, minute);
    Deadline dl = new Deadline(item, cal);
    deadlines.add(dl);
  }
  
  // Method to get the next deadline
  Deadline getNextDeadline() {
    long currentTime = System.currentTimeMillis();
    System.out.println(currentTime);
    for(Deadline dl : deadlines) {
      if (dl.getCal().getTimeInMillis() < currentTime) {
        // This deadline has passed. Do nothing.
      } else {
        return dl;
      }
    }
    return new Deadline("-- there are no more deadlines! --", Calendar.getInstance());
  }

}