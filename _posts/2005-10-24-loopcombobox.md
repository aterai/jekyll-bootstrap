---
layout: post
category: swing
folder: LoopComboBox
title: JComboBoxのItem選択をループ
tags: [JComboBox, ActionMap, InputMap]
author: aterai
pubdate: 2005-10-24
description: JComboBoxのItemの選択が、上下のカーソルキーでループするように設定します。
comments: true
---
## 概要
`JComboBox`の`Item`の選択が、上下のカーソルキーでループするように設定します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTPicRK7pI/AAAAAAAAAeI/ApRsPHlRWe0/s800/LoopComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>Action up = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combo.getSelectedIndex();
    combo.setSelectedIndex((index==0)?combo.getItemCount()-1:index-1);
  }
};
Action down = new AbstractAction() {
  @Override public void actionPerformed(ActionEvent e) {
    int index = combo.getSelectedIndex();
    combo.setSelectedIndex((index==combo.getItemCount()-1)?0:index+1);
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
上記のサンプルでは、下のコンボボックスの`ActionMap`と`InputMap`を使って、上下キーに対応する新しいアクションを設定しています。

## コメント
