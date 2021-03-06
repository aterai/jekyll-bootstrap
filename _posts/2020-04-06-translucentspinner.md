---
layout: post
category: swing
folder: TranslucentSpinner
title: JSpinnerのTextFieldやArrowButtonを半透明にする
tags: [JSpinner, NimbusLookAndFeel, LookAndFeel]
author: aterai
pubdate: 2020-04-06T12:14:53+09:00
description: NimbusLookAndFeelを適用したJSpinnerでそのFormattedTextFieldやArrowButtonが半透明になるよう設定します。
image: https://drive.google.com/uc?id=1W4bLhbm0FPWEiaLl_9_CIbsCO_Fe4LpP
comments: true
---
## 概要
`NimbusLookAndFeel`を適用した`JSpinner`でその`FormattedTextField`や`ArrowButton`が半透明になるよう設定します。

{% download https://drive.google.com/uc?id=1W4bLhbm0FPWEiaLl_9_CIbsCO_Fe4LpP %}

## サンプルコード
<pre class="prettyprint"><code>UIDefaults d = new UIDefaults();
Painter&lt;JComponent&gt; painter1 = (g, c, w, h) -&gt; {
  g.setColor(new Color(100, 100, 100, 100));
  g.fillRect(0, 0, w, h);
};
Painter&lt;JComponent&gt; painter2 = (g, c, w, h) -&gt; {
  g.setColor(new Color(100, 200, 200, 100));
  g.fillRect(0, 0, w, h);
};
d.put("Spinner:Panel:\"Spinner.formattedTextField\"[Enabled].backgroundPainter", painter1);
d.put("Spinner:Panel:\"Spinner.formattedTextField\"[Focused].backgroundPainter", painter2);
d.put("Spinner:Panel:\"Spinner.formattedTextField\"[Selected].backgroundPainter", painter2);
// d.put("Spinner:Panel:\"Spinner.formattedTextField\"[Focused+Selected].backgroundPainter", painter2);
// d.put("Spinner:Panel:\"Spinner.formattedTextField\"[Disabled].backgroundPainter", painter);

Painter&lt;JComponent&gt; painter3 = (g, c, w, h) -&gt; {
  g.setColor(new Color(100, 100, 200, 100));
  g.fillRect(0, 0, w, h);
};
Painter&lt;JComponent&gt; painter4 = (g, c, w, h) -&gt; {
  g.setColor(new Color(120, 120, 120, 100));
  g.fillRect(0, 0, w, h);
};
d.put("Spinner:\"Spinner.previousButton\"[Enabled].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.previousButton\"[Focused+MouseOver].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.previousButton\"[Focused+Pressed].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.previousButton\"[Focused].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.previousButton\"[MouseOver].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.previousButton\"[Pressed].backgroundPainter", painter4);

d.put("Spinner:\"Spinner.nextButton\"[Enabled].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.nextButton\"[Focused+MouseOver].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.nextButton\"[Focused+Pressed].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.nextButton\"[Focused].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.nextButton\"[MouseOver].backgroundPainter", painter3);
d.put("Spinner:\"Spinner.nextButton\"[Pressed].backgroundPainter", painter4);

SpinnerModel model = new SpinnerNumberModel(0, 0, 100, 5);
JSpinner spinner1 = new JSpinner(model);
// NG: spinner1.putClientProperty("Nimbus.Overrides", d);
((JSpinner.DefaultEditor) spinner1.getEditor()).getTextField().putClientProperty("Nimbus.Overrides", d);
configureSpinnerButtons(spinner1, d);
</code></pre>

## 解説
- `UIDefaults`を作成して`JSpinner`の`FormattedTextField`や`ArrowButton`で使用する`Painter`を登録
    - [Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)にキー一覧がある
    - `JSpinner`の`FormattedTextField`は`Spinner:Panel:"Spinner.formattedTextField"[Enabled].backgroundPainter`のように`Panel`が付くので注意
    - `JSpinner`の`PreviousButton`は`Spinner:\"Spinner.previousButton\"[Enabled].backgroundPainter`だが、上記のチュートリアルでは`codeviousButton`と文字化け？しているので注意が必要
        - `<pre>`を`<code>`タグに変換しようとして`previous`が`codevious`になっている？
        - 他にも`ColorChooser.previewPanelHolder`が`ColorChooser.codeviewPanelHolder`、`ComboBox.pressedWhenPopupVisible`が`ComboBox.codessedWhenPopupVisible`と同様におかしくなっている
        - [NimbusBrowser.java](https://jasperpotts.com/blogfiles/nimbusdefaults/NimbusBrowser.java)で生成される`html`ファイルでは問題ないので、`The Java™ Tutorials`に転載するときに変換ミスがあったのかもしれない
    - `JSpinner`の`NextButton`は`Spinner:\"Spinner.nextButton\"[Enabled].backgroundPainter`
- `putClientProperty("Nimbus.Overrides", d)`メソッドで`JSpinner`の`FormattedTextField`や`ArrowButton`に`UIDefaults`を上書きで設定
    - `JSpinner`に`UIDefaults`を上書きしても無効で、`JFormattedTextField`や`JButton`を取得して直接それに設定する必要がある
    - `JFormattedTextField`は`JSpinner.DefaultEditor#getTextField()`で取得可能
    - `ArrowButton`を取得するメソッドは存在しないので、名前が`Spinner.previousButton`か`Spinner.nextButton`になっている`JButton`を検索して取得している
        - 参考: [JSpinnerのボタンにToolTipを付ける](https://ateraimemo.com/Swing/SpinnerButton.html)
    - ひとつの`JSpinner`に`putClientProperty(...)`を設定してもほかの`JSpinner`まで上書きされてしまう？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)
- [JSpinnerのボタンにToolTipを付ける](https://ateraimemo.com/Swing/SpinnerButton.html)

<!-- dummy comment line for breaking list -->

## コメント
