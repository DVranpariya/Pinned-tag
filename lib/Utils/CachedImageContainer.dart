import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageContainer extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final File fileImage;
  final String placeholder;
  final double circular;
  final BoxFit fit;
  final double topCorner;
  final double bottomCorner;

  CachedImageContainer({
    this.height,
    this.width,
    this.image,
    this.fileImage,
    this.circular,
    this.placeholder,
    this.fit,
    this.topCorner,
    this.bottomCorner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: CachedNetworkImage(
          width: width,
          height: height,
          fit: fit,
          imageUrl: image ?? '',
          placeholder: (context, url) => Container(
            color: Colors.white,
            child: image != null
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : Container(
                    height: width,
                    width: height,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(circular),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(placeholder),
                      ),
                    ),
                  ),
          ),
          errorWidget: (context, url, error) => Container(
            height: width,
            width: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circular),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(placeholder),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
