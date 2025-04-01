import 'package:flutter/material.dart';
import 'package:safe/data/emergency_list.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key});

  // void makeCall(String number) {
  //   FlutterPhoneDirectCaller.callNumber(number);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 260,
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Emergency'),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: emergencyList.length,
                itemBuilder: (ctx, index) {
                  final emergency = emergencyList[index];
                  return InkWell(
                    // onTap: () => makeCall(emergency.number),
                    onTap: (){},
                    child: EmergencyItem(emergency: emergency),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyItem extends StatelessWidget {
  final emergency;

  const EmergencyItem({super.key, required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf56ca6),
              Color(0xFFebadff),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(emergency.avtar),
                ),
                const SizedBox(width: 10),
                Text(
                  emergency.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              emergency.info,
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // onPressed: () =>
              //     FlutterPhoneDirectCaller.callNumber(emergency.number),
              onPressed: () {},
              child: Text(
                emergency.number,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
