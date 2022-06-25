package com.example.beecheal;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import java.util.*;

import android.content.Context;
import android.util.Log;
import java.io.IOException;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.tensorflow.lite.support.label.Category;
import org.tensorflow.lite.task.text.nlclassifier.NLClassifier;

import com.google.firebase.ml.modeldownloader.CustomModelDownloadConditions;
import com.google.firebase.ml.modeldownloader.DownloadType;
import com.google.firebase.ml.modeldownloader.FirebaseModelDownloader;
import com.google.firebase.ml.modeldownloader.CustomModel;

import com.google.android.gms.tasks.OnSuccessListener;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "model.classifier/inference";
  private final Context context = this.context;
  private Context mContext;
  // Define a NLClassifier variable
  private NLClassifier textClassifier;
  
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    mContext=this;
    super.configureFlutterEngine(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
      (call, result) -> {
        final Map<String, Object> arguments = call.arguments();
      if (call.method.equals("Classify")) {
        
      /** Download model from Firebase ML. */
        CustomModelDownloadConditions conditions = new CustomModelDownloadConditions.Builder()
        .requireWifi()
        .build();
    
        FirebaseModelDownloader.getInstance()
        .getModel("text-classification", DownloadType.LOCAL_MODEL_UPDATE_IN_BACKGROUND, conditions)
        .addOnSuccessListener(new OnSuccessListener<CustomModel>() {
          @Override
          public void onSuccess(CustomModel model) {
            // Download complete. Depending on your app, you could enable the ML
            // feature, or switch from the local model to the remote model, etc.

            // The CustomModel object contains the local path of the model file,
            // which you can use to instantiate a TensorFlow Lite interpreter.
            File modelFile = model.getFile();
            if (modelFile != null) {
              try{
                textClassifier = NLClassifier.createFromFile(modelFile);
              } catch(IOException e) {
              }
            }
          }
        });

        // Run inference
        String body = (String)arguments.get("string");
        try {
        List<Category> results = textClassifier.classify(body);
        int output;

        if (-0.10 < (results.get(0).getScore() - results.get(1).getScore()) && (results.get(0).getScore() - results.get(1).getScore()) < 0.10) {
          output = 0;
        }
        else if (results.get(0).getScore() > results.get(1).getScore()) {
          output = -1;
        }
        else {
          output = 1;
        }
        // return prediction
        result.success(output);
        } catch (NullPointerException e) {

        }

      };
    }
      );
  }
}