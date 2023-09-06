import 'package:flutter/cupertino.dart';


///selection overlay에 텍스트 추가
class CustomCupertinoPickerDefaultSelectionOverlay extends StatelessWidget{
  const CustomCupertinoPickerDefaultSelectionOverlay({
    super.key,
    this.background = CupertinoColors.tertiarySystemFill,
    this.capStartEdge = true,
    this.capEndEdge = true,

    ///SelectionOverlay에 표시할 텍스트
    this.text = '',
  }) : assert(background != null),
        assert(capStartEdge != null),
        assert(capEndEdge != null);

  /// Whether to use the default use rounded corners and margin on the start side.
  final bool capStartEdge;

  /// Whether to use the default use rounded corners and margin on the end side.
  final bool capEndEdge;

  /// The color to fill in the background of the [CupertinoPickerDefaultSelectionOverlay].
  /// It Support for use [CupertinoDynamicColor].
  ///
  /// Typically this should not be set to a fully opaque color, as the currently
  /// selected item of the underlying [CupertinoPicker] should remain visible.
  /// Defaults to [CupertinoColors.tertiarySystemFill].
  final Color background;
  /// Default margin of the 'SelectionOverlay'.
  static const double _defaultSelectionOverlayHorizontalMargin = 9;

  /// Default radius of the 'SelectionOverlay'.
  static const double _defaultSelectionOverlayRadius = 8;

  ///SelectionOverlay에 표시할 텍스트
  final String text;
  @override
  Widget build(BuildContext context) {
    const Radius radius = Radius.circular(_defaultSelectionOverlayRadius);

    return Container(
      margin: EdgeInsetsDirectional.only(
        start: capStartEdge ? _defaultSelectionOverlayHorizontalMargin : 0,
        end: capEndEdge ? _defaultSelectionOverlayHorizontalMargin : 0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.horizontal(
          start: capStartEdge ? radius : Radius.zero,
          end: capEndEdge ? radius : Radius.zero,
        ),
        color: CupertinoDynamicColor.resolve(background, context),
      ),

      child:text == '' ? Container(child:Text("")) : _buildText(text),

    );
  }
}

//SelectionOverlay에 텍스트를 표시하기 위한 Container
_buildText(String text){
  return Row(
    children:[
      Expanded(
        flex: 5,
        child: Container(),
      ),
      Expanded(
        flex: 4,
        child: Text(text),
      ),
    ],
  );
}