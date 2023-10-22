import 'package:flutter/material.dart';
import 'package:kayak_booking_app/data/dummy_data.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DetailedView extends StatefulWidget {
  final int index;

  const DetailedView({Key? key, required this.index}) : super(key: key);

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  late ValueNotifier<int> currentKayakIndex;
  late ValueNotifier<double> pageValue;
  late PageController pageController;

  @override
  void initState() {
    currentKayakIndex = ValueNotifier(widget.index);
    pageValue = ValueNotifier(widget.index.toDouble());
    pageController = PageController(initialPage: currentKayakIndex.value)
      ..addListener(() {
        pageValue.value = pageController.page ?? 0.0;
      });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              // again this needs to be a stack because Hero widgets cant have hero ancestors
              child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Hero(
                  tag: kayaks[currentKayakIndex.value].color,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: h / 1.5,
                    width: w,
                    decoration: BoxDecoration(
                        color: kayaks[currentKayakIndex.value].color.withOpacity(0.9),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                  ),
                ),
              ),
              Positioned(
                bottom: h * 0.05,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: kayaks[currentKayakIndex.value].name,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(kayaks[currentKayakIndex.value].name,
                              textScaleFactor: 2.0, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      Container(
                        width: w * 0.35,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.remove,
                              color: kayaks[currentKayakIndex.value].color,
                            ),
                            const Text(
                              '1',
                              textScaleFactor: 1.5,
                            ),
                            Icon(
                              Icons.add,
                              color: kayaks[currentKayakIndex.value].color,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              /// everthing above is fine
              /// the problem is in below code
              ///
              /// Quick : See the video from 00:03 to 00:04 where the boats transition
              /// that transition is achieved by the if else condition inside the value listenable builder below
              ///
              Positioned(
                right: 0,
                left: 0,
                bottom: h * 0.25,
                height: h * 0.65,
                child: Center(
                    child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) {
                    setState(() {
                      currentKayakIndex.value = value;
                    });
                  },
                  itemCount: kayaks.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Hero(
                          tag: kayaks[currentKayakIndex.value].image,
                          // Hero flight builder
                          // we use this to modify the hero transition
                          flightShuttleBuilder: (_, animation, flightDirection, ___, ____) {
                            return AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                /// simply we, take the image and undo the rotation by slowlly multiply it with a dimnishing value 1 --> 0.
                                return Transform.rotate(
                                  angle: -.9 * (1 - animation.value),
                                  alignment: Alignment.center,
                                  child: child,
                                );
                              },
                              child: SimpleShadow(
                                opacity: 0.3,
                                color: Colors.black,
                                offset: const Offset(-15, 10),
                                child: Image.asset(
                                  kayaks[currentKayakIndex.value].image,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            );
                          },
                          child: ValueListenableBuilder(
                            valueListenable: pageValue,
                            builder: (context, value, child) {
                              final child = Image.asset(
                                kayaks[index].image,
                                alignment: Alignment.topCenter,
                              );
                              return child;
                            },
                          )),
                    );
                  },
                )),
              )
            ],
          ))
        ],
      ),
    );
  }
}
