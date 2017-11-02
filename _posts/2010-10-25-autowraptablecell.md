---
layout: post
category: swing
folder: AutoWrapTableCell
title: JTableのセルの高さを自動調整
tags: [JTable, JTextArea, TableCellRenderer]
author: aterai
pubdate: 2010-10-25T14:24:03+09:00
description: JTableのセルの高さを、文字列の折り返しに応じて自動調整します。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH4TWFB1I/AAAAAAAAAR4/8C89wEJ8EUA/s800/AutoWrapTableCell.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2017/06/automatically-adjust-height-of-jtables.html
    lang: en
comments: true
---
## 概要
`JTable`のセルの高さを、文字列の折り返しに応じて自動調整します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH4TWFB1I/AAAAAAAAAR4/8C89wEJ8EUA/s800/AutoWrapTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>private List&lt;List&lt;Integer&gt;&gt; rowAndCellHeightList= new ArrayList&lt;&gt;();
private void adjustRowHeight(JTable table, int row, int column) {
  //int cWidth = table.getTableHeader().getColumnModel().getColumn(column).getWidth();
  //int cWidth = table.getCellRect(row, column, false).width; //セルの内余白は含めない
  //setSize(new Dimension(cWidth, 1000)); //注目
  setBounds(table.getCellRect(row, column, false)); //setSizeの代わりに、setBoundsでも可
  //doLayout(); //必要なさそう

  int preferredHeight = getPreferredSize().height;
  while (rowAndCellHeightList.size() &lt;= row) {
    rowAndCellHeightList.add(new ArrayList&lt;Integer&gt;(column));
  }
  List&lt;Integer&gt; cellHeightList = rowAndCellHeightList.get(row);
  while (cellHeightList.size() &lt;= column) {
    cellHeightList.add(0);
  }
  cellHeightList.set(column, preferredHeight);
  //JDK 1.8.0: int max = cellHeightList.stream().max(Integer::compare).get();
  int max = preferredHeight;
  for (int h: cellHeightList) {
    max = Math.max(h, max);
  }
  if (table.getRowHeight(row) != max) {
    table.setRowHeight(row, max);
  }
}
</code></pre>

## 解説
上記のサンプルでは、セルレンダラーに`setLineWrap(true)`を指定した`JTextArea`を使用し、カラムサイズの変更などが実行されるたびに、その`JTextArea`の高さを取得し、`JTable#setRowHeight(int)`メソッドで各行の高さとして設定しています。

## 参考リンク
- [JTable multiline cell renderer](http://blog.botunge.dk/post/2009/10/09/JTable-multiline-cell-renderer.aspx)
- [Text Utilities « Java Tips Weblog](https://tips4java.wordpress.com/2008/10/26/text-utilities/)
- [JTableのセル幅で文字列を折り返し](https://ateraimemo.com/Swing/TableCellRenderer.html)
- [ToolkitからScreenResolutionを取得し、コンポーネントで使用するフォントの倍率を変更する](https://ateraimemo.com/Swing/ScreenResolution.html)
    - `JTable`の行の高さは`LookAndFeel`依存で一定のため、フォントサイズの変更に応じた自動調整などは行われない(自前で高さを変更する必要がある)

<!-- dummy comment line for breaking list -->

## コメント
- 高さが微妙に更新されない場合がある…。 -- *aterai* 2010-10-27 (水) 14:02:02
- フレームのサイズ(`JTable`の高さ)を微妙に調整すると、スクロールバーが表示・非表示を繰り返す場合がある。 -- *aterai* 2010-11-02 (火) 20:23:55
- ~~上二つの原因は同じだと思うけど、今のところ何が問題なのか分からず、お手上げ状態です。~~ -- *aterai* 2010-11-02 (火) 20:26:21
- レンダラーに以下のようなコードを追加して調整するサンプルを発見: [JTable multiline cell renderer](http://blog.botunge.dk/post/2009/10/09/JTable-multiline-cell-renderer.aspx) -- *aterai* 2013-05-21 (火) 04:18:52
    - この方法だと、セルを描画する毎に、行の高さを調整するようになるので、これまでのドラッグでリサイズ中の微妙なサイズは無くなるはず(多少重くなるかもしれないけど、違いは全く感じられない)。 -- *aterai* 2013-05-21 (火) 18:43:54

<!-- dummy comment line for breaking list -->
