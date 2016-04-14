package ch.heigvd.schoolpulse;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.util.logging.Logger;
import org.junit.runner.Description;
import org.junit.runner.Result;
import org.junit.runner.notification.RunListener;

/**
 *
 * @author Olivier Liechti
 */
public class TestResultListener extends RunListener {

  private static final Logger LOG = Logger.getLogger(TestResultListener.class.getName());
  
  
  public TestResultListener() {
  }

  @Override
  public void testStarted(Description description) throws Exception {
  }

  @Override
  public void testRunStarted(Description description) throws Exception {
  }

  @Override
  public void testRunFinished(Result result) throws Exception {
    ObjectMapper mapper = new ObjectMapper();
    BufferedWriter writer = new BufferedWriter(new FileWriter("test-results.json"));
    mapper.writeValue(writer, result);
    writer.close();        
  }

}