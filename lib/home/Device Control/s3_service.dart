import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

class S3Service {
  Future<List<StorageItem>> _listPredictionFiles() async {
    try {
      final result = await Amplify.Storage.list(

        path: const StoragePath.fromString('prediction/'),
        options: const StorageListOptions(
          pluginOptions: S3ListPluginOptions.listAll(),
        ),
      ).result;
      return result.items;
    } catch (e) {
      safePrint("❌ S3 Error: Could not list files in 'public/prediction/'. $e");
      throw Exception(
        'S3 Error: Failed to list files. Ensure guest access is enabled and the path "public/prediction/" exists in your bucket.',
      );
    }
  }

  Future<String> getLatestPredictionFilePath() async {
    final allFiles = await _listPredictionFiles();
    safePrint("📂 Found ${allFiles.length} files in the prediction directory.");

    final jsonFiles =
        allFiles.where((f) => f.path.toLowerCase().endsWith('.json')).toList();

    if (jsonFiles.isEmpty) {
      safePrint("⚠️ No JSON files found in 'public/prediction/'.");
      throw Exception(
          "No JSON prediction files found. Check your S3 bucket's 'public/prediction/' folder.");
    }

    jsonFiles.sort((a, b) {
      final aDate = a.lastModified ?? DateTime(1970);
      final bDate = b.lastModified ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    final latestFile = jsonFiles.first;
    safePrint("📄 Latest prediction file is: ${latestFile.path}");
    return latestFile.path;
  }

  Future<String> getPreSignedUrl(String filePath) async {
    try {
      final result = await Amplify.Storage.getUrl(
        path: StoragePath.fromString(filePath),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(

            expiresIn: Duration(seconds: 60),
          ),
        ),
      ).result;
      safePrint("🔗 Generated pre-signed URL successfully.");
      return result.url.toString();
    } catch (e) {
      safePrint("❌ S3 Error: Could not generate pre-signed URL for '$filePath'. $e");
      throw Exception('S3 Error: Failed to create a secure download link.');
    }
  }
}
