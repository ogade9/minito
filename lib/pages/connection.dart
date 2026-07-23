import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
} 

class _ConnectionState extends State<Connection>{
  final _robot = TextEditingController();

  Future<void> dummy() async{
    print("null state");
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
       appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Robot Connection",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Robot Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFFE8F0FE),
                    child: Icon(
                      Icons.smart_toy,
                      size: 40,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Minito Robot",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Ready to connect",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Connection Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "wifi",
                  child: Text("Wi-Fi"),
                ),
                DropdownMenuItem(
                  value: "bluetooth",
                  child: Text("Bluetooth"),
                ),
                DropdownMenuItem(
                  value: "ros",
                  child: Text("ROS Network"),
                ),
              ],
              onChanged: (_) {},
            ),

            const SizedBox(height: 30),

            const Text(
              "Connection Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 14,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Not Connected",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const Spacer(),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search),
              label: const Text("Scan for Robots"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.link),
              label: const Text("Connect"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}