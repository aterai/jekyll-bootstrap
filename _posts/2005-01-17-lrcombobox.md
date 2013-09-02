---
layout: post
title: JComboBoxのItemを左右に配置
category: swing
folder: LRComboBox
tags: [JComboBox, Html]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-01-17

## JComboBoxのItemを左右に配置
`JComboBox`の`Item`にテキストを左右に分けて配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTPk2QD9aI/AAAAAAAAAeM/xrl0d1ms74g/s800/LRComboBox.png)

### サンプルコード
<pre class="prettyprint"><code>class LRItem{
  private final String leftText;
  private final String rightText;
  public LRItem(String strLeft, String strRight) {
    leftText  = strLeft;
    rightText = strRight;
  }
  public String getHtmlText() {
    return "&lt;html&gt;&lt;table width='240'&gt;&lt;tr&gt;&lt;td align='left'&gt;"+leftText+
    "&lt;/td&gt;&lt;td align='right'&gt;"+rightText+"&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/html&gt;";
  }
  public String getLeftText()  { return leftText; }
  public String getRightText() { return rightText; }
  public String toString()     { return getHtmlText(); }
}
</code></pre>

### 解説
`JComboBox`に`html`の`table`タグを使うことで、`Item`に設定した文字列を左右に振り分けています。

この方法では、`JComboBox`のリストにカラムを簡単に増やすことが出来ます。

上記のサンプルでは、`JComboBox`のサイズ変更に対応していません。

### 参考リンク
- [JComboBoxのItemを左右にクリップして配置](http://terai.xrea.jp/Swing/ClippedLRComboBox.html)

<!-- dummy comment line for breaking list -->

### コメント
