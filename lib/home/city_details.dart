import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:travely/components/global_variables.dart';
import 'package:travely/home/map_page.dart';

// Define the CityDetails widget
class CityDetails extends StatefulWidget {
  final country;
  final city;
  final images;
  final description;
  final lat;
  final lng;
  final id;
  final voiceNote;

  // Constructor for CityDetails widget
  const CityDetails({
    Key? key,
    required this.country,
    required this.city,
    required this.images,
    required this.description,
    this.lat,
    this.lng,
    this.id,
    required this.voiceNote,
  }) : super(key: key);

  // Create the state for the CityDetails widget
  @override
  State<CityDetails> createState() => _CityDetailsState();
}

// Define constant URLs for image and audio clips
const secImgUrl = 'https://travelapp.redstonz.com/assets/uploads/place/';
const audioClipsUrl =
    'https://travelapp.redstonz.com/assets/uploads/voice-note/';

// Create the state class for CityDetails widget
class _CityDetailsState extends State<CityDetails> {
  final AudioPlayer _player = AudioPlayer();

  // Dispose method to release resources when the widget is disposed
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Method to rewind audio playback by 10 seconds
  void _fastRewind() {
    _player.seek(_player.position - const Duration(seconds: 10));
  }

  // Method to fast forward audio playback by 10 seconds
  void _fastForward() {
    _player.seek(_player.position + const Duration(seconds: 10));
  }

  // Widget for playback control buttons
  Widget _playBackControlButton() {
    return Row(
      children: [
        StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final processingState = snapshot.data?.processingState;
            final playing = snapshot.data?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    height: screenHeight * 0.04,
                    width: screenWidth * 0.08,
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3.0,
                    ),
                  ),
                ],
              );
            } else if (playing != true) {
              return IconButton(
                  onPressed: _player.play,
                  iconSize: 32,
                  icon: const Icon(Icons.play_arrow));
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                  onPressed: _player.pause,
                  iconSize: 32,
                  icon: const Icon(Icons.pause));
            } else {
              return IconButton(
                onPressed: () => _player.seek(Duration.zero),
                icon: const Icon(Icons.replay),
                iconSize: 32,
              );
            }
          },
        ),
      ],
    );
  }

  // Widget for progress bar to visualize audio playback progress
  Widget _progressBar() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          buffered: _player.bufferedPosition,
          total: _player.duration ?? Duration.zero,
          progressBarColor: Colors.black26,
          bufferedBarColor: Colors.indigo.shade50,
          thumbColor: Colors.indigo.shade200,
          onSeek: (duration) {
            _player.seek(duration);
          },
        );
      },
    );
  }

  // Method to set up audio player and load audio stream
  Future<void> _setupAudioPlayer() async {
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace stackTrace) {
        print('A stream error occurred: $e');
      },
    );
    try {
      _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(audioClipsUrl + widget.voiceNote),
        ),
      );
    } catch (e) {
      print('Error loading audio stream: $e');
    }
  }

  // Initialize audio player setup when the widget is created
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer();
  }

  // Build the UI for the CityDetails widget
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'City Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Image display container
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
          // City details container
          Container(
            margin: EdgeInsets.only(top: screenHeight * 0.33),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: screenHeight * 0.03,
                        left: screenWidth * 0.03,
                      ),
                      child: Expanded(
                        child: Text(
                          (widget.city),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.07,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MapPage(lng: widget.lat, lat: widget.lng,)));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.025),
                            width: screenWidth * 0.06,
                            height: screenHeight * 0.04,
                            child:  Icon(
                              Icons.location_on_sharp,
                              size: screenWidth * 0.06,
                              color: Colors.lightBlue,
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          Container(
                              margin: EdgeInsets.only(top: screenHeight * 0.03),
                              child:  Text(
                                'Get Direction',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,

                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                // Country name text
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.061,
                  ),
                  child: Text(
                    (widget.country),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
                // Description text
                Container(
                  height: screenHeight * 0.4,
                  width: double.maxFinite,
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.04,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      (widget.description),
                      style:  TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black38,
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Audio playback controls container
          Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.72,
            ),
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Voice clip label
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    top: screenHeight * 0.02,
                  ),
                  child: const Text(
                    'Voice clip about the location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Progress bar
                    Container(
                        margin: EdgeInsets.only(
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04),
                        child: _progressBar()
                    ),
                    // Playback control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _fastRewind,
                          icon: const Icon(Icons.fast_rewind_sharp),
                        ),
                        _playBackControlButton(),
                        IconButton(
                          onPressed: _fastForward,
                          icon: const Icon(Icons.fast_forward_sharp),
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
    );
  }
}
