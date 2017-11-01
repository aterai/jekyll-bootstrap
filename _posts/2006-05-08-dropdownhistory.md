---
layout: post
category: swing
folder: DropDownHistory
title: JComboBoxのアイテム履歴
tags: [JComboBox]
author: aterai
pubdate: 2006-05-08T08:25:26+09:00
description: JComboBoxで入力した文字列などのアイテムを順に保存します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL-2krEbI/AAAAAAAAAYc/9yTnbMmSi1Q/s800/DropDownHistory.png
comments: true
---
## 概要
`JComboBox`で入力した文字列などのアイテムを順に保存します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTL-2krEbI/AAAAAAAAAYc/9yTnbMmSi1Q/s800/DropDownHistory.png %}

## サンプルコード
<pre class="prettyprint"><code>public static boolean addItem(JComboBox&lt;String&gt; combo, String str, int max) {
  if (Objects.isNull(str) || str.isEmpty()) {
    return false;
  }
  combo.setVisible(false);
  DefaultComboBoxModel&lt;String&gt; model = (DefaultComboBoxModel&lt;String&gt;) combo.getModel();
  model.removeElement(str);
  model.insertElementAt(str, 0);
  if (model.getSize() &gt; max) {
    model.removeElementAt(max);
  }
  combo.setSelectedIndex(0);
  combo.setVisible(true);
  return true;
}
</code></pre>

## 解説
`JComboBox`に検索する文字列が入力されて、検索ボタンが押されるたびに履歴を更新しています。上記のサンプルでは、`4`個まで履歴を保存し、それ以上は古いものから消されます。履歴にある文字列が再度検索された場合は、それを一番上に移動しています。

## 参考リンク
- [DefaultComboBoxModel#insertElementAt(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/DefaultComboBoxModel.html#insertElementAt-E-int-)

<!-- dummy comment line for breaking list -->

## コメント
