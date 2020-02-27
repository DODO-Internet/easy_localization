import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

abstract class AssetLoader {
  const AssetLoader();
  Future<String> load(String localePath);
}

//
//
//
// default used is RootBundleAssetLoader which uses flutter's assetloader
class RootBundleAssetLoader extends AssetLoader {
  const RootBundleAssetLoader();

  @override
  Future<String> load(String localePath) async {
    return rootBundle.loadString(localePath);
  }
}

//
//
//
//
class StringAssetLoader extends AssetLoader {
  @override
  Future<String> load(String string) {
    return Future.value(string);
  }
}

//
//
//
//
class FileAssetLoader extends AssetLoader {
  @override
  Future<String> load(String localePath) {
    File file = File(localePath);
    return file.readAsString();
  }
}

//
//
//
//
class NetworkAssetLoader extends AssetLoader {
  @override
  Future<String> load(String localePath) async {
    return http.get(localePath).then((response) => response.body.toString());
  }
}

// asset loader to be used when doing integration tests
// default AssetLoader suffers from this issue
// https://github.com/flutter/flutter/issues/44182
class TestsAssetLoader extends AssetLoader {
  @override
  Future<String> load(String localePath) async {
    final ByteData byteData = await rootBundle.load(localePath);
    return utf8.decode(byteData.buffer.asUint8List());
  }
}