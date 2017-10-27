---
layout: post
category: swing
folder: SizeLayoutManager
title: LayoutManagerでコンポーネントのサイズを変更する
tags: [LayoutManager, FlowLayout, JToggleButton]
author: aterai
pubdate: 2017-04-10T14:38:31+09:00
description: LayoutManagerを使用して、コンポーネントの状態に応じてそのサイズや位置を変更します。
image: https://drive.google.com/uc?export=view&id=1nYydwcffL9ElwLnTcopf0y05pAU6chdG4w
comments: true
---
## 概要
`LayoutManager`を使用して、コンポーネントの状態に応じてそのサイズや位置を変更します。

{% download https://drive.google.com/uc?export=view&id=1nYydwcffL9ElwLnTcopf0y05pAU6chdG4w %}

## サンプルコード
<pre class="prettyprint"><code>JPanel p = new JPanel(new GridBagLayout());
p.setLayout(new FlowLayout() {
  @Override public void layoutContainer(Container target) {
    synchronized (target.getTreeLock()) {
      int nmembers = target.getComponentCount();
      if (nmembers &lt;= 0) {
        return;
      }
      Insets insets = target.getInsets();
      //int vgap = getVgap();
      int hgap = getHgap();
      int rowh = target.getHeight();
      int x = insets.left + hgap;
      for (int i = 0; i &lt; nmembers; i++) {
        Component m = target.getComponent(i);
        if (m.isVisible() &amp;&amp; m instanceof AbstractButton) {
          int v = ((AbstractButton) m).isSelected() ? 80 : 50;
          Dimension d = new Dimension(v, v);
          m.setSize(d);
          int y = (rowh - v) / 2;
          m.setLocation(x, y);
          x += d.width + hgap;
        }
      }
    }
  }
});
ActionListener al = e -&gt; p.revalidate();
ButtonGroup bg = new ButtonGroup();
Stream.of("b1", "b2", "b3").forEach(s -&gt; {
  JToggleButton b = new JToggleButton(s);
  b.addActionListener(al);
  bg.add(b);
  p.add(b);
});
</code></pre>

## 解説
- `Override JToggleButton#getPreferredSize(...)`
    - `JToggleButton#getPreferredSize(...)`をオーバーライドし、自身が選択されているかどうかで、推奨サイズを変更
- `Override FlowLayout#layoutContainer(...)`
    - `FlowLayout#layoutContainer(...)`をオーバーライドし、子コンポーネントである`JToggleButton`が選択されているかどうかで、表示サイズを変更
        - `LayoutManager`内なので、`JToggleButton#setSize(...)`が使用可能
        - `LayoutManager`以外での、`setSize(...)`、`setPreferredSize(...)`、`setMaximumSize`などの使用は非推奨
        - [Should I avoid the use of set(Preferred|Maximum|Minimum)Size methods in Java Swing? - Stack Overflow](http://stackoverflow.com/questions/7229226/should-i-avoid-the-use-of-setpreferredmaximumminimumsize-methods-in-java-swi)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Should I avoid the use of set(Preferred|Maximum|Minimum)Size methods in Java Swing? - Stack Overflow](http://stackoverflow.com/questions/7229226/should-i-avoid-the-use-of-setpreferredmaximumminimumsize-methods-in-java-swi)
- [JTreeのノードを検索する](https://ateraimemo.com/Swing/SearchBox.html)
    - `Timer`を使用してサイズ変更のアニメーションを行う`BorderLayout`のサンプル

<!-- dummy comment line for breaking list -->

## コメント
