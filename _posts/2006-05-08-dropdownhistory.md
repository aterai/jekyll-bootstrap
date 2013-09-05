---
layout: post
title: JComboBoxのアイテム履歴
category: swing
folder: DropDownHistory
tags: [JComboBox]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-05-08

## JComboBoxのアイテム履歴
`JComboBox`で入力した文字列などのアイテムを順に保存します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTL-2krEbI/AAAAAAAAAYc/9yTnbMmSi1Q/s800/DropDownHistory.png)

### サンプルコード
<pre class="prettyprint"><code>public boolean addItem(JComboBox combo, String str, int max) {
  if(str==null || str.length()==0) return false;
  combo.setVisible(false);
  DefaultComboBoxModel model = (DefaultComboBoxModel) combo.getModel();
  model.removeElement(str);
  model.insertElementAt(str, 0);
  if(model.getSize()&gt;max) {
    model.removeElementAt(max);
  }
  combo.setSelectedIndex(0);
  combo.setVisible(true);
  return true;
}
</code></pre>

### 解説
`JComboBox`に検索する文字列が入力されて、検索ボタンが押されるたびに履歴を更新しています。上記のサンプルでは、`4`個まで履歴を保存し、それ以上は古いものから消されます。履歴にある文字列が再度検索された場合は、それを一番上に移動しています。

### コメント