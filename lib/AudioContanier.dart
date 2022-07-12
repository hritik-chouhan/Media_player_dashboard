
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class playlist extends StatefulWidget {
  const playlist({Key? key}) : super(key: key);

  @override
  _playlistState createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  List mylist = ['song1','song2','song 3', 'song4','song5', 'song6', 'song7','song8'];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(5),

      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.40,
        width: MediaQuery.of(context).size.width*0.35,
        child: ListView.builder(
          itemCount: mylist.length,
            itemBuilder: (context,index){
            return Card(
              color: Colors.white54,
              shadowColor: Colors.greenAccent,
              child: ListTile(
                minVerticalPadding: 5,
                leading: Icon(CupertinoIcons.music_note_2),
                title: Text(mylist[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),),
                subtitle: Text('Artist: unknown'),
              ),
            );

        }),


      ),
    );
  }
}
