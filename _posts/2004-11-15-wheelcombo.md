---
layout: post
title: JComboBoxの値をMouseWheelで変更
category: swing
folder: WheelCombo
tags: [JComboBox, MouseWheelListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-11-15

## JComboBoxの値をMouseWheelで変更
`JComboBox`にフォーカスがある場合、その値を`MouseWheel`の上下で変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTWm95sa5I/AAAAAAAAApg/1tiQsmg5QKw/s800/WheelCombo.png)

### サンプルコード
<pre class="prettyprint"><code>combo.addMouseWheelListener(new MouseWheelListener() {
  @Override public void mouseWheelMoved(MouseWheelEvent e) {
    JComboBox source = (JComboBox) e.getSource();
    if(!source.hasFocus()) return;
    int ni = source.getSelectedIndex() + e.getWheelRotation();
    if(ni&gt;=0 &amp;&amp; ni&lt;source.getItemCount()) {
      source.setSelectedIndex(ni);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、一番上のコンボボックスに`MouseWheelListener`が設定され、マウスホイールの上下回転に反応して、表示される内容が順次変更されるようになっています。

### コメント
