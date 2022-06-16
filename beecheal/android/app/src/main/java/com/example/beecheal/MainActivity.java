package com.example.beecheal;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.*;

import android.content.Context;
import android.util.Log;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.tensorflow.lite.support.label.Category;
import org.tensorflow.lite.task.text.nlclassifier.NLClassifier;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "model.classifier/inference";
  private final Context context = this.context;
  private Context mContext;
  
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    mContext=this;
    super.configureFlutterEngine(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
      (call, result) -> {
        final Map<String, Object> arguments = call.arguments();
      if (call.method.equals("Classify")) {
        try {
        // String modelPath = (String)arguments.get("modelPath");
        NLClassifier classifier =
        NLClassifier.createFromFile(mContext, "model.tflite");

        // Run inference
        // List<Category> results = 
        String body = (String)arguments.get("string");
        List<Category> results = classifier.classify(body);

        result.success(results.toString());
        } catch(IOException e) {
          result.success(e);
        }
      };
    }
      );
  }
}