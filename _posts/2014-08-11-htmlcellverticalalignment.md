---
layout: post
category: swing
folder: HtmlCellVerticalAlignment
title: TableCellRendererに複数行のHtmlテキストを表示する場合に行揃えを設定する
tags: [JTable, TableCellRenderer, Html, JLabel]
author: aterai
pubdate: 2014-08-11T00:16:05+09:00
description: JTableのCellに複数行になるHtmlテキストを表示する場合の行揃えによる描画の変化をテストします。
image: https://lh5.googleusercontent.com/-Id-AlEWH0-M/U-eKsOPZf6I/AAAAAAAACLI/asLZtz0cOvk/s800/HtmlCellVerticalAlignment.png
comments: true
---
## 概要
`JTable`の`Cell`に複数行になる`Html`テキストを表示する場合の行揃えによる描画の変化をテストします。

{% download https://lh5.googleusercontent.com/-Id-AlEWH0-M/U-eKsOPZf6I/AAAAAAAACLI/asLZtz0cOvk/s800/HtmlCellVerticalAlignment.png %}

## サンプルコード
<pre class="prettyprint"><code>((JLabel) table.getDefaultRenderer(Object.class)).setVerticalAlignment(SwingConstants.TOP);
</code></pre>

## 解説
- `JTable`のセルレンダラーとして`DefaultTableCellRenderer`(`JLabel`を継承)を使用し、複数の行が存在する`Html`テキストを表示
    - 行揃え(`VerticalAlignment`)に`SwingConstants.TOP`以外を設定
    - マウスドラッグによるセル選択で描画が乱れる場合がある

<!-- dummy comment line for breaking list -->

- - - -
- `Java 9`で修正された？
    - 例えば`BOTTOM`を選択して`0`行目から`6`行目までマウスドラッグで選択すると、`Java 8`では`1`から`2`行のセル表示内容が変化するが、`Java 9`では変化しない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [java - Table cells with HTML strings inconsistently rendered as multiline - Stack Overflow](https://stackoverflow.com/questions/25043191/table-cells-with-html-strings-inconsistently-rendered-as-multiline)

<!-- dummy comment line for breaking list -->

## コメント
