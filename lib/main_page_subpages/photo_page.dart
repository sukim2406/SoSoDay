import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/storage_controller.dart';
import '../widgets/log_btn.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
        ),
        FutureBuilder(
          future: StorageController.instance.downloadUrl('give-love.png'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Container(
                  width: 300,
                  height: 250,
                  child: Image.network(snapshot.data!, fit: BoxFit.cover));
            }
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Text('error');
          },
        ),
        FutureBuilder(
          future: StorageController.instance.listFiles(),
          builder: (BuildContext context, AsyncSnapshot<ListResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ElevatedButton(
                        onPressed: () {},
                        child: Text(snapshot.data!.items[index].name),
                      );
                    },
                  ));
            }
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Text('error');
          },
        ),
        GestureDetector(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
                allowMultiple: false,
                type: FileType.custom,
                allowedExtensions: ['png', 'jpg']);

            if (result == null) {
              Get.snackbar('File Picker', 'File message',
                  backgroundColor: Colors.redAccent,
                  snackPosition: SnackPosition.BOTTOM,
                  titleText: const Text(
                    'No file selected',
                    style: TextStyle(color: Colors.white),
                  ));
            }

            final path = result!.files.single.path;
            final fileName = result!.files.single.name;

            print('file picker test');
            print(path);
            print(fileName);

            StorageController.instance
                .uploadFile(path.toString(), fileName)
                .then((value) => print('done'));
          },
          child: LogBtn(
              btnText: 'Upload Image',
              btnWidth: MediaQuery.of(context).size.width * .5,
              btnHeight: MediaQuery.of(context).size.height * .03,
              btnFontSize: 15),
        )
      ],
    );
  }
}
