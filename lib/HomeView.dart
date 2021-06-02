
import 'package:flutter/material.dart';
import 'package:karaoke_app/RecordView.dart';
import 'package:karaoke_app/RecordedFileView.dart';

class HomView extends StatefulWidget {
  const HomView() : super();

  @override
  _HomViewState createState() => _HomViewState();
}

class _HomViewState extends State<HomView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Karaoke"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordedFileView()));
            },
            icon: Icon(Icons.list),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 2,
        separatorBuilder: (context, index)=>Divider(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleWidget(),
                _progressBarWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _titleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "Ankha maa aune sapani kaile po pura hunxa ni ankha ",
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordView()));
          },
          child: Text(
            "Use this song",
            style: TextStyle(fontSize: 12, color: Colors.white,),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue)
          ),
        ),
      ],
    );
  }

  Widget _progressBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: 0.3,
            color: Colors.pink,
            backgroundColor: Colors.pink.shade100,
            minHeight: 5,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.play_arrow,
          ),
        ),
      ],
    );
  }
}



