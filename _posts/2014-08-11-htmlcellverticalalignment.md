---
layout: post
title: TableCellRendererに複数行のHtmlテキストを表示する場合に行揃えを設定する
category: swing
folder: HtmlCellVerticalAlignment
tags: [JTable, TableCellRenderer, Html, JLabel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-08-11

## 概要
`JTable`の`Cell`に複数行になる`Html`テキストを表示する場合の行揃えによる描画の変化をテストします。

{% download https://lh5.googleusercontent.com/-Id-AlEWH0-M/U-eKsOPZf6I/AAAAAAAACLI/asLZtz0cOvk/s800/HtmlCellVerticalAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>((JLabel) table.getDefaultRenderer(Object.class)).setVerticalAlignment(JLabel.TOP);
</code></pre>

## 解説
`DefaultTableCellRenderer`(`JLabel`を継承)に複数行になる`Html`テキストを表示する場合、行揃え(`VerticalAlignment`)に`JLabel.TOP`以外が設定されていると、マウスドラッグによるセル選択で描画が乱れることがあります。

## 参考リンク
- [java - Table cells with HTML strings inconsistently rendered as multiline - Stack Overflow](http://stackoverflow.com/questions/25043191/table-cells-with-html-strings-inconsistently-rendered-as-multiline)

<!-- dummy comment line for breaking list -->

## コメント
