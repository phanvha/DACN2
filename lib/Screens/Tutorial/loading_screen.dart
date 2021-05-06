
import 'package:Poro/Components/content_model.dart';
import 'package:Poro/Screens/User/Welcome_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
    // TODO: implement createState
}

class _loadingScreenState extends State<loadingScreen> {
  int currentIndex = 0;
  PageController _controller ;
  @override
  void initState() {
    // TODO: implement initState
    _controller = PageController(initialPage: 0);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
                  controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                },
                itemBuilder: (_, i) {
                    return Padding(
                        padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                            Lottie.asset(
                            contents[i].image,
                            height: 300,
                          ),
                          Text(
                            contents[i].title,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            contents[i].discription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                },
              ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                  (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: FlatButton(
              child: Text(
                currentIndex == contents.length - 1 ? "Continue" : "Next"),
              onPressed: () {
                if(currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WelcomeScreen(),
                      ),
                  );
                }
                _controller.nextPage(
                    duration: Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                );
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
      ),
    );
  }
}
