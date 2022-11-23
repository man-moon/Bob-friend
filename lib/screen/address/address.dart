import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소 검색'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      callback: (Kpostal result) {
                        debugPrint(result.address);
                        // setState(() {
                        //   this.postCode = result.postCode;
                        //   this.address = result.address;
                        //   this.latitude = result.latitude.toString();
                        //   this.longitude = result.longitude.toString();
                        //   this.kakaoLatitude = result.kakaoLatitude.toString();
                        //   this.kakaoLongitude =
                        //       result.kakaoLongitude.toString();
                        // });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue)),
              child: Text(
                'Search Address',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(40.0),
            //   child: Column(
            //     children: [
            //       Text('postCode',
            //           style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text('result: ${this.postCode}'),
            //       Text('address',
            //           style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text('result: ${this.address}'),
            //       Text('LatLng', style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text(
            //           'latitude: ${this.latitude} / longitude: ${this.longitude}'),
            //       Text('through KAKAO Geocoder',
            //           style: TextStyle(fontWeight: FontWeight.bold)),
            //       Text(
            //           'latitude: ${this.kakaoLatitude} / longitude: ${this.kakaoLongitude}'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
