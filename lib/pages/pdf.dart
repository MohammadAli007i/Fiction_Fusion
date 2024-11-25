import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PDF1 extends StatefulWidget {
  final String pdf;
  final String detail;

  const PDF1({required this.pdf, required this.detail, Key? key}) : super(key: key);

  @override
  _PDF1State createState() => _PDF1State();
}

class _PDF1State extends State<PDF1> {
  PdfControllerPinch? pdfControllerPinch;
  int totalPageCount = 0, currentPage = 1;
  Uint8List? pdfBytes;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      pdfBytes = await fetchPdfAsBytes(widget.pdf);
      if (pdfBytes != null) {
        setState(() {
          pdfControllerPinch = PdfControllerPinch(document: PdfDocument.openData(pdfBytes!));
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load PDF.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching PDF.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List?> fetchPdfAsBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Center(
          child: Text(
            widget.detail,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Bitter",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF018786),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : Column(
        children: [
          _buildPageControls(),
          Expanded(child: _pdfView()),
        ],
      ),
    );
  }

  Widget _buildPageControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Total Pages: $totalPageCount"),
          IconButton(
            onPressed: () => pdfControllerPinch?.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
            ),
            icon: const Icon(Icons.arrow_back),
          ),
          Text("Current Page: $currentPage"),
          IconButton(
            onPressed: () => pdfControllerPinch?.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
            ),
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _pdfView() {
    return PdfViewPinch(
      scrollDirection: Axis.vertical,
      controller: pdfControllerPinch!,
      onDocumentLoaded: (document) {
        setState(() {
          totalPageCount = document.pagesCount;
        });
      },
      onPageChanged: (page) {
        setState(() {
          currentPage = page;
        });
      },
    );
  }
}
