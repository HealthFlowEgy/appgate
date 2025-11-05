import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final String? imagePlaceholder;
  final double? height;
  final double? width;
  final double? radius;
  final BoxFit? fit;
  final Widget? placeholderWidget;

  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.imagePlaceholder,
    this.height,
    this.width,
    this.radius,
    this.fit,
    this.placeholderWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => radius != null
      ? ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: _cachedImageWidget(),
        )
      : _cachedImageWidget();

  _cachedImageWidget() => imageUrl != null && imageUrl!.isNotEmpty
      ? CachedNetworkImage(
          imageUrl: imageUrl!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.fill,
          errorWidget: (context, img, d) => Image.asset(
            imagePlaceholder != null
                ? imagePlaceholder!
                : "assets/empty_image.png",
            height: height,
            width: width,
            fit: fit ?? BoxFit.fill,
          ),
          placeholder: (context, string) =>
              placeholderWidget ??
              Image.asset(
                imagePlaceholder != null
                    ? imagePlaceholder!
                    : "assets/empty_image.png",
                height: height,
                width: width,
                fit: fit ?? BoxFit.fill,
              ),
        )
      : Image.asset(
          imagePlaceholder != null
              ? imagePlaceholder!
              : "assets/empty_image.png",
          height: height,
          width: width,
          fit: fit ?? BoxFit.fill,
        );
}

class CachedImageProvider extends CachedNetworkImageProvider {
  const CachedImageProvider(String url) : super(url);
}
