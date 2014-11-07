---
layout: post
category: swing
folder: HtmlCellVerticalAlignment
title: TableCellRendererに複数行のHtmlテキストを表示する場合に行揃えを設定する
tags: [JTable, TableCellRenderer, Html, JLabel]
author: aterai
pubdate: 2014-08-11T00:16:05+09:00
description: JTableのCellに複数行になるHtmlテキストを表示する場合の行揃えによる描画の変化をテストします。
comments: true
---
## 概要
`JTable`の`Cell`に複数行になる`Html`テキストを表示する場合の行揃えによる描画の変化をテストします。

{% download https://lh5.googleusercontent.com/-Id-AlEWH0-M/U-eKsOPZf6I/AAAAAAAACLI/asLZtz0cOvk/s800/HtmlCellVerticalAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>((JLabel) table.getDefaultRenderer(Object.class)).setVerticalAlignment(JLabel.TOP);
</code></pre>

## 解説
`JTable`のセルに`DefaultTableCellRenderer`(`JLabel`を継承)を使用し、これに複数の行が存在する`Html`テキストを表示する場合、行揃え(`VerticalAlignment`)に`JLabel.TOP`以外が設定されていると、マウスドラッグによるセル選択で描画が乱れることがあります。

## 参考リンク
- [java - Table cells with HTML strings inconsistently rendered as multiline - Stack Overflow](http://stackoverflow.com/questions/25043191/table-cells-with-html-strings-inconsistently-rendered-as-multiline)

<!-- dummy comment line for breaking list -->

## コメント
