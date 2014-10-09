---
layout: post
category: swing
folder: ComboItemHeight
title: JComboBoxの高さを変更する
tags: [JComboBox, ListCellRenderer]
author: aterai
pubdate: 2009-03-02T12:37:58+09:00
description: JComboBox自体の高さや、ドロップダウンリスト内にあるアイテムの高さを変更します。
comments: true
---
## 概要
`JComboBox`自体の高さや、ドロップダウンリスト内にあるアイテムの高さを変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ6VVptrI/AAAAAAAAAVI/x72zWGymqHk/s800/ComboItemHeight.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox combo1 = new JComboBox(items);
JLabel renderer1 = (JLabel)combo1.getRenderer();
renderer1.setPreferredSize(new Dimension(0, 32));

JComboBox combo2 = new JComboBox(items);
final ListCellRenderer r = combo2.getRenderer();
final Dimension dim = ((JLabel)r).getPreferredSize();
combo2.setRenderer(new ListCellRenderer() {
  @Override public Component getListCellRendererComponent(
        JList list, Object value, int index,
        boolean isSelected, boolean cellHasFocus) {
    Component c = r.getListCellRendererComponent(
      list, value, index, isSelected, cellHasFocus);
    c.setPreferredSize(new Dimension(100, (index&lt;0)?dim.height:32));
    return c;
  }
});
</code></pre>

## 解説
- 上
    - レンダラーに`setPreferredSize`で高さを設定しています。

<!-- dummy comment line for breaking list -->

- 下
    - レンダラーの`getListCellRendererComponent`で、`index`が`0`以上の時だけ、高さを変更しています。

<!-- dummy comment line for breaking list -->

## コメント
- `html`タグを使用するサンプルなどを追加。 -- *aterai* 2013-12-20 (金) 20:06:03

<!-- dummy comment line for breaking list -->
