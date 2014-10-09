---
layout: post
category: swing
folder: IconComboBox
title: JComboBoxにアイコンを表示
tags: [JComboBox, Icon, ListCellRenderer, MatteBorder]
author: aterai
pubdate: 2004-12-27T01:32:14+09:00
description: JComboBoxを編集可にしてテキスト入力部分とリスト部分にアイコンを表示します。
comments: true
---
## 概要
`JComboBox`を編集可にしてテキスト入力部分とリスト部分にアイコンを表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTONfr7t7I/AAAAAAAAAcA/jNQyoEApJ1I/s800/IconComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>private static Border makeIconBorder(JComponent c, ImageIcon i) {
  int iw = i.getIconWidth();
  Border b1 = BorderFactory.createMatteBorder(0, iw, 0, 0, i);
  Border b2 = BorderFactory.createEmptyBorder(0, 5, 0, 0);
  Border b3 = BorderFactory.createCompoundBorder(b1, b2);
  return BorderFactory.createCompoundBorder(c.getBorder(), b3);
}
</code></pre>

## 解説
- 一番上
    - デフォルトの`ListCellRenderer`を使用する`JComboBox`です。
- 上から二番目
    - `JComboBox`フィールドが編集不可の場合、`ListCellRenderer`を実装することでアイコン表示することができます。
- 下から二番目
    - `JComboBox`フィールドが編集可の場合、`ListCellRenderer`を実装しても、`Editor`部分はアイコン表示されません。
- 一番下
    - `JComboBox`フィールドが編集可の場合でも、`MatteBorder`を使用することでエディタ部分にもアイコンを表示することができます。

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MatteBorderでラベル枠を修飾](http://terai.xrea.jp/Swing/MatteBorder.html)
- [JTextField内にアイコンを追加](http://terai.xrea.jp/Swing/IconTextField.html)
- [JComboBoxの内余白](http://terai.xrea.jp/Swing/PaddingComboBox.html)
- [JComboBoxのEditorComponentにJButtonを配置](http://terai.xrea.jp/Swing/ButtonInComboEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
