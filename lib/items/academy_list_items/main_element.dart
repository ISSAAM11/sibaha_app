import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/items/academy_list_items/academy_item.dart';

class MainElement extends StatelessWidget {
  const MainElement({super.key});

  @override
  Widget build(BuildContext context) {
    final academyBloc = BlocProvider.of<AcademyBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.school,
            color: Colors.black87,
            size: 20,
          ),
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => print('Filter pressed'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.filter_list,
                              size: 18, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            'Filter',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => print('Map pressed'),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              size: 18, color: Colors.black87),
                          SizedBox(width: 8),
                          Text(
                            'Map',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<AcademyBloc, AcademyState>(
              builder: (context, state) {
                if (state is AcademyInitial) {
                  academyBloc.add(FetchAcademies('token'));
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is AcademyFailed) {
                  return Expanded(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(state.message),
                    )),
                  );
                }
                if (state is AcademyLoaded) {
                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: state.academies.length,
                    itemBuilder: (context, index) {
                      return AcatemyItem(
                        index: index,
                        academy: state.academies[index],
                      );
                    },
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
