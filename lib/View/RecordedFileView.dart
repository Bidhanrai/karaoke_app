import 'dart:io';

import 'package:flutter/material.dart';
import 'package:karaoke_app/View/VideoView.dart';
import 'package:path_provider/path_provider.dart';

class RecordedFileView extends StatefulWidget {
  const RecordedFileView() : super();

  @override
  _RecordedFileViewState createState() => _RecordedFileViewState();
}

class _RecordedFileViewState extends State<RecordedFileView> {

  var files = <FileSystemEntity>[];
  String? tempPath;

  @override
  void initState() {
    super.initState();
    getFiles();
  }

  getFiles() async {
    Directory tempDir = await getApplicationDocumentsDirectory();
    tempPath = tempDir.path;
    Directory _dir = Directory(tempPath!+"/camera/videos/");
    if(!_dir.existsSync()){
      await Directory(tempPath!+"/camera/videos/").create();
    }
    files = Directory(tempPath!+"/camera/videos/").listSync();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "Delete All",
            onPressed: () async{
              await Directory(tempPath!+"/camera/videos/").delete(recursive: true);
              setState(() {
                files = [];
              });
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: files.isEmpty
          ? Center(
              child: Text("No Recordings!!"),
            )
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VideoView(videoFilePath: files[index].path)));
                  },
                  title: Text("${index + 1} ${files[index].path}"),
                );
              },
            ),
    );
  }
}
