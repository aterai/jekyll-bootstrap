---
layout: post
category: swing
folder: ColorChooserPanel
title: JColorChooserから指定したColorChooserPanelを削除して表示する
tags: [JColorChooser, AbstractColorChooserPanel, JDialog]
author: aterai
pubdate: 2017-05-29T15:18:45+09:00
description: JColorChooserから指定したColorChooserPanelのタブなどを削除してJDialogに設定します。
image: https://drive.google.com/uc?id=1p2IZZ3_HwzjhI5u3SOnYFzYqi-orR6a9MQ
comments: true
---
## 概要
`JColorChooser`から指定した`ColorChooserPanel`のタブなどを削除して`JDialog`に設定します。

{% download https://drive.google.com/uc?id=1p2IZZ3_HwzjhI5u3SOnYFzYqi-orR6a9MQ %}

## サンプルコード
<pre class="prettyprint"><code>JCheckBox swatches = new JCheckBox(UIManager.getString("ColorChooser.swatchesNameText", getLocale()));
JCheckBox hsv = new JCheckBox(UIManager.getString("ColorChooser.hsvNameText", getLocale()));
JCheckBox hsl = new JCheckBox(UIManager.getString("ColorChooser.hslNameText", getLocale()));
JCheckBox rgb = new JCheckBox(UIManager.getString("ColorChooser.rgbNameText", getLocale()));
JCheckBox cmyk = new JCheckBox(UIManager.getString("ColorChooser.cmykNameText", getLocale()));
List&lt;JCheckBox&gt; list = Arrays.asList(swatches, hsv, hsl, rgb, cmyk);

JButton button = new JButton("open JColorChooser");
button.addActionListener(e -&gt; {
  List&lt;String&gt; selected = list.stream()
    .filter(AbstractButton::isSelected).map(AbstractButton::getText).collect(Collectors.toList());
  if (selected.isEmpty()) { // use default JColorChooser
    JColorChooser.showDialog(getRootPane(), "JColorChooser", null);
  } else {
    JColorChooser cc = new JColorChooser();
    for (AbstractColorChooserPanel p : cc.getChooserPanels()) {
      if (!selected.contains(p.getDisplayName())) {
        cc.removeChooserPanel(p);
      }
    }
    dialog.getContentPane().removeAll();
    dialog.getContentPane().add(cc);
    dialog.getContentPane().add(buttonPanel, BorderLayout.SOUTH);
    dialog.pack();
    dialog.setLocationRelativeTo(SwingUtilities.getWindowAncestor(getRootPane()));
    dialog.setVisible(true);
  }
});
</code></pre>

## 解説
- すべてのチェックボックスが未選択の場合:
    - `JColorChooser.showDialog(...)`でデフォルトのカラー・チューザを表示
        - `static`なメソッドなので、`JColorChooser#removeChooserPanel(...)`などで`ColorChooserPanel`を削除しても反映されない
- サンプル`(S)`: `swatches`
    - パレット(`swatches`)から色を選択可能
- `HSV(H)`: `hsv`
    - 色相-彩度-値のカラーモデルを使用して色を選択可能
    - `JDK 1.7.0`以前は、色相-彩度-明るさで`HSB`と表示されていた
- `HSL(L)`: `hsl`
    - 色相-彩度-明度のカラーモデルを使用して色を選択可能
    - `JDK 1.7.0`での新機能
- `RGB(G)`: `rgb`
    - 赤-緑-青のカラーモデルを使用して色を選択可能
    - `R`はリセットボタンの`Mnemonic`で使用されているので、`RGB`タブの`Mnemonic`は`G`になっている
- `CMYK`
    - プロセスカラー、または`4`色モデル(シアン-マゼンタ-黄-黒)を使用して色を選択可能
    - `JDK 1.7.0`での新機能

<!-- dummy comment line for breaking list -->

- - - -
- `JColorChooser`のタブなどに表示される`AbstractColorChooserPanel#getDisplayName()`の値は`Locale`に依存する
- ~~上記のサンプルの「すべて未選択」以外で表示される`JDialog`の`OK`ボタンなどはすべてダミーでクリックしても無効~~ `JColorChooser.createDialog(...)`メソッドを使用するよう修正

<!-- dummy comment line for breaking list -->

## 参考リンク
- [How to Use Color Choosers (The Java™ Tutorials > Creating a GUI With JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/colorchooser.html)

<!-- dummy comment line for breaking list -->

## コメント
