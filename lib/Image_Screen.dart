import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

final File _newPhotoDir = File(
    '/storage/emulated/0/media/WhatsApp/Media/.Statuses');
//final Bool checkPathExistence = _newPhotoDir.exists();


class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  Directory? _statusDir;
   void initstate() {
    super.initState();
    ('Directory exists: ${_newPhotoDir.exists()}');
    getExternalStorageDirectory().then((directory) {
      if (directory != null) {
        // Combine the external storage directory with the WhatsApp status path
        _statusDir = Directory('${directory.path}/WhatsApp/Media/.Statuses');
        ('Status Directory: ${_statusDir?.path}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('$_newPhotoDir').existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Install WhatsApp\n',
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    }
    //else {
      //final imageList = _newPhotoDir
          //.map((item) => item.path)
          //.where((item) => item.endsWith('.jpg'))
          //.toList(growable: false);
      // if (imageList.length > 0) {
      //   return Container(
      //     margin: const EdgeInsets.all(8.0),
      //     child: GridView.builder(
      //       key: PageStorageKey(widget.key),
      //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //         maxCrossAxisExtent: 150,
      //       ),
      //       itemCount: imageList.length,
      //       itemBuilder: (BuildContext context, int index) {
      //         final String imgPath = imageList[index];
      //         return Padding(
      //           padding: const EdgeInsets.all(1.0),
      //           child: GestureDetector(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => ViewPhotos(
      //                     imgPath: imgPath,
      //                   ),
      //                 ),
      //               );
      //             },
      //             child: Image.file(
      //               File(imageList[index]),
      //               fit: BoxFit.cover,
      //               filterQuality: FilterQuality.medium,
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   );
      // }
      //else {
        return Scaffold(
          body: Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: const Text(
                'Sorry, No Image Found!',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        );
      //}
    }
  }
//}

class ViewPhotos extends StatelessWidget {
  final String imgPath;

  const ViewPhotos({required this.imgPath, Key? key}) : super(key: key);
  Future<void> _onSharePressed(BuildContext context) async {
    try {
      final bytes = await File(imgPath).readAsBytes();
      await Share.shareFiles(
        [imgPath],
        mimeTypes: ['image/jpeg'], // Adjust this according to your image type
        subject: 'Share Image',
      );
    } catch (e) {
      ('Error sharing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share image'))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.download), // Add the download icon
            onPressed: () => _onSharePressed(context),
          ),
        ],
      ),
      body: Center(
        child: Image.file(
          File(imgPath),
        ),
      ),
    );
  }
}
