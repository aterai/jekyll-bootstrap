---
layout: post
category: swing
folder: LoopComboBox
title: JComboBoxのItem選択をループ
tags: [JComboBox, ActionMap, InputMap]
author: aterai
pubdate: 2005-10-24T09:40:47+09:00
description: JComboBoxのItemの選択が、上下のカーソルキーでループするように設定します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPicRK7pI/AAAAAAAAAeI/ApRsPHlRWe0/s800/LoopComboBox.png
comments: true
---
## 概要
`JComboBox`の`Item`の選択が、上下のカーソルキーでループするように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPicRK7pI/AAAAAAAAAeI/ApRsPHlRWe0/s800/LoopComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>Action up = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combo.getSelectedIndex();
    combo.setSelectedIndex((index == 0) ? combo.getItemCount() - 1 : index - 1);
  }
};
Action down = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combo.getSelectedIndex();
    combo.setSelectedIndex((index == combo.getItemCount() - 1) ? 0 : index + 1);
  }
};
ActionMap amc = combo.getActionMap();
amc.put("myUp",   up);
amc.put("myDown", down);
InputMap imc = combo.getInputMap();
imc.put(KeyStroke.getKeyStroke(KeyEvent.VK_UP, 0),   "myUp");
imc.put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN, 0), "myDown");
</code></pre>

## 解説
上記のサンプルでは、下の`JComboBox`から`ActionMap`と`InputMap`を取得し、これに上下キーに対応する新しいアクションを追加しています。

## 参考リンク
- [ActionMap (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ActionMap.html)
- [InputMap (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/InputMap.html)

<!-- dummy comment line for breaking list -->

## コメント
