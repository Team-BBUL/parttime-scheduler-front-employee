import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../view/enum/image_type.dart';
import '../view_model/announcement_view_model.dart';

class ImageHero extends StatelessWidget {
  const ImageHero({super.key, required this.image, required this.type,});
  final image;
  final ImageType type;
  Widget build(BuildContext context) {
    return Consumer<AnnouncementViewModel>(
        builder: (context, viewModel,child){
          return SafeArea(
            child: GestureDetector(
              child: Center(
                child: Hero(
                  tag: 'imageHero',
                  child:
                  type == ImageType.MEMORY ?
                  Image.memory(image)
                      :
                  Image.file(File(image)
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              onDoubleTap: () {

              },
            ),
          );
        });
  }
}