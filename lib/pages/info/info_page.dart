import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:feedbackapp/apps/routes/router_name.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            // Nền của trang
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(
                174,
                190,
                192,
                194,
              ), // Đặt màu nền của trang
            ),
            // Hình chữ nhật không có hiệu ứng làm mờ
            Center(
              child: Container(
                width: 702,
                height: 395,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 255, 255, 255),
                      blurRadius: 1,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(40, 60, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoText('Thông tin cơ bản', fontSize: 24, height: 0.05),
                      InfoText('Một số thông tin về showroom, bộ phận',
                          fontSize: 16, height: 0.12),
                      Line1(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          InfoText('Showroom', fontSize: 16, height: 1.6),
                          SizedBox(width: 0), // Điều chỉnh theo nhu cầu
                          ListboxComponentShowroom(),
                        ],
                      ),
                      SizedBox(height: 10),
                      Line1(),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          InfoText('Bộ phận', fontSize: 16, height: 1.6),
                          SizedBox(width: 0), // Điều chỉnh theo nhu cầu
                          ListboxComponentPart(),
                        ],
                      ),
                      SizedBox(height: 70),        
                      // Nút Lưu, thống kê
                      Row(
                        children: [
                          StatisticButton(),
                          SizedBox(width: 450),
                          SaveButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataProvider extends ChangeNotifier {
  String _selectedShowroom = 'HAI BÀ TRƯNG';
  String _selectedPart = 'Bảo hành';

  String get selectedShowroom => _selectedShowroom;

  String get selectedPart => _selectedPart;

  void updateShowroom(String value) {
    _selectedShowroom = value;
    notifyListeners();
  }

  void updatePart(String value) {
    _selectedPart = value;
    notifyListeners();
  }
}

class ListboxComponentShowroom extends StatelessWidget {
  const ListboxComponentShowroom({super.key});

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 170,
          height: 50,
          child: DropdownButton<String>(
            value: dataProvider.selectedShowroom,
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            onChanged: (String? newValue) {
              dataProvider.updateShowroom(newValue!);
            },
            items: <String>[
              'HAI BÀ TRƯNG',
              'ĐỐNG ĐA',
              'HẢI PHÒNG',
              'CẦU GIẤY',
              'HÀ ĐÔNG 1',
              'HÀ ĐÔNG 2',
              'LONG BIÊN',
              'TỪ SƠN',
              'THANH TRÌ',
              'ĐÔNG ANH',
              'BẮC GIANG',
              'PHỦ LÝ',
              'VINH',
              'THANH HÓA',
              'THÁI NGUYÊN',
              'Q3, TP. HỒ CHÍ MINH',
              'Q7, TP. HỒ CHÍ MINH'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ListboxComponentPart extends StatelessWidget {
  const ListboxComponentPart({super.key});

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    return SizedBox(
      width: 170,
      height: 50,
      child: DropdownButton<String>(
        value: dataProvider.selectedPart,
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        onChanged: (String? newValue) {
          dataProvider.updatePart(newValue!);
        },
        items: <String>['Bảo hành', 'Bán hàng                     ']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    return ElevatedButton(
      onPressed: () {
        String selectedPart = dataProvider.selectedPart;
        String selectedShowroom = dataProvider.selectedShowroom;
        // ignore: avoid_print
        print('Selected Showroom: $selectedShowroom');
        // ignore: avoid_print
        print('Selected Part: $selectedPart');

        // Điều hướng đến trang FeedbackPage và truyền các giá trị đã chọn

        context.goNamed(
          RoutersName.feedbackName,
          extra: {
            'selectedPart': selectedPart,
            'selectedShowroom': selectedShowroom,
          },
        );
      },
      child: const Text('Lưu'),
    );
  }
}

class StatisticButton extends StatelessWidget {
  const StatisticButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.goNamed(
          RoutersName.statisticName,
        );
      },
      child: const Text('Thống kê'),
    );
  }
}

class InfoText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double height;

  const InfoText(this.text,
      {Key? key, required this.fontSize, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: fontSize + 15,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          height: height,
          letterSpacing: -0.40,
        ),
      ),
    );
  }
}

class Line1 extends StatelessWidget {
  const Line1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 623,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
