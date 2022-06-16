import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class Classifier {
  FirebaseCustomModel? _model;
  initWithLocalModel() async {
    _model = await FirebaseModelDownloader.instance
        .getModel(
            "text-classification",
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              androidChargingRequired: false,
              androidWifiRequired: false,
              androidDeviceIdleRequired: false,
            ))
        .then((customModel) {
      final localModelPath = customModel.file;
    });
  }

  getModelFile() {
    return _model;
  }
}
