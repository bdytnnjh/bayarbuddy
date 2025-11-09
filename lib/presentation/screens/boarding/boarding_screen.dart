import 'package:flutter/material.dart';

class BoardingScreen extends StatelessWidget{
  BoardingScreen({super.key});

  final PageController controller = PageController();
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  final pages = [
    Container(
      color: Colors.blueAccent,
      child: const Center(
        child: Text(
          'Welcome',
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),

        ),
      ),
    ),
    Container(
      color: Colors.deepPurpleAccent,
      child: const Center(
        child: Text('Discover Features', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    ),
    Container(
      color: Colors.teal,
      child: const Center(
        child: Text('Get Started', style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                onPageChanged: (index) => pageIndex.value = index,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      controller.animateToPage(
                        pages.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                        );
                        Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text('Skip'),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<int>(
                    valueListenable: pageIndex,
                    builder: (context, current, _) => Row(
                      children: List.generate(
                        pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: current == i ? 20:8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: current == i ? Colors.black87 : Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<int>(
                    valueListenable: pageIndex,
                    builder: (context, current, _) => ElevatedButton(
                      onPressed: () {
                        if (current < pages.length -1) {
                          controller.animateToPage(
                            current + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                            );
                        } else {
                          //last page action
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: Text(current < pages.length - 1 ? 'Next' : 'Get Started'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}