---
layout: post
title: JComboBoxの高さを変更する
category: swing
folder: ComboItemHeight
tags: [JComboBox, ListCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-03-02

## JComboBoxの高さを変更する
`JComboBox`自体の高さや、ドロップダウンリスト内にあるアイテムの高さを変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ6VVptrI/AAAAAAAAAVI/x72zWGymqHk/s800/ComboItemHeight.png)

### サンプルコード
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

### 解説
- 上
    - レンダラーに`setPreferredSize`で高さを設定しています。

<!-- dummy comment line for breaking list -->

- 下
    - レンダラーの`getListCellRendererComponent`で、`index`が`0`以上の時だけ、高さを変更しています。

<!-- dummy comment line for breaking list -->

### コメント
