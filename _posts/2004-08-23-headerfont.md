---
layout: post
category: swing
folder: HeaderFont
title: JTableHeaderのフォントを変更
tags: [JTable, JTableHeader, TableCellRenderer, UIManager]
author: aterai
pubdate: 2004-08-23T02:54:09+09:00
description: TableCellRendererを使って、JTableのヘッダが使用するフォントを変更します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNshbAJvI/AAAAAAAAAbM/xYo1iOQ9fxU/s800/HeaderFont.png
comments: true
---
## 概要
`TableCellRenderer`を使って、`JTable`のヘッダが使用するフォントを変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNshbAJvI/AAAAAAAAAbM/xYo1iOQ9fxU/s800/HeaderFont.png %}

## サンプルコード
<pre class="prettyprint"><code>class HeaderRenderer implements TableCellRenderer {
  private final Font font = new Font(Font.SANS_SERIF, Font.PLAIN, 32);
  @Override public Component getTableCellRendererComponent(JTable t,
      Object val, boolean isS, boolean hasF, int row, int col) {
    TableCellRenderer r = t.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel) r.getTableCellRendererComponent(t, val, isS, hasF, row, col);
    l.setFont(font);
    return l;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`0`番目のカラムヘッダだけフォントを変更しています。`JTableHeader`のセルを修飾する場合も、`JTable`中のセルの場合と同様に、`TableCellRenderer`を実装したセルレンダラーを使用することができます。

サンプルのセルレンダラーは、`TableCellRenderer#getTableCellRendererComponent(...)`メソッドの中で、委譲しているヘッダのデフォルトのレンダラーから描画に使用するコンポーネント(`JLabel`)を取得し、そのラベルのフォントだけ`JLabel#setFont(...)`メソッドで置き換えています。

同様の方法で、文字色、背景色、ボーダー、文字の中央揃え、右揃えなども変更することができます。

- 字揃えを変更する場合の注意点: [JTableHeaderの字揃えを変更](https://ateraimemo.com/Swing/HorizontalAlignmentHeaderRenderer.html)

<!-- dummy comment line for breaking list -->

- - - -
コメントで*いつも見てます*さんが指摘しているように、以下の様に`JTableHeader#setFont()`メソッドを使用すると、全カラムヘッダのフォントを指定することができます。

<pre class="prettyprint"><code>table.getTableHeader().setFont(font);
</code></pre>

- - - -
すべての`JTable`のヘッダを同じフォントや文字色で変更する場合は、以下のように`UIManager`を使用する方法もあります。

<pre class="prettyprint"><code>UIManager.put("TableHeader.font", new FontUIResource(font));
</code></pre>

## 参考リンク
- [使用するフォントの統一](https://ateraimemo.com/Swing/FontChange.html)
- [Default Table Header Cell Renderer Java Tips Weblog](https://tips4java.wordpress.com/2009/02/27/default-table-header-cell-renderer/)
- [JTableHeaderの字揃え](https://ateraimemo.com/Swing/HorizontalAlignmentHeaderRenderer.html)

<!-- dummy comment line for breaking list -->

## コメント
- これでいいのでは？ `JTableHeader header = TABLE.getTableHeader(); header.setFont(FONT);` -- *いつも見てます* 2011-11-24 (木) 06:02:05
    - ご指摘ありがとうございます。解説などをすこし追加、修正しました。 -- *aterai* 2011-11-24 (木) 16:28:46

<!-- dummy comment line for breaking list -->
