import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class CloudinaryService {
  // TODO: Replace with your Cloudinary credentials
  static const String cloudName = 'delpnz3ar';
  static const String apiKey = '394547485135397';
  static const String apiSecret = 'ZwHd4DP4KCSKctBq0B25YR-4i4o';
  
  /// Compress and upload image to Cloudinary
  /// Returns the URL of the uploaded image
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Step 1: Compress the image
      final compressedFile = await _compressImage(imageFile);
      
      // Step 2: Upload to Cloudinary
      final imageUrl = await _uploadToCloudinary(compressedFile);
      
      // Clean up temporary compressed file
      if (compressedFile.path != imageFile.path) {
        await compressedFile.delete();
      }
      
      return imageUrl;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  /// Compress image to reduce file size
  /// Target: Max 1080px width/height, JPEG quality 80%
  Future<File> _compressImage(File file) async {
    try {
      // Read image bytes
      final bytes = await file.readAsBytes();
      
      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        print('Could not decode image, returning original');
        return file;
      }

      // Resize if too large (max 1080px on longest side)
      const maxDimension = 1080;
      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          image = img.copyResize(image, width: maxDimension);
        } else {
          image = img.copyResize(image, height: maxDimension);
        }
      }

      // Encode to JPEG with 80% quality
      final compressedBytes = img.encodeJpg(image, quality: 80);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      // Log compression results
      final originalSize = await file.length();
      final compressedSize = await tempFile.length();
      final savings = ((originalSize - compressedSize) / originalSize * 100).round();
      print('Image compressed: ${(originalSize / 1024).round()}KB -> ${(compressedSize / 1024).round()}KB ($savings% savings)');

      return tempFile;
    } catch (e) {
      print('Compression error: $e');
      return file;
    }
  }

  /// Upload file to Cloudinary using signed upload
  Future<String?> _uploadToCloudinary(File file) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      // Create signature
      final signatureString = 'timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(signatureString)).toString();
      
      // Create multipart request
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add fields
      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp.toString();
      request.fields['signature'] = signature;
      
      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: 'issue_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);
      
      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        final imageUrl = jsonResponse['secure_url'] as String?;
        print('Upload successful: $imageUrl');
        return imageUrl;
      } else {
        print('Upload failed: ${response.statusCode} - $responseData');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}

/// Alternative: Using unsigned upload preset (easier, no signature needed)
class CloudinaryUnsignedUpload {
  static const String uploadPreset = 'red2green_unsigned'; // Create this in Cloudinary dashboard
  static const String cloudName = 'YOUR_CLOUD_NAME';

  /// Simple unsigned upload (easier for mobile apps)
  /// You must create an unsigned upload preset in Cloudinary dashboard first
  Future<String?> uploadImage(File file) async {
    try {
      // Compress first
      final compressedFile = await _compressImage(file);
      
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // For unsigned uploads, you need to create an upload preset in Cloudinary
      request.fields['upload_preset'] = uploadPreset;
      
      // Add file
      final fileStream = http.ByteStream(compressedFile.openRead());
      final fileLength = await compressedFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: 'issue_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(multipartFile);
      
      // Send request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      
      // Clean up
      if (compressedFile.path != file.path) {
        await compressedFile.delete();
      }
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        final imageUrl = jsonResponse['secure_url'] as String?;
        print('Upload successful: $imageUrl');
        return imageUrl;
      } else {
        print('Upload failed: ${response.statusCode} - $responseData');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  /// Compress image to reduce file size
  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return file;

      const maxDimension = 1080;
      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          image = img.copyResize(image, width: maxDimension);
        } else {
          image = img.copyResize(image, height: maxDimension);
        }
      }

      final compressedBytes = img.encodeJpg(image, quality: 80);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      final originalSize = await file.length();
      final compressedSize = await tempFile.length();
      final savings = ((originalSize - compressedSize) / originalSize * 100).round();
      print('Image compressed: ${(originalSize / 1024).round()}KB -> ${(compressedSize / 1024).round()}KB ($savings% savings)');

      return tempFile;
    } catch (e) {
      print('Compression error: $e');
      return file;
    }
  }
}