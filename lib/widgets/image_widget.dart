import 'package:flutter/material.dart';
import 'package:shopkeeper/widgets/image_source_sheet.dart';

class ImagesWidget extends FormField<List> {
  ImagesWidget({
    required BuildContext context,
    super.onSaved,
    super.validator,
    super.initialValue,
    autovalidateMode = AutovalidateMode.disabled,
  }) : super(
            autovalidateMode: autovalidateMode,
            //autoValidate,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 124,
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: state.value!.map<Widget>((i) {
                        return Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            child: i is String
                                ? Image.network(
                                    i,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    i,
                                    fit: BoxFit.cover,
                                  ),
                            onLongPress: () {
                              state.didChange(state.value?..remove(i));
                            },
                          ),
                        );
                      }).toList()
                        ..add(
                          GestureDetector(
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.white.withAlpha(50),
                              child: const Icon(
                                Icons.camera_enhance,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => ImageSourceSheet(
                                  onImageSelected: (image) {
                                    state.didChange(state.value?..add(image));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                    ),
                  ),
                  state.hasError
                      ? Text(
                          state.errorText!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        )
                      : Container()
                ],
              );
            });
}
