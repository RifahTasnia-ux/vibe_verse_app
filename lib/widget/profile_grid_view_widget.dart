import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredGridWidget extends StatefulWidget {
   const StaggeredGridWidget({super.key,});

  @override
  State<StaggeredGridWidget> createState() => _StaggeredGridWidgetState();
}

class _StaggeredGridWidgetState extends State<StaggeredGridWidget> {
  List<String> linkUrls = [
    'https://fastly.picsum.photos/id/144/640/320.jpg?hmac=uBX_sgWqG8rPzmGxQnbdsc5IMcVZmV4My1OBoSSGWXQ',
    'https://fastly.picsum.photos/id/343/200/200.jpg?hmac=51jfTxjhIC4eQHibl9fcu56Q5VlXZxJLdHsbgsGd_zE',
    'https://fastly.picsum.photos/id/356/200/300.jpg?hmac=pb0ZyD5jAO137vihtNEtssVuagKD77egevbOXVGquy8',
    'https://fastly.picsum.photos/id/123/640/320.jpg?hmac=Wkg5B-YAQs4nnlbPF18SzxoR_TZeWAymxGyFXeCxtPA',
    'https://miro.medium.com/v2/resize:fit:1400/format:webp/1*U4gZLnRtHEeJuc6tdVLwPw.png',
    'https://sample-videos.com/img/Sample-jpg-image-500kb.jpg',
    'https://sample-videos.com/img/Sample-jpg-image-1mb.jpg',
    'https://fastly.picsum.photos/id/866/200/300.jpg?hmac=rcadCENKh4rD6MAp6V_ma-AyWv641M4iiOpe1RyFHeI',
    'https://fastly.picsum.photos/id/202/200/200.jpg?hmac=eGzhW5P2k0gzjc76Tk5T9lOfvn30h3YHuw5jGnBUY4Y',
    'https://fastly.picsum.photos/id/629/200/300.jpg?hmac=YTSnJIQbXgJTOWUeXAqVeQYHZDodXXFFJxd5RTKs7yU',
    'https://fastly.picsum.photos/id/145/200/300.jpg?hmac=mIsOtHDzbaNzDdNRa6aQCd5CHCVewrkTO5B1D4aHMB8',
    'https://fastly.picsum.photos/id/940/200/200.jpg?hmac=bIX4juxj93bHJKYbdztQYmQByF-1mM6YI2ec9UrnrTo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          itemCount: linkUrls.length,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: linkUrls[index],
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  const Tile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Tile $index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
