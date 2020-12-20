import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'hover_button.dart';

class Button extends StatelessWidget {
  /// Implementation for DefaultButton, PrimaryButton and CompoundButton.
  ///
  /// More info at https://developer.microsoft.com/en-us/fluentui#/controls/web/button
  const Button({
    Key key,
    @required this.text,
    this.style,
    this.onPressed,
    this.onLongPress,
    this.semanticsLabel,
  })  : subtext = null,
        super(key: key);

  Button.compound({
    Key key,
    @required this.text,
    @required this.subtext,
    this.style,
    this.onPressed,
    this.onLongPress,
    this.semanticsLabel,
  }) : super(key: key);

  /// The main text of the button
  final Widget text;

  /// The secondary text of the button. Used with [CompoundButton]
  final Widget subtext;

  /// The style of the button
  final ButtonStyle style;

  /// Callback to when the button get pressed. If this and onLongPress == null,
  /// the button will be considered disabled
  final VoidCallback onPressed;

  /// Callback to when the button gets pressed for a long time. If this and onPressed
  /// == null, the button will be considered disabled
  final VoidCallback onLongPress;

  /// The semantics label to allow screen readers to read the screen
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final style = ButtonTheme.of(context).copyWith(this.style);
    return Semantics(
      label: semanticsLabel,
      child: HoverButton(
        cursor: (_, state) => style.cursor?.call(state),
        onPressed: onPressed,
        onLongPress: onLongPress,
        builder: (context, state) {
          return Container(
            padding: style.padding,
            margin: style.margin,
            decoration: BoxDecoration(
              color: style.color?.call(state),
              borderRadius: style.borderRadius,
              border: style.border?.call(state),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text != null)
                  DefaultTextStyle(
                    style: (style.textStyle?.call(state)) ?? TextStyle(),
                    child: text,
                  ),
                if (subtext != null)
                  DefaultTextStyle(
                    style: (style.subtextStyle?.call(state)) ?? TextStyle(),
                    child: subtext,
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

class ButtonStyle {
  final ButtonState<Color> color;

  final ButtonState<Border> border;
  final BorderRadiusGeometry borderRadius;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final ButtonState<MouseCursor> cursor;

  final ButtonState<TextStyle> textStyle;

  // compoused button
  final ButtonState<TextStyle> subtextStyle;

  ButtonStyle({
    this.color,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.cursor,
    this.textStyle,
    this.subtextStyle,
  });

  static ButtonStyle defaultTheme([Brightness brightness]) {
    final defButton = ButtonStyle(
      cursor: (state) {
        if (state.isDisabled)
          return SystemMouseCursors.forbidden;
        else if (state.isHovering || state.isPressing)
          return SystemMouseCursors.click;
        else
          return MouseCursor.defer;
      },
      borderRadius: BorderRadius.circular(2),
      color: (state) {
        if (state.isDisabled)
          return Colors.grey[40];
        else if (state.isPressing)
          return Colors.grey[30];
        else if (state.isHovering)
          return Colors.grey[20];
        else
          return Colors.transparent;
      },
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(4),
    );
    final disabledBorder = Border.all(style: BorderStyle.none);
    final disabledTextStyle = TextStyle(
      color: Colors.grey[100],
      fontWeight: FontWeight.bold,
    );
    if (brightness == null || brightness == Brightness.light)
      return defButton.copyWith(ButtonStyle(
        border: (state) => state.isDisabled
            ? disabledBorder
            : Border.all(color: Colors.grey[100], width: 0.8),
        textStyle: (state) => state.isDisabled
            ? disabledTextStyle
            : TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        subtextStyle: (state) => TextStyle(color: Colors.black, fontSize: 12),
      ));
    else
      return defButton.copyWith(ButtonStyle(
        border: (state) => state.isDisabled
            ? disabledBorder
            : Border.all(color: Colors.white, width: 0.8),
        textStyle: (state) => state.isDisabled
            ? disabledTextStyle
            : TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        subtextStyle: (state) => TextStyle(color: Colors.white, fontSize: 12),
      ));
  }

  ButtonStyle copyWith(ButtonStyle style) {
    if (style == null) return this;
    return ButtonStyle(
      border: style?.border ?? border,
      borderRadius: style?.borderRadius ?? borderRadius,
      cursor: style?.cursor ?? cursor,
      textStyle: style?.textStyle ?? textStyle,
      margin: style?.margin ?? margin,
      padding: style?.padding ?? padding,
      subtextStyle: style?.subtextStyle ?? subtextStyle,
      color: style?.color ?? color,
    );
  }
}

class ButtonTheme extends TreeTheme<ButtonStyle> {
  /// Creates a theme style that controls design for
  /// [Button].
  ///
  /// The data argument must not be null.
  const ButtonTheme({
    Key key,
    @required ButtonStyle data,
    Widget child,
  })  : assert(data != null),
        super(key: key, child: child, data: data);

  /// Returns the [data] from the closest [ButtonTheme] ancestor. If there is
  /// no ancestor, it returns [Style.ButtonTheme]. Applications can assume
  /// that the returned value will not be null.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ButtonStyle theme = ButtonTheme.of(context);
  /// ```
  static ButtonStyle of(BuildContext context) {
    final ButtonTheme theme =
        context.dependOnInheritedWidgetOfExactType<ButtonTheme>();
    return theme?.data ?? ButtonStyle.defaultTheme(context.theme?.brightness);
  }
}