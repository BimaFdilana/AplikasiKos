// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:kos_tes/view/filter/fasilitas.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/constractor.dart';

class FasilitasKosFilter extends StatefulWidget {
  const FasilitasKosFilter({super.key});

  @override
  State<FasilitasKosFilter> createState() => _FasilitasKosFilterState();
}

class _FasilitasKosFilterState extends State<FasilitasKosFilter> {
  List<String> pilihFkos = [];
  List<String> pilihFkeaman = [];
  List<String> pilihFumum = [];

  Future<void> saveFasilitas() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('pilihFkos', pilihFkos);
    await preferences.setStringList('pilihFkeaman', pilihFkeaman);
    await preferences.setStringList('pilihFumum', pilihFumum);

    String pilihFkosString = pilihFkos.join(',');
    String pilihFkeamanString = pilihFkeaman.join(',');
    String pilihFumumString = pilihFumum.join(',');

    print('pilihFkosString: $pilihFkosString');
    print('pilihFkeamanString: $pilihFkeamanString');
    print('pilihFumumString: $pilihFumumString');
  }

  void updateSelectedValue(
      String value, bool checked, List<String> selectedList) {
    setState(() {
      if (checked) {
        selectedList.add(value);
      } else {
        selectedList.remove(value);
      }
    });
  }

  void onSubmit() {
    saveFasilitas();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FasilitasCategory()));
    // print('$pilihFkos,$pilihFkeaman,$pilihFumum');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Fasilitas kos'),
        backgroundColor: MyColors.khijau0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Fasilitas Kamar',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('lemari'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('lemari', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Lemari'),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('kasur'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('kasur', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Kasur'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('bantal'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('bantal', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Bantal'),
                    ],
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('kamar mandi didalam'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue(
                                'kamar mandi didalam', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Kamar mandi didalam'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('meja'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('meja', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Meja'),
                    ],
                  ),
                  const SizedBox(
                    width: 23,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkos.contains('kipas angin'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue(
                                'kipas angin', value!, pilihFkos);
                          });
                        },
                      ),
                      const Text('Kipas angin'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Fasilitas Keamanan',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkeaman.contains('CCTV'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('CCTV', value!, pilihFkeaman);
                          });
                        },
                      ),
                      const Text('CCTV'),
                    ],
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkeaman.contains('trali'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('trali', value!, pilihFkeaman);
                          });
                        },
                      ),
                      const Text('Trali'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFkeaman.contains('pagar'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('pagar', value!, pilihFkeaman);
                          });
                        },
                      ),
                      const Text('Pagar'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Fasilitas Umum',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFumum.contains('wifi'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('wifi', value!, pilihFumum);
                          });
                        },
                      ),
                      const Text('Wifi'),
                    ],
                  ),
                  const SizedBox(
                    width: 29,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFumum.contains('pengurus kos'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue(
                                'pengurus kos', value!, pilihFumum);
                          });
                        },
                      ),
                      const Text('Pengurus kos'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFumum.contains('jemuran'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('jemuran', value!, pilihFumum);
                          });
                        },
                      ),
                      const Text('Jemuran'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFumum.contains('parkir motor'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue(
                                'parkir motor', value!, pilihFumum);
                          });
                        },
                      ),
                      const Text('Parkir motor'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        checkColor: MyColors.kputih,
                        value: pilihFumum.contains('dapur'),
                        onChanged: (value) {
                          setState(() {
                            updateSelectedValue('dapur', value!, pilihFumum);
                          });
                        },
                      ),
                      const Text('Dapur'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  width: constraints.maxWidth,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            MyColors.khijau0,
                            MyColors.khijau1,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Cari kos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
