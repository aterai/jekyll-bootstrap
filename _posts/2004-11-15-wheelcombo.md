---
layout: post
category: swing
folder: WheelCombo
title: JComboBoxの値をMouseWheelで変更
tags: [JComboBox, MouseWheelListener]
author: aterai
pubdate: 2004-11-15T02:34:50+09:00
description: JComboBoxにフォーカスがある場合、その値をMouseWheelの上下で変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWm95sa5I/AAAAAAAAApg/1tiQsmg5QKw/s800/WheelCombo.png
comments: true
---
## 概要
`JComboBox`にフォーカスがある場合、その値を`MouseWheel`の上下で変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWm95sa5I/AAAAAAAAApg/1tiQsmg5QKw/s800/WheelCombo.png %}

## サンプルコード
<pre class="prettyprint"><code>JComboBox&lt;String&gt; combo = makeComboBox();
combo.addMouseWheelListener(new MouseWheelListener() {
  @Override public void mouseWheelMoved(MouseWheelEvent e) {
    JComboBox source = (JComboBox) e.getComponent();
    if (!source.hasFocus()) {
      return;
    }
    int ni = source.getSelectedIndex() + e.getWheelRotation();
    if (ni &gt;= 0 &amp;&amp; ni &lt; source.getItemCount()) {
      source.setSelectedIndex(ni);
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`に`MouseWheelListener`を設定し、`JComboBox`にフォーカスがある場合はマウスホイールの上下回転イベントに反応して表示内容を順次変更しています。

## 参考リンク
- [MouseWheelListener (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/event/MouseWheelListener.html)

<!-- dummy comment line for breaking list -->

## コメント
