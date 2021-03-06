---
layout: post
category: swing
folder: SetColumns
title: JComboBoxなどの幅をカラム数で指定
tags: [JTextField, JPasswordField, JSpinner, JComboBox]
author: aterai
pubdate: 2006-12-18T16:11:14+09:00
description: JTextField,JPasswordField,JSpinner,JComboBoxの幅をカラム数で指定して比較しています。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTS72PP0tI/AAAAAAAAAjk/RRG_w2fJBtA/s800/SetColumns.png
comments: true
---
## 概要
`JTextField`,`JPasswordField`,`JSpinner`,`JComboBox`の幅をカラム数で指定して比較しています。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTS72PP0tI/AAAAAAAAAjk/RRG_w2fJBtA/s800/SetColumns.png %}

## サンプルコード
<pre class="prettyprint"><code>JTextField field = new JTextField(20);
JPasswordField passwd = new JPasswordField(20);
JSpinner.DefaultEditor e = (JSpinner.DefaultEditor) spinner.getEditor();
e.getTextField().setColumns(20);
combo1.setEditable(true);
Component c = combo1.getEditor().getEditorComponent();
if (c instanceof JTextField) {
  ((JTextField) c).setColumns(20);
}
</code></pre>

## 解説
上記のサンプルでは、要素が空の`JComboBox`などのカラム幅を同じ(`20`文字分の幅)にして(下二つは`default`のまま)、以下のような順番で並べています。

1. `JTextField#setColumns(20)`
1. `JPasswordField#setColumns(20)`
1. `JSpinner#setColumns(20)`
1. `JComboBox#setEditable(true)`, `JComboBox#setColumns(20)`
1. `JComboBox#setEditable(true)`, `default`
1. `JComboBox#setEditable(false)`, `default`

- スクリーンショット左: `JDK 1.6.0`、`WindowsLookAndFeel`
    - `setColumns(20)`を設定した入力欄の幅は揃っている
    - `JComboBox`で`setColumns`を使用していないデフォルトの状態では、モデル中のアイテムから最大の幅が適用される
        - モデルが空の場合は[JComboBoxのセルサイズを決定するためのプロトタイプ値を設定する](https://ateraimemo.com/Swing/PrototypeDisplayValue.html)のようにプロトタイプ値を設定しておく必要がある
- スクリーンショット右: `JDK 1.5.0_10`、`WindowsLookAndFeel`
    - 各入力欄の幅、高さ、余白が不揃い
        - `JTextField`の左内余白が広すぎる
        - `JComboBox`などの左内余白が狭すぎる
    - レイアウトマネージャーで工夫するか、`setPreferredSize(Dimension)`を使って幅を揃える必要がある
        - 参考: [JButtonなどの高さを変更せずに幅を指定](https://ateraimemo.com/Swing/ButtonWidth.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JButtonなどの高さを変更せずに幅を指定](https://ateraimemo.com/Swing/ButtonWidth.html)
- [JComboBoxのセルサイズを決定するためのプロトタイプ値を設定する](https://ateraimemo.com/Swing/PrototypeDisplayValue.html)

<!-- dummy comment line for breaking list -->

## コメント
