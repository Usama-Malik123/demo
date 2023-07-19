import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StatusVideo extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final String videoSrc;
  final double? aspectRatio;

  const StatusVideo({
    required this.videoPlayerController,
    this.looping = false,
    required this.videoSrc,
    this.aspectRatio,
    Key? key,
  }) : super(key: key);

  @override
  _StatusVideoState createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  @override
  void initState() {
    super.initState();
    widget.videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0),
      child: Hero(
        tag: widget.videoSrc,
        child: VideoPlayer(widget.videoPlayerController),
      ),
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    super.dispose();
  }
}

class PlayStatus extends StatefulWidget {
  final String videoFile;
  const PlayStatus({
    Key? key,
    required this.videoFile,
  }) : super(key: key);
  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  bool _isLoading = false;
  String _loadingMessage = '';

  void _onLoading(bool isLoading, String message) {
    setState(() {
      _isLoading = isLoading;
      _loadingMessage = message;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Great, Saved in Gallery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _loadingMessage,
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'FileManager > wa_status_saver',
                style: TextStyle(fontSize: 16.0, color: Colors.teal),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveVideoToGallery() async {
    _onLoading(true, '');

    final originalVideoFile = File(widget.videoFile);
    final saveDirectory = Directory('/storage/emulated/0/wa_status_saver');
    if (!saveDirectory.existsSync()) {
      saveDirectory.createSync(recursive: true);
    }

    final currentDate = DateTime.now().toString();
    final newFileName =
        '/storage/emulated/0/wa_status_saver/VIDEO-$currentDate.mp4';

    try {
      await originalVideoFile.copy(newFileName);
      _onLoading(
        false,
        'If Video is not available in the gallery,\n\nYou can find all videos at',
      );
    } catch (e) {
      _onLoading(false, 'Failed to save the video.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StatusVideo(
        videoPlayerController: VideoPlayerController.file(File(widget.videoFile)),
        looping: true,
        videoSrc: widget.videoFile,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.save),
        onPressed: _saveVideoToGallery,
      ),
    );
  }
}
