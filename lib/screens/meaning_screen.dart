import 'package:dictionary/services/api_service.dart';
import 'package:flutter/material.dart';

class MeaningScreen extends StatelessWidget {
  final String word;

  MeaningScreen({super.key, required this.word});

  Future<List<String?>> fetchMeaning() async {
    final response = await ApiService.fetchWordMeaning(word);
    if (response == null || response.isEmpty) {
      return [
        null,
        "No noun available",
        "No verb available",
        "No synonyms available"
      ];
    }

    var meaningsList = response[0]["meanings"] as List?;
    String nounDefinition = "No noun available";
    String verbDefinition = "No verb available";
    List<String> nounSyno = [];

    if (meaningsList != null && meaningsList.isNotEmpty) {
      // Extract Noun Meaning
      var nounMeaning = meaningsList.firstWhere(
        (meaning) => meaning["partOfSpeech"] == "noun",
        orElse: () => {},
      );

      if (nounMeaning.isNotEmpty && nounMeaning.containsKey("definitions")) {
        var definitions = nounMeaning["definitions"] as List?;
        if (definitions != null && definitions.isNotEmpty) {
          nounDefinition = definitions[0]["definition"] ?? "No noun available";
          if (definitions[0].containsKey("synonyms")) {
            nounSyno.addAll(List<String>.from(definitions[0]["synonyms"]));
          }
        }
      }

      // Extract Verb Meaning
      var verbMeaning = meaningsList.firstWhere(
        (meaning) => meaning["partOfSpeech"] == "verb",
        orElse: () => {},
      );

      if (verbMeaning.isNotEmpty && verbMeaning.containsKey("definitions")) {
        var definitions = verbMeaning["definitions"] as List?;
        if (definitions != null && definitions.isNotEmpty) {
          verbDefinition = definitions[0]["definition"] ?? "No verb available";
        }
      }
    }

    // Extract Phonetics
    var phonetics = response[0]["phonetics"] as List?;
    String? phoneticText;
    if (phonetics != null && phonetics.isNotEmpty) {
      phoneticText = phonetics[0]["text"];
    }

    // Convert nounSyno to a string (comma-separated)
    String synonymsText =
        nounSyno.isNotEmpty ? nounSyno.join(", ") : "No synonyms available";

    return [phoneticText, nounDefinition, verbDefinition, synonymsText];
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
          IconButton(
            icon: Icon(Icons.favorite_border),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.bookmark_outline_rounded),
            onPressed: () {},
          ),
          SizedBox(width: 10),
        ],
      ),
      body: FutureBuilder<List<String?>>(
        future: fetchMeaning(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.grey,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching data",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          String phonetic = snapshot.data![0] ?? "No phonetic available";
          String noun = snapshot.data![1] ?? "No noun available";
          String verb = snapshot.data![2] ?? "No verb available";
          String nounSyno = snapshot.data![3] ?? "";

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      word,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.volume_up_outlined,
                      size: screenWidth * 0.08,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  phonetic,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Noun',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  noun,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  'Verb',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  verb,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  'Synonyms',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  nounSyno
                      .split(", ")
                      .asMap()
                      .entries
                      .map((entry) => "${entry.key + 1}. ${entry.value}")
                      .join("\n"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
