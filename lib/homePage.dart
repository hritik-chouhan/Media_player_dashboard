
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:media_player_3/AudioContanier.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  late Timer timer;
  late VideoPlayerValue value;
  bool islooping = false;
  double volume = 0.3;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'music.mp3')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});

      });
    _controller.addListener(() {
      _streamPosController.sink.add(_controller.value.position);

    });
     value = VideoPlayerValue(duration: _controller.value.duration);
    // updatePos();

  }
  final StreamController _streamPosController = StreamController();

  // updatePos() async{
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     // print('check position');
  //     _streamPosController.sink.add(_controller.value.position);
  //     // _streamPosController.sink.addStream(_controller.value);
  //
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return MaterialApp(
      title: 'Media player',
      home: Scaffold(
        body: Stack(

          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.blueGrey,
              ),
            ),
            Positioned(
              top: 30,
                left: 30,
                child: Text('Media Player',style: TextStyle(
                  color: Colors.greenAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),)),
            //playlist
            Positioned(
              top: 150,
              right: 280,
              child: Row(
              children: [
                Icon(CupertinoIcons.music_note_list,
                size: 25,
                color: Colors.greenAccent,),
                SizedBox(width: 20,),
                Text('PlayList',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),)
              ],
            ),),
            Positioned(
                right: 40,
                top: 200,
                child: playlist()),
            Positioned(
              left : 100,
                top: 200,
                right: 550,
                // bottom: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                    // width: 300,
                    // height: 200,
                    //   decoration : BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          image: AssetImage(
                              'music_img.webp'),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Song 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),),
                        SizedBox(width: 20,),
                        Text(_controller.value.duration.toString().substring(2,7),
                        style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold),),

                      ],
                    ),

                  ],
                )),
            Positioned(
              top: 0,
              left: 300,
              child: Container(
                color: Colors.blueGrey,
                height: 100,
                width: 100,


                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Text(''),

              ),
            ),

            Positioned(
              left: 30,
              top: 300,
              child: Column(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: Slider(value: volume,
                        min: 0,
                        max: 1,
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.black,
                        thumbColor: Colors.white54,
                        onChanged: (value){
                      setState(() {
                        volume = value;
                        _controller.setVolume(value);

                      });

                    }),
                  ),
                  // SizedBox(height: 4,),
                  Icon(CupertinoIcons.volume_up),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 8,
              right: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: VideoProgressIndicator(_controller, allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.greenAccent,
                        backgroundColor: Colors.white54,
                        bufferedColor: Colors.black,
                      ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children : [
                          Icon(CupertinoIcons.music_note_2,
                          color: Colors.white54,
                          size: 30,),
                          SizedBox(width: 10,),
                          const Text('Song 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),),

                        ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          IconButton(onPressed: (){}, icon: const Icon(
                              Icons.skip_previous
                          )),
                          const SizedBox(
                            width: 10,
                          ),

                          IconButton(onPressed: (){
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          }, icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                            iconSize: 40,
                          ),
                          const SizedBox(width: 10,),
                          IconButton(onPressed: (){}, icon: const Icon(
                            Icons.skip_next,
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          StreamBuilder(
                              stream: _streamPosController.stream,
                              builder:(context,snapshot){
                                if(snapshot.hasError){
                                  return Text('0 hello');
                                }
                                else if(snapshot.connectionState == ConnectionState.waiting){
                                  return Text('waiting');
                                }
                                else{
                                  return Text(snapshot.data.toString().substring(2,7));
                                }

                              }),
                          Text('/'),
                          Text(_controller.value.duration.toString().substring(2,7)),
                          SizedBox(width: 10,),
                          IconButton(onPressed: (){

                            if(islooping == false){
                              _controller.setLooping(true);
                              islooping = true;

                            }
                            else{
                              _controller.setLooping(false);
                              islooping = false;
                            }
                          }, icon: islooping ?  Icon(CupertinoIcons.loop,
                            color: Colors.greenAccent,):Icon(CupertinoIcons.loop),
                            tooltip: 'play song on loop',
                          ),



                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),



          ],

        ),

      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    timer.cancel();
  }
}