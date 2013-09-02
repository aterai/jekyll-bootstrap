---
layout: post
title: JToolTipにBorderを設定
category: swing
folder: ToolTipBorder
tags: [JToolTip, Border]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-08-15

## JToolTipにBorderを設定
ツールチップに`Border`を設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTVjcQsX6I/AAAAAAAAAn0/tieki8bniAM/s800/ToolTipBorder.png)

### サンプルコード
<pre class="prettyprint"><code>JButton button = new JButton() {
  public JToolTip createToolTip() {
    JToolTip tip = new JToolTip();
    Border b1 = tip.getBorder();
    Border b2 = BorderFactory.createMatteBorder(0,10,0,0,Color.GREEN);
    tip.setBorder(BorderFactory.createCompoundBorder(b1, b2));
    tip.setComponent(this);
    return tip;
  }
};
button.setToolTipText("テスト");
</code></pre>

### 解説
上記のサンプルでは、`JComponent#createToolTip`メソッドをオーバーライドし、その中で`Border`を設定した`JToolTip`を生成しています。

### コメント
