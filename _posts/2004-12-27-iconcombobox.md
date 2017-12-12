---
layout: post
category: swing
folder: IconComboBox
title: JComboBoxにアイコンを表示
tags: [JComboBox, JTextField, Icon, ListCellRenderer, MatteBorder, JLabel]
author: aterai
pubdate: 2004-12-27T01:32:14+09:00
description: JComboBoxを編集可にしてテキスト入力部分とリスト部分にアイコンを表示します。
image: https://lh5.googleusercontent.com/-4rGEnYRGuys/VQfEDJHomCI/AAAAAAAAN0o/vja8KE3Cm-o/s800/IconComboBox.png
comments: true
---
## 概要
`JComboBox`を編集可にしてテキスト入力部分とリスト部分にアイコンを表示します。

{% download https://lh5.googleusercontent.com/-4rGEnYRGuys/VQfEDJHomCI/AAAAAAAAN0o/vja8KE3Cm-o/s800/IconComboBox.png %}

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
上記のサンプルでは、`JLabel#setIcon(...)`でアイコンを追加し、リスト内の各項目にアイコンが表示されるように設定した`ListCellRenderer`を`JComboBox`に設定しています。

- `setEditable(false)`
    - `JComboBox`が編集不可の場合、リスト内の各項目だけでなく`JComboBox`にもアイコンが表示される
- `setEditable(true)`
    - 上:
        - `JComboBox`の文字列入力欄には、アイコンが表示されない
    - 中:
        - `combo.getEditor().getEditorComponent()`で取得した`JTextField`に`MatteBorder`を追加して、文字列入力欄にアイコンを表示
    - 下:
        - `combo.getEditor().getEditorComponent()`で取得した`JTextField`にアイコンを追加した`JLabel`を追加
        - アイコン(`JLabel`)が文字列と重ならないように、`JTextField`にはその幅だけ余白をとるように設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [MatteBorderでラベル枠を修飾](https://ateraimemo.com/Swing/MatteBorder.html)
- [JTextField内にアイコンを追加](https://ateraimemo.com/Swing/IconTextField.html)
- [JComboBoxの内余白](https://ateraimemo.com/Swing/PaddingComboBox.html)
- [JComboBoxのEditorComponentにJButtonを配置](https://ateraimemo.com/Swing/ButtonInComboEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
