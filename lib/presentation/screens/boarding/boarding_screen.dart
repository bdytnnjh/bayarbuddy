import 'package:flutter/material.dart';
import '../set pin/set_pin_screen.dart';

class BoardingScreen extends StatelessWidget {
  BoardingScreen({super.key});

  final PageController controller = PageController();
  final ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  final pages = [
    Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/boarding_1.png',
            fit: BoxFit.cover,
            width: 300,
          ),
          Text(
            'Easy, Fast & Trusted',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Fast money transfer and guaranteed safe transactions with others.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/boarding_2.png',
            fit: BoxFit.cover,
            width: 300,
          ),
          Text(
            'Saving Your Money',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Track the progress of your savings and start a habit of saving with us.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/boarding_3.png',
            fit: BoxFit.cover,
            width: 300,
          ),
          Text(
            'Free Transactions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Provides the quality of the financial system with free money transactions without any fees.',
            textAlign: TextAlign.center,
          ),
        ],
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
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
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
                          width: current == i ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: current == i
                                ? Colors.black87
                                : Colors.black26,
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
                        if (current < pages.length - 1) {
                          controller.animateToPage(
                            current + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        } else {
                          // Navigate to SetPinScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetPinScreen(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        current < pages.length - 1 ? 'Next' : 'Get Started',
                      ),
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
