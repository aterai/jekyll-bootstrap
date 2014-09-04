---
layout: post
title: JTableHeaderのフォントを変更
category: swing
folder: HeaderFont
tags: [JTable, JTableHeader, TableCellRenderer, UIManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-08-23

## 概要
`TableCellRenderer`を使って、`JTable`のヘッダが使用するフォントを変更します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTNshbAJvI/AAAAAAAAAbM/xYo1iOQ9fxU/s800/HeaderFont.png %}

## サンプルコード
<pre class="prettyprint"><code>class HeaderRenderer implements TableCellRenderer {
  private final Font font = new Font(Font.SANS_SERIF, Font.PLAIN, 32);
  @Override public Component getTableCellRendererComponent(JTable t,
      Object val, boolean isS, boolean hasF, int row, int col) {
    TableCellRenderer r = t.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel)r.getTableCellRendererComponent(t, val, isS, hasF, row, col);
    l.setFont(font);
    return l;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`0`番目のヘッダカラムだけフォントを変更しています。`JTableHeader`のセルを修飾する場合も、`JTable`中のセルの場合と同様に、`TableCellRenderer`を実装したセルレンダラーを使用することができます。

サンプルのセルレンダラーは、`TableCellRenderer#getTableCellRendererComponent`メソッドの中で、委譲しているヘッダのデフォルトのレンダラーから描画に使用するコンポーネント(`JLabel`)を取得し、そのラベルのフォントだけ`JLabel#setFont`メソッドで置き換えています。

同様の方法で、文字色、背景色、ボーダー、文字の中央揃え、右揃えなども変更することができます。

- 字揃えを変更する場合の注意点: [JTableHeaderの字揃えを変更](http://terai.xrea.jp/Swing/HorizontalAlignmentHeaderRenderer.html)

<!-- dummy comment line for breaking list -->

- - - -
コメントで[いつも見てます](http://terai.xrea.jp/いつも見てます.html)さんが指摘しているように、以下の様に`JTableHeader#setFont()`メソッドを使用すると、全ヘッダカラムのフォントを指定することができます。

<pre class="prettyprint"><code>table.getTableHeader().setFont(font);
</code></pre>

- - - -
すべての`JTable`のヘッダを同じフォントや文字色で変更する場合は、以下のように`UIManager`を使用する方法もあります。

<pre class="prettyprint"><code>UIManager.put("TableHeader.font", new FontUIResource(font));
</code></pre>

## 参考リンク
- [使用するフォントの統一](http://terai.xrea.jp/Swing/FontChange.html)
- [Default Table Header Cell Renderer Java Tips Weblog](http://tips4java.wordpress.com/2009/02/27/default-table-header-cell-renderer/)
- [JTableHeaderの字揃え](http://terai.xrea.jp/Swing/HorizontalAlignmentHeaderRenderer.html)

<!-- dummy comment line for breaking list -->

## コメント
- これでいいのでは？ `JTableHeader header = TABLE.getTableHeader(); header.setFont(FONT);` -- [いつも見てます](http://terai.xrea.jp/いつも見てます.html) 2011-11-24 (木) 06:02:05
    - ご指摘ありがとうございます。解説などをすこし追加、修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-11-24 (木) 16:28:46

<!-- dummy comment line for breaking list -->

