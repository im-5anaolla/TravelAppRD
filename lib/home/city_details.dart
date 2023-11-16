import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum AudioSourceOption { Network, Asset}
class CityDetails extends StatefulWidget {
  final country;
  final city;
  final images;
  final description;
  final lat;
  final lng;
  final id;

  const CityDetails(
      {super.key,
      required this.country,
      required this.city,
      required this.images,
      required this.description,
      this.lat,
      this.lng,
      this.id});

  @override
  State<CityDetails> createState() => _CityDetailsState();
}

const secImgUrl = 'https://travelapp.redstonz.com/assets/uploads/place/';

class _CityDetailsState extends State<CityDetails> {
  Widget _sourceSelect(){
    return Row(
      children: [
        MaterialButton(
          color: Colors.blue, onPressed: () { _setupAudioPlayer(AudioSourceOption.Network); },
          child: Text("Network"),
        ),
        MaterialButton(
          color: Colors.blue, onPressed: () { _setupAudioPlayer(AudioSourceOption.Asset); },
          child: Text("Asset"),
        )
      ],
    );
  }

  Widget _controllButtons(){
    return Column(
      children: [
        StreamBuilder(stream: _player.speedStream, builder: (context, snapshot){
         return Row(
            children: [
              Icon(Icons.speed),
              Slider(
                  min: 1,
                  max: 3,
                  divisions: 3,
                  value: snapshot.data ?? 1,
                  onChanged: (value) async {
                await _player.setSpeed(value);
              })
              
            ],
          );
        }),
        StreamBuilder(stream: _player.volumeStream, builder: (context, snapshot){
          return Row(
            children: [
              Icon(Icons.volume_up),
              Slider(
                  min: 0,
                  max: 3,
                  divisions: 4,
                  value: snapshot.data ?? 1,
                  onChanged: (value) async {
                    await _player.setVolume(value);
                  })

            ],
          );
        })
      ],
    );
  }

  Widget _playBackControllButton() {
    return StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final processingState = snapshot.data?.processingState;
          final playing = snapshot.data?.playing;
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            return Container(
              margin: EdgeInsets.all(8.0),
              height: 64,
              width: 64,
              child: CircularProgressIndicator(),
            );
          } else if (playing != true) {
            return IconButton(
                onPressed: _player.play,
                iconSize: 64,
                icon: Icon(Icons.play_arrow));
          } else if (processingState != ProcessingState.completed) {
            return IconButton(
                onPressed: _player.pause,
                iconSize: 64,
                icon: Icon(Icons.pause));
          } else {
            return IconButton(
              onPressed: () => _player.seek(Duration.zero),
              icon: Icon(Icons.replay),
              iconSize: 64,
            );
          }
        });
  }

  Widget _progressBar(){
    return StreamBuilder<Duration?>(stream: _player.positionStream, builder: (context, snapshot){
      return ProgressBar(progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero, onSeek: (duration){
        _player.seek(duration);
        },);
    });
  }

  final _player = AudioPlayer();

  Future<void> _setupAudioPlayer(AudioSourceOption option) async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occured: $e');
    });
    try {
      if(option == AudioSourceOption.Network){
        _player.setAudioSource(AudioSource.uri(
            Uri.parse('https://orangefreesounds.com/sadness-sound/')));
      }else if(option == AudioSourceOption.Asset){
        _player.setAudioSource(AudioSource.asset("assets/soundClips/hood.mp3"));
      }
    } catch (e) {
      print('Error loading audio stream: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer(AudioSourceOption.Network);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Details'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              secImgUrl + widget.images![0],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrac) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Container(
                      width: screenWidth,
                      child: Image.asset(
                        'assets/images/imgNotFound.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 270),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 15,
                  ),
                  child: Text(
                    (widget.city),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    (widget.country),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (widget.description),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 430),
            height: 220,
            width: screenWidth,
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Voice clip about the location',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                    ),
                  ),
                ),
                Container(
                  height: 140,
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    children: [
                      _sourceSelect(),
                      _progressBar(),
                      Row(
                        children: [
                          _controllButtons(),
                          _playBackControllButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


