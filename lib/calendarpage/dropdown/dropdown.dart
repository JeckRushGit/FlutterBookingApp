
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../custom_text.dart';
import 'dropdownitem.dart';


class DropDownMenu extends StatelessWidget {
  //Lista di oggetti di tipo DropDownItem che mostrerò nella lista,eventualmente filtrata dal textfield.
  //Un dropdownitem deve definere il metodo "get => label" per sapere
  //quale stringa mostrare
  final List<DropDownItem> options;

  //Elemento dropdownitem che mostrerò come placeholder nel textfield(rappresenta l'item attualmente selezionato)
  final DropDownItem model;


  final double optionsHeigth;

  //raggio dei bordi smussati del dropdown
  final double borderRadius;

  final FocusNode focusNode;

  //widget per mostrare sopra tutti i widget della pagina un altro widget(lista di opzioni)
  OverlayEntry? overlayEntry;

  //callback che viene chiamata ogni qual volta seleziono un item dalla lista
  final Function onTapItem;

  //lista di opzioni filtrate che inizialmente assume tutti i valori possibili , si riempe o si svuota
  //in base a cosa c'è scritto nel textfield
  final _filteredOptions = <DropDownItem>[].obs;

  //variabile osservabile per cambiare dinamicamente i bordi del textfield in base al focus
  final isOpen = false.obs;

  final Color dropDownColor;

  final Color textColor;

  //link necessario per ancorare la lista di opzioni disponibili al textfield
  final LayerLink _link = LayerLink();

  //chiave per ottenere le dimensioni del textfield dinamicamente e passarli tra widget che non hanno gradi di parentela(passare le dimensioni alla lista di opzioni)
  final GlobalKey textFieldKey = GlobalKey();

  DropDownMenu(
      {Key? key,
        required this.options,
        required this.model,
        required this.onTapItem,
        required this.focusNode,
        this.optionsHeigth = 400,
        this.borderRadius = 16,
        required this.dropDownColor,
        this.textColor = Colors.white})
      : super(key: key) {
    _filteredOptions.value = options;
  }

  //tolgo o aggiungo dalla lista di opzioni filtrate in base a cosa contiene la stringa query , proveniente dal textfield
  void _filterItems(String query) {
    List<DropDownItem> res = [];

    //se la stringa è vuota mostro tutte le opzioni disponibili
    if (query.isEmpty) {
      res = options;
    } else {
      //altrimenti mostro quelle che rispecchiano i caratteri della stringa
      res = options
          .where(
              (item) => item.label.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    _filteredOptions.value = res;
  }

  //viene chiamata ogni volta che clicco sul textfield per mostrare la lista di opzioni
  void showMenu(BuildContext context) {
    try {
      if (textFieldKey.currentContext != null) {
        //ottengo le dimensioni del textfield
        RenderBox renderbox =
        textFieldKey.currentContext!.findRenderObject() as RenderBox;

        double textFieldWidth = renderbox.size.width;
        double textFieldHeigth = renderbox.size.height;

        //rimuovo se presente la lista di prima
        if (overlayEntry != null) {
          overlayEntry?.remove();
          overlayEntry = null;
        }

        //creo un overlay con la lista di opzioni
        overlayEntry = OverlayEntry(builder: (BuildContext context) {
          return Positioned(
            top: 0,
            left: 0,
            //widget per agganciare tramite il link la lista(follower) al textfield(target)
            child: CompositedTransformFollower(
              showWhenUnlinked: false,
              //utilizzo un offset bidimensionale per spostare la lista immediatamente sotto
              //al textfield (l'origine parte dall'angolo in alto a sinistra del textfield , aggiungo quindi
              //un offset verticale pari all'altezza del textfield per farla comparire sotto)
              offset: Offset(0, textFieldHeigth),
              link: _link,
              child: SizedBox(
                height: optionsHeigth,
                //larghezza uguale a quella del textfield
                width: textFieldWidth,
                child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: dropDownColor,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(borderRadius),
                              bottomRight: Radius.circular(borderRadius))),
                      child: ListLabel(
                          focusNode: focusNode,
                          options: _filteredOptions,
                          onTapItem: onTapItem),
                    )),
              ),
            ),
          );
        });

        //inserisco l'overlay appena creato nell'albero degli overlay per mostrarlo
        Overlay.of(context)!.insert(overlayEntry!);
      }
    } catch (e) {
      print(e);
    }
  }

  //  nascondo/rimuovo la lista di opzioni
  void hideMenu() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {

    //aggiungo al focus node del textfield un evento
    focusNode.addListener(() {
      //se si clicca sul textfield
      if (focusNode.hasFocus) {
        isOpen.value = true;
        showMenu(context);
      } else { //altrimenti
        isOpen.value = false;
        hideMenu();
      }
    });

    return Obx(() => CompositedTransformTarget(
      link: _link,
      child: Container(
        decoration: BoxDecoration(
            color: dropDownColor,
            //per cambiare i bordi inferiori in base allo stato del focus
            borderRadius: !isOpen.value
                ? BorderRadius.all(Radius.circular(borderRadius))
                : BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius))),
        child: TextField(
          key: textFieldKey,
          //per ottenere globalmente le dimensioni del textfield
          focusNode: focusNode,
          onChanged: _filterItems,
          //ogni volta che aggiungo o rimuovo una lettera del textfield filtro dalla lista
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            hintText: model.label,
          ),
          style: GoogleFonts.montserrat(
            color: textColor,
          ),
        ),
      ),
    ));
  }
}

class ListLabel extends StatelessWidget {
  //Lista di oggetti di tipo DropDownItem che mostrerò nella lista,eventualmente filtrata dal textfield.
  //Un dropdownitem deve definere il metodo "get => label" per sapere
  //quale stringa mostrare
  final List<DropDownItem> options;

  //callback che viene chiamata ogni qual volta seleziono un item dalla lista
  final Function onTapItem;

  //lo passo anche qui per disattivare il focus quando seleziono un item
  final FocusNode focusNode;

  final Color textColor;

  final _scrollController = ScrollController();

  ListLabel(
      {Key? key,
        required this.focusNode,
        required this.options,
        required this.onTapItem,
        this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      //aggiungi padding alla scrollbar
      const EdgeInsets.only(right: 10, bottom: 10),
      color: Colors.transparent,
      //per aggiungere una scrollbar sempre visibile
      child: RawScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        trackColor: Colors.grey,
        thickness: 10,
        trackRadius: const Radius.circular(4),
        thumbColor: Colors.white,
        radius: const Radius.circular(4),


        //ogni item è separato da una linea orizzontale
        child: ListView.separated(
          padding: EdgeInsets.zero,
            separatorBuilder: (context, index) =>
            const Divider(height: 1, color: Colors.white),
            controller: _scrollController,
            itemCount: options.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                //funzione che viene chiamata ogni volta che premiamo su un item
                onTapItem(options[index]);
                focusNode.unfocus();
              },
              title: CustomText(text: options[index].label,color: textColor,),
            )),
      ),
    );
  }
}
