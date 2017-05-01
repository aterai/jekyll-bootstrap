---
layout: post
category: swing
folder: ComboBoxPlaceholder
title: JComboBoxでアイテムが選択されていない場合のプレースホルダー文字列を設定する
tags: [JComboBox]
author: aterai
pubdate: 2017-05-01T14:53:34+09:00
description: JComboBoxでアイテムが選択されていない場合、代わりに表示するプレースホルダー文字列を設定します。
image: https://drive.google.com/uc?export=view&id=1R3IHJMxqNMm4oHGv9wmZ8FXpeZJn0AvEwA
comments: true
---
## 概要
`JComboBox`でアイテムが選択されていない場合、代わりに表示するプレースホルダー文字列を設定します。

{% download https://drive.google.com/uc?export=view&id=1R3IHJMxqNMm4oHGv9wmZ8FXpeZJn0AvEwA %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo1 = new JComboBox&lt;&gt;(new String[] {"One", "Two", "Three", "Four"});
combo1.setSelectedIndex(-1);
combo1.setRenderer(new DefaultListCellRenderer() {
  @Override public Component getListCellRendererComponent(JList&lt;?&gt; list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
    //XXX: String str = index &lt; 0 ? "- Select Item -" : value.toString();
    String str = Objects.toString(value, "- Select Item -");
    super.getListCellRendererComponent(list, str, index, isSelected, cellHasFocus);
    return this;
  }
});
</code></pre>

## 解説
- `JComboBox`のモデルにはプレースホルダー文字列を含めない
- `DefaultListCellRenderer#getListCellRendererComponent(...)`メソッドをオーバーライドし、引数の値が`null`の場合のみ代わりにプレースホルダー文字列を表示するコンポーネントを返す
    - インデックスが`-1`の場合にプレースホルダー文字列を表示するように設定すると、選択が変更できなくなる？

<!-- dummy comment line for breaking list -->

## コメント
