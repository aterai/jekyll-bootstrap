---
layout: post
category: swing
folder: ComboBoxPlaceholder
title: JComboBoxでアイテムが選択されていない場合のプレースホルダ文字列を設定する
tags: [JComboBox, ListCellRenderer]
author: aterai
pubdate: 2017-05-01T14:53:34+09:00
description: JComboBoxでアイテムが選択されていない場合、代わりに表示するプレースホルダ文字列を設定します。
image: https://drive.google.com/uc?id=1R3IHJMxqNMm4oHGv9wmZ8FXpeZJn0AvEwA
comments: true
---
## 概要
`JComboBox`でアイテムが選択されていない場合、代わりに表示するプレースホルダ文字列を設定します。

{% download https://drive.google.com/uc?id=1R3IHJMxqNMm4oHGv9wmZ8FXpeZJn0AvEwA %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo1 = new JComboBox&lt;&gt;(
    new String[] {"One", "Two", "Three", "Four"});
combo1.setSelectedIndex(-1);
combo1.setRenderer(new DefaultListCellRenderer() {
  @Override public Component getListCellRendererComponent(
        JList&lt;?&gt; list, Object value, int index,
        boolean isSelected, boolean cellHasFocus) {
    // ???: String str = index &lt; 0 ? "- Select Item -" : value.toString();
    String str = Objects.toString(value, "- Select Item -");
    super.getListCellRendererComponent(
        list, str, index, isSelected, cellHasFocus);
    return this;
  }
});
</code></pre>

## 解説
上記のサンプルでは、編集不可の`JComboBox`にアイテムが選択されていない場合にヒントとしてプレースホルダ文字列を表示するリストセルレンダラーを設定しています。

- `DefaultListCellRenderer#getListCellRendererComponent(...)`メソッドをオーバーライドし、引数の`value`が`null`である場合のみヒント文字列を表示するよう設定
    - 引数の`Object value`が`null`の場合ではなくリストの`index`が`-1`の場合にヒント文字列を表示すると、マウスクリックで`JComboBox`の選択状態が変更不可になる？
- リストセルレンダラー側でヒント文字列を表示しているため、`JComboBox`のモデル側にプレースホルダ文字列を含めるなどの変更が不要

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTextFieldにフォーカスと文字列が無い場合の表示](https://ateraimemo.com/Swing/GhostText.html)
- [JTextFieldに透かし画像を表示する](https://ateraimemo.com/Swing/WatermarkInTextField.html)
- [JPasswordFieldにヒント文字列を描画する](https://ateraimemo.com/Swing/InputHintPasswordField.html)
- [ComboBoxEditorにJLayerを設定してプレースホルダ文字列を表示する](https://ateraimemo.com/Swing/ComboEditorPlaceholder.html)
    - こちらは編集可能な`JComboBox`でプレースホルダ文字列を表示する場合のサンプル

<!-- dummy comment line for breaking list -->

## コメント
