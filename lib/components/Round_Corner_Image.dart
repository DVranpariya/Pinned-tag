import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundCornerImage extends StatefulWidget {
  final double height;
  final double width;
  final String image;
  final File fileImage;
  final String placeholder;
  final double circular;

  // BoxFit fit;
  RoundCornerImage(
      {this.height,
      this.width,
      this.image,
      this.fileImage,
      this.circular,
      this.placeholder});

  @override
  _RoundCornerImageState createState() => _RoundCornerImageState();
}

class _RoundCornerImageState extends State<RoundCornerImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.circular),
        child: CachedNetworkImage(
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
          imageUrl: widget.image,
          placeholder: (context, url) => Container(
            child: widget.image != null
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : Container(
                    height: widget.width,
                    width: widget.height,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(circular),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/${widget.placeholder}'),
                      ),
                    ),
                  ),
          ),
          errorWidget: (context, url, error) => Container(
            height: widget.width,
            width: widget.height,
            child: /*widget.fileImage == null
                ?*/
                Image.asset(
              'assets/${widget.placeholder}',
              fit: BoxFit.cover,
            ),
            // : Image.file(widget.fileImage),
            decoration: BoxDecoration(
              /*  color: Color(0xFFdbdbdb),*/
              borderRadius: BorderRadius.circular(widget.circular),
              // image: DecorationImage(
              //   fit: BoxFit.cover,
              //   image: widget.fileImage == null
              //       ? AssetImage(
              //           ('assets/${widget.placeholder}'),
              //         )
              //       : FileImage(widget.fileImage),
              // ),
              /* new Image.asset('assets/test.jpg')*/
            ),
          ),
        ),
      ),
    );
  }
}
