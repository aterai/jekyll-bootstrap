---
layout: post
category: swing
folder: LRComboBox
title: JComboBoxのItemを左右に配置
tags: [JComboBox, Html]
author: aterai
pubdate: 2005-01-17T00:09:58+09:00
description: JComboBoxのItemにテキストを左右に分けて配置します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPk2QD9aI/AAAAAAAAAeM/xrl0d1ms74g/s800/LRComboBox.png
comments: true
---
## 概要
`JComboBox`の`Item`にテキストを左右に分けて配置します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTPk2QD9aI/AAAAAAAAAeM/xrl0d1ms74g/s800/LRComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class LRItem {
  private final String leftText;
  private final String rightText;
  public LRItem(String strLeft, String strRight) {
    leftText  = strLeft;
    rightText = strRight;
  }
  public String getHtmlText() {
    return "&lt;html&gt;&lt;table width='240'&gt;&lt;tr&gt;&lt;td align='left'&gt;" + leftText +
    "&lt;/td&gt;&lt;td align='right'&gt;" + rightText + "&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;&lt;/html&gt;";
  }
  public String getLeftText()  { return leftText; }
  public String getRightText() { return rightText; }
  public String toString()     { return getHtmlText(); }
}
</code></pre>

## 解説
`JComboBox`に`html`の`table`タグを使うことで、`Item`に設定した文字列を左右に振り分けています。

- メモ:
    - `JComboBox`のリストにカラムを追加・削除することが簡単に可能
    - `JComboBox`のサイズ変更に未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのItemを左右にクリップして配置](https://ateraimemo.com/Swing/ClippedLRComboBox.html)

<!-- dummy comment line for breaking list -->

## コメント
