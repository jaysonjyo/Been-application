import 'package:bee_chem/personal%202.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'features/personnel/personal_list_model.dart';
import 'features/personnel/personnel_provider.dart';

class PersonnelDetailsListScreen extends StatefulWidget {
  final String token;
  const PersonnelDetailsListScreen({super.key, required this.token});

  @override
  State<PersonnelDetailsListScreen> createState() =>
      _PersonnelDetailsListScreenState();
}

class _PersonnelDetailsListScreenState
    extends State<PersonnelDetailsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonnelProvider>().fetchPersonnel(widget.token);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<PersonnelProvider>().fetchPersonnel(
    //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNGE4Mjg4YTMzMzZjMWEyOWU4ZjI0ZWNmYjMyOWY3MWYxMTk5ZWNiNGYwNzk1ZDg3OTE1NjQ5MTAxY2U4ZWZlMmRhODMyM2ZiYTk1NjYzNTciLCJpYXQiOjE3NjE4MzQ5ODcuMTA1MzI2LCJuYmYiOjE3NjE4MzQ5ODcuMTA1MzI5LCJleHAiOjE3NjE4NjczODcuMDc2MzU5LCJzdWIiOiI1NSIsInNjb3BlcyI6W119.jehaCkLungxWt_T5TpIlspxOi4cMnMSgLQEv_UZWbl4eP12wq-N6PPlF1SwzVD8PsVsHERRPaTofHMHqehE4r5Yw-Pk0TFcVGFwn5DX5C5Ux5TMr-X6ENdl9pFCiZmfmAAFM6zuXQ3FKZ8gB8IXCIvGOkNHDHEiQNCDXaXe1wlk3svPLRxatq39t1ZL0D5gcfhrfPZK8m7YS29y7nvrW7Nycrqb1Yj5vzncKSiyzpNMtq77psJP5NRo3oHf3oEV1rXHYVfYvh6MNeJfEMDNX8VSGomgvSCLsOx1zK1zZbcokqGqmMcb4_8z6viwdNEx8BCmoybzY2Xc6je4tNfvWkyXxGRb1os75JBBLu9bUYcV5OVMM1vJ5MHgvSr341JfFe3mkn0kSuFht3wvbKCtePKEOYnOWPIBuw3bu-ZzClGM1T6GEl9ng_Glwtgg309SHeIg-U3TsyuMiOBAFpXHaAq6NNBT7iSR9yrg7bdeeObihACV6K9Qc2duenVYX1s5XTpj4hIeGAjU_Jc-XFXIlCQcRghK50m_PSUS7T-cQUdj2r5tPCkVK1WGeFTourfKBH5r2bBESBqt1SWE-hb-lGnQQduvd-DIoHLOKcXTiFsVLOnrks05pAng41yX5em8GUEV5LGwwik9Ig1iQ_h4CgyVEbccKXs_iW_qY7-LtTcs",
    //   );
    // });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => isLoading = false);
    });
  }
  bool isLoading = true;
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PersonnelProvider>();
    final personnelList = provider.filteredList;
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 400;

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xffffcc00),
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PersonnelDetailsForm(token: widget.token),
            ),
          );

          // ✅ Refresh list after form is closed
          if (result == true) {
            context.read<PersonnelProvider>().fetchPersonnel(widget.token);
          }
        },
        child: Icon(Icons.add, color: Colors.black, size: 28 * textScale),
      ),
      body:
      Skeletonizer(
        enabled: provider.loading, // ✅ Skeletonizer shows while fetching
        child: Column(
          children: [
            // HEADER
            Stack(
              children: [
                Image.asset(
                  "assets/Frame 18341.png",
                  fit: BoxFit.cover,
                  height: size.height * 0.25,
                  width: double.infinity,
                ),
                Positioned(
                  top: size.height * 0.08,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.grid_view_rounded,
                                  color: Colors.black),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person_outline,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Personnel Details List",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                        onChanged: (value) {
                          context
                              .read<PersonnelProvider>()
                              .filterPersonnel(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      final query = _searchController.text.trim();
                      context.read<PersonnelProvider>().filterPersonnel(query);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Text(
                        "GO",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ERROR HANDLING / EMPTY / LIST
            if (provider.error != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off,
                            color: Colors.grey, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          "Unable to load data.\nPlease check your connection or try again later.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<PersonnelProvider>()
                                .fetchPersonnel(widget.token);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (personnelList.isEmpty && ! provider.loading)
              Expanded(
                child: Center(
                  child: Text(
                    'No person found.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: personnelList.length,
                  itemBuilder: (context, index) {
                    final person = personnelList[index];
                    final isActive = person.status == 'Active';
                    final roleName = person.roleDetails.isNotEmpty
                        ? roleToDisplay(person.roleDetails.first.role)
                        : '--';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundColor: Color(0xffffeb99),
                                child: Icon(Icons.groups_rounded,
                                    color: Colors.black87),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          person.firstName,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? Colors.green.shade50
                                                : Colors.red.shade50,
                                            border: Border.all(
                                              color: isActive
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                color: isActive
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 8,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                person.status,
                                                style: TextStyle(
                                                  color: isActive
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(person.contactNumber,
                                            style:
                                            const TextStyle(fontSize: 13)),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.person,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            roleName,
                                            style:
                                            const TextStyle(fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "${person.postcode} ${person.address}, ${person.suburb}, ${person.state}, ${person.country}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
