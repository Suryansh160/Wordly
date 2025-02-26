import 'package:dictionary/services/api_service.dart';
import 'package:dictionary/widgets/tab_control.dart';
import 'package:flutter/material.dart';

class MeaningScreen extends StatelessWidget {
  final String word;
  String noun = "";

  MeaningScreen({super.key, required this.word});

  Future<String?> fetchMeaning() async {
    final response = await ApiService.fetchWordMeaning(word);
    var meaningsList = response![0]["meanings"] as List?;

    if (response != null && response!.isNotEmpty) {
      var phonetics = response[0]["phonetics"];
      noun = meaningsList != null && meaningsList.isNotEmpty
          ? meaningsList
              .firstWhere((meaning) => meaning["partofSpeech"] == "noun")
          : "No noun available";
      if (phonetics != null || phonetics!.isNotEmpty) {
        return phonetics[0]["text"];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Definition"),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          actions: [
            // Padding(padding: EdgeInsets.only(left: 20)),
            IconButton(
              icon: Icon(Icons.favorite_border),
              color: Colors.white,
              onPressed: () {},
            ),

            IconButton(
              icon: Icon(Icons.bookmark_outline_rounded),
              onPressed: () {},
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.065),
                    child: Text(
                      word,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.22),
                    child: Icon(
                      Icons.volume_up_outlined,
                      size: screenWidth * 0.08,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: screenWidth * 0.07),
              child: FutureBuilder<String?>(
                  future: fetchMeaning(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.grey,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error fetching data",
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return Text(
                        snapshot.data ?? "No phonetic available",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      );
                    }
                  }),
            ),
            SizedBox(
              height: screenHeight * 0.055,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabControl(),
            ),
          ],
        ));
  }
}
