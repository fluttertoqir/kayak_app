import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kayak_booking_app/data/dummy_data.dart';
import 'package:simple_shadow/simple_shadow.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  late PageController pageController;

  double currentPage = 0;
  double previousPage = 0;
  bool isUpScroll = true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 0.5)
      ..addListener(() {
        setState(() {
          currentPage = pageController.page!;
          previousPage < currentPage ? isUpScroll = true : isUpScroll = false;
          previousPage = currentPage;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu_rounded, color: Colors.black),
        actions: const [Icon(Icons.person_outline, color: Colors.black)],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: const Text(
                "Rent a boat",
                textScaleFactor: 2.8,
                style: TextStyle(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              ),
            ),
            SizedBox(
              height: 65,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: const TextStyle(),
                      focusColor: Colors.black,
                      focusedBorder: _border(Colors.black, 3),
                      border: _border(Colors.grey.withOpacity(0.05), 1),
                      hintText: 'Search',
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 5),
                        child: Icon(Icons.search),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: PageView.builder(
                controller: pageController,
                itemCount: kayaks.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padEnds: false,
                itemBuilder: (context, index) {
                  double enterExitAngle = (currentPage - index).abs();
                  double scrollingAngle = (currentPage - index).abs();

                  if (scrollingAngle > 0.5) {
                    scrollingAngle = 1 - scrollingAngle;
                  }

                  Matrix4 extryExitMatrix = Matrix4.identity()
                    ..setEntry(3, 2, 0.0001)
                    ..rotateX(-enterExitAngle * 1.5);

                  Matrix4 scrollingMatrix = Matrix4.identity()
                    ..setEntry(
                      3,
                      2,
                      0.001,
                    )
                    ..rotateX(isUpScroll ? scrollingAngle : -scrollingAngle);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    padding: const EdgeInsets.only(
                      right: 2,
                      left: 2,
                      top: 2,
                      bottom: 2,
                    ),
                    // transform: currentPage < index ? Matrix4.identity() : myMatrix,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: currentPage < index ? scrollingMatrix : extryExitMatrix,
                      child: Opacity(
                        opacity: currentPage < index ? 1 : 1 - enterExitAngle,
                        child: OpenContainer(
                            openElevation: 0,
                            closedBuilder: (_, openContainer) {
                              return KayakItem(
                                index: index,
                                onClick: openContainer,
                              );
                            },
                            closedElevation: 5.0,
                            transitionDuration: const Duration(seconds: 1),
                            closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            openBuilder: (_, closeContainer) {
                              return DetailPage(
                                index: index,
                                tag: 'kayakName$index',
                                color: kayaks[index].color.withOpacity(0.7),
                              );
                            }),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
      borderSide: BorderSide(width: width, color: color),
      borderRadius: BorderRadius.circular(6),
    );

class KayakItem extends StatefulWidget {
  final int index;
  final Function onClick;

  const KayakItem({Key? key, required this.index, required this.onClick}) : super(key: key);

  @override
  State<KayakItem> createState() => _KayakItemState();
}

class _KayakItemState extends State<KayakItem> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    _controller1 = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => widget.onClick,
      child: Stack(alignment: Alignment.topCenter, children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: h * 0.20,
            decoration: BoxDecoration(
                color: kayaks[widget.index].color.withOpacity(0.7),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.arrow_forward, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(kayaks[widget.index].name, textScaleFactor: 2.0, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -30,
          right: w * 0.25,
          height: h * 0.30,
          child: Transform.rotate(
            angle: pi * -1.3,
            child: SimpleShadow(
              opacity: 0.3,
              color: Colors.black,
              offset: const Offset(15, -10),
              child: Hero(
                tag: 'kayakName${widget.index}',
                child: Image.asset(
                  kayaks[widget.index].image,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class DetailPage extends StatelessWidget {
  final int index;
  final String tag;
  final Color color;

  const DetailPage({
    Key? key,
    required this.index,
    required this.tag,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          bottom: 0,
          child: Container(
              height: h * 0.7,
              width: w,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
              child: Container()),
        ),
        Positioned(
          top: 0,
          child: Hero(
            tag: tag,
            transitionOnUserGestures: true,
            child: Image.asset(
              kayaks[index].image,
              height: 450,
              width: 180,
            ),
          ),
        ),
      ],
    );
  }
}
