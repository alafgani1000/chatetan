import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/investasi_page.dart';
import 'package:chatetan_duit/screen/utang_page.dart';
import 'package:chatetan_duit/widgets/announcement.dart';
import 'package:chatetan_duit/widgets/header.dart';
import 'package:chatetan_duit/widgets/weight_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbProfile dbProfile = DbProfile();
  List<Profil> profile = [];
  bool isLoaded = true;
  int totalAnggaran = 0;
  int jumlahPemakaian = 0;
  int totalPengeluaran = 0;
  int totalPemasukan = 0;
  int totalInvestasi = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    super.initState();
  }

  Future<void> _getProfile() async {
    var list = await dbProfile.getProfile();
    var totalAngg = await dbProfile.getCurrAnggJumlah();
    var jumPakai = await dbProfile.getCurrAnggJump();
    var totalPem = await dbProfile.getTotalPemasukan();
    var totalPeng = await dbProfile.getTotalPengeluaran();
    var totalInv = await dbProfile.getTotalInvestasi();
    setState(() {
      profile.clear();
      list!.forEach((profil) {
        profile.add(Profil.fromMap(profil));
      });
      totalAnggaran = totalAngg ?? 0;
      jumlahPemakaian = jumPakai ?? 0;
      totalPemasukan = totalPem ?? 0;
      totalPengeluaran = totalPeng ?? 0;
      totalInvestasi = totalInv ?? 0;
      isLoaded = false;
    });
  }

  Widget build(BuildContext context) {
    if (isLoaded == true) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          color: Color.fromARGB(243, 211, 233, 229),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  header(
                    name: 'Hai, ${profile[0].name}',
                  ),
                  Announcement(
                    anggaran: totalAnggaran,
                    pengeluaran: jumlahPemakaian,
                    sisa: totalAnggaran - jumlahPemakaian,
                    bulan: 'July',
                  )
                ],
              ),
              Expanded(
                child: CustomScrollView(
                  primary: false,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 20,
                        right: 20,
                        bottom: 15,
                      ),
                      sliver: SliverGrid.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.0,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext contex) {
                                    return const InvestasiPage(
                                      title: 'Investasi',
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.currency_exchange,
                                    size: 35,
                                  ),
                                  Text('Utang')
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext contex) {
                                    return const UtangPage(
                                      title: 'Investasi',
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.meeting_room,
                                    size: 35,
                                  ),
                                  Text('Hutang')
                                ],
                              ),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (BuildContext contex) {
                          //           return const InvestasiPage(
                          //             title: 'Investasi',
                          //           );
                          //         },
                          //       ),
                          //     );
                          //   },
                          //   child: Container(
                          //     decoration: const BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(10),
                          //       ),
                          //     ),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: const [
                          //         Icon(
                          //           Icons.receipt,
                          //           size: 35,
                          //         ),
                          //         Text('Laporan')
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 0,
                          ),
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                            bottom: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WeightText(content: 'Total Pemasukan'),
                              SizedBox(
                                height: 5,
                              ),
                              Text(NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                              ).format(totalPemasukan))
                            ],
                          )),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 0,
                          top: 0,
                        ),
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WeightText(content: 'Total Pengeluaran'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                            ).format(totalPengeluaran))
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 15,
                          top: 0,
                        ),
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 10,
                          right: 10,
                          bottom: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WeightText(content: 'Total Investasi'),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                            ).format(totalInvestasi))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
