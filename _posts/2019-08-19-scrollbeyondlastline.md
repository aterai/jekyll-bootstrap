---
layout: post
category: swing
folder: ScrollBeyondLastLine
title: JTextAreaの最終行を超えてスクロール可能にする
tags: [JScrollPane, JTextArea, JViewport]
author: aterai
pubdate: 2019-08-19T00:02:28+09:00
description: JTextAreaの高さを拡張し、その最終行を超えてスクロール可能になるよう設定します。
image: https://drive.google.com/uc?id=1_1B-E0sbvJ_4AiKUHMQMXYRsmUodk-BB
comments: true
---
## 概要
`JTextArea`の高さを拡張し、その最終行を超えてスクロール可能になるよう設定します。

{% download https://drive.google.com/uc?id=1_1B-E0sbvJ_4AiKUHMQMXYRsmUodk-BB %}

## サンプルコード
<pre class="prettyprint"><code>JTextArea textArea = new JTextArea() {
  @Override public Dimension getPreferredSize() {
    Dimension d = super.getPreferredSize();
    Container c = SwingUtilities.getAncestorOfClass(JScrollPane.class, this);
    if (c instanceof JScrollPane &amp;&amp; isEditable()) {
      Rectangle r = ((JScrollPane) c).getViewportBorderBounds();
      d.height += r.height - getRowHeight() - getInsets().bottom;
    }
    return d;
  }
};
</code></pre>

## 解説
- デフォルトではテキストの最終行までが`JTextArea`の推奨サイズとなり、その最終行までがスクロール可能領域となる
    - メモ帳やブラウザなどの動作と同じ
- `JTextArea#getPreferredSize()`メソッドをオーバーライドし、`JViewport`の高さから`JTextArea`の一行分を除いた高さを拡張し、最終行が表示上の先頭行になるまでスクロール可能に設定
    - 上記のサンプルでは`JTextArea`が編集可能の場合、最終行を超えてスクロール可能に設定している
    - 多くのテキストエディタのデフォルト？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [swing - Java JTextArea allow scrolling beyond end of text - Stack Overflow](https://stackoverflow.com/questions/32679335/java-jtextarea-allow-scrolling-beyond-end-of-text)
- [JTextAreaに行番号を表示](https://ateraimemo.com/Swing/LineNumber.html)

<!-- dummy comment line for breaking list -->

## コメント
