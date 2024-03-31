import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String fromCurrency;
  late String toCurrency;
  late Map<String, dynamic> conversionRates =
      {}; // Initialize conversionRates here
  double amountToConvert = 0.0;
  double convertedAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fromCurrency = 'TRY';
    toCurrency = 'AZN';
    fetchConversionRates();
  }

  Future<void> fetchConversionRates() async {
    final url =
        'https://api.currencyapi.com/v3/latest?apikey=cur_live_29vYXuY1Ms2aiiMARRQGRcRBGtqquaTY3pKyDoWz';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        conversionRates = responseData['data'];
      });
    } else {
      throw Exception('Failed to load conversion rates');
    }
  }

  void convertCurrency() {
    if (amountToConvert <= 0) {
      // Handle invalid input
      return;
    }
    double rate = conversionRates[toCurrency]["value"] /
        conversionRates[fromCurrency]["value"];

    setState(() {
      convertedAmount = amountToConvert * rate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'Currency Converter',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Check live rates, set rate alerts, receive notifications and more',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 365,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // White background for the container
                borderRadius:
                    BorderRadius.circular(12), // Adjust border radius as needed
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: 170,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .transparent), // Set to transparent
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                amountToConvert = double.tryParse(value) ?? 0.0;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: 110,
                        child: DropdownButton<String>(
                          // Dropdown for selecting second currency
                          items:
                              conversionRates.keys.toList().map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/${value.toLowerCase()}.png',
                                    width: 20,
                                  ),
                                  Text(
                                    ' $value',
                                    style: TextStyle(
                                      fontSize:
                                          16, // Adjust the font size as needed
                                      color:
                                          Colors.black, // Change the text color
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              fromCurrency = newValue!;
                            });
                          },
                          value: fromCurrency, // Initial value
                          underline: Container(
                            // Customizes the underline
                            height: 2,
                            color: Colors.blue, // Change the underline color
                          ),
                          icon: const Icon(Icons
                              .arrow_drop_down), // Customizes the dropdown icon
                          iconSize: 36, // Adjust the icon size as needed
                          elevation: 8, // Adjust the dropdown elevation
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 15,
                          endIndent: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          'assets/images/arrows.png', // Replace this with the path to your image
                          width: 30, // Adjust the width of the image as needed
                          height:
                              35, // Adjust the height of the image as needed
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          indent: 15,
                          endIndent: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Converted Amount',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: 170,
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .transparent), // Set to transparent
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                convertedAmount = double.tryParse(value) ?? 0.0;
                              });
                            },
                            controller: TextEditingController(
                                text: convertedAmount.toStringAsFixed(2)),
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        // Dropdown for selecting second currency
                        items:
                            conversionRates.keys.toList().map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/${value.toLowerCase()}.png',
                                  width: 20,
                                ),
                                Text(
                                  ' $value',
                                  style: TextStyle(
                                    fontSize:
                                        16, // Adjust the font size as needed
                                    color:
                                        Colors.black, // Change the text color
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            toCurrency = newValue!;
                          });
                        },
                        value: toCurrency, // Initial value
                        underline: Container(
                          // Customizes the underline
                          height: 2,
                          color: Colors.blue, // Change the underline color
                        ),
                        icon: Icon(Icons
                            .arrow_drop_down), // Customizes the dropdown icon
                        iconSize: 36, // Adjust the icon size as needed
                        elevation: 8, // Adjust the dropdown elevation
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed:
                        convertCurrency, // Call convertCurrency() when button is pressed
                    child: Text(
                      'Convert',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue.shade800,
                      ), // Set button color
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6.0), // Set border radius
                          // You can add other properties such as border color, border width, etc. here
                        ),
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
