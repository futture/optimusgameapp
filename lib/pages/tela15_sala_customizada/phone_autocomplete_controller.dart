import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:projeto_game_quiz/core/api/services/user_service.dart';

class PhoneAutocompleteController {
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;
  List<Contact> contacts = [];

  final userService = UserService();

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void showOverlay(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    hideOverlay();
    final searchText = controller.text.replaceAll(RegExp(r'\D'), '');

    if (searchText.isEmpty) {
      return; // Não mostra overlay se não há texto para buscar
    }

    final filteredContacts = contacts.where((contact) {
      return (contact.phones ?? []).any((phone) {
        if (phone.value == null) return false;
        final phoneDigits = phone.value!.replaceAll(RegExp(r'\D'), '');
        return phoneDigits.contains(searchText) ||
            contact.displayName
                    ?.toLowerCase()
                    .contains(searchText.toLowerCase()) ==
                true;
      });
    }).toList();

    if (filteredContacts.isEmpty) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    final phone = (contact.phones?.isNotEmpty ?? false)
                        ? contact.phones!.first.value!.replaceAll(RegExp(r'\s+'), '') 
                        : '';

                    return ListTile(
                      title: Text(contact.displayName ?? 'Sem nome'),
                      subtitle: Text(phone.trim()),
                      onTap: () {
                        controller.text = phone;
                        hideOverlay();
                        focusNode.unfocus();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  Future<void> fetchContactsAsync() async {
    var fetchedContacts = await userService.fetchContactsAsync();
    contacts = fetchedContacts;
  }
}
