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
    href: https://java-swing-tips.blogspot.com/2017/06/automatically-adjust-height-of-jtables.html
    lang: en
comments: true
---
## 概要
`JTable`のセルの高さを、文字列の折り返しに応じて自動調整します。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH4TWFB1I/AAAAAAAAAR4/8C89wEJ8EUA/s800/AutoWrapTableCell.png %}

## サンプルコード
<pre class="prettyprint"><code>class TextAreaCellRenderer extends JTextArea implements TableCellRenderer {
  private final List&lt;List&lt;Integer&gt;&gt; cellHeights = new ArrayList&lt;&gt;();

  @Override public void updateUI() {
    super.updateUI();
    setLineWrap(true);
    setBorder(BorderFactory.createEmptyBorder(2, 2, 2, 2));
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    setFont(table.getFont());
    setText(Objects.toString(value, ""));
    adjustRowHeight(table, row, column);
    return this;
  }

/**
 * Calculate the new preferred height for a given row,
 * and sets the height on the table.
 * http://blog.botunge.dk/post/2009/10/09/JTable-multiline-cell-renderer.aspx
 */
  private void adjustRowHeight(JTable table, int row, int column) {
  // The trick to get this to work properly is to set the width of the column to
  // the textarea. The reason for this is that getPreferredSize(), without a width
  // tries to place all the text in one line.
  // By setting the size with the width of the column,
  // getPreferredSize() returnes the proper height which the row should have in
  // order to make room for the text.
  // int cWidth = table.getTableHeader().getColumnModel().getColumn(column).getWidth();
  // int cWidth = table.getCellRect(row, column, false).width; //IntercellSpacingを無視
  // setSize(new Dimension(cWidth, 1000));

    setBounds(table.getCellRect(row, column, false)); // setSizeではなくsetBoundsでも可
    // doLayout(); // 必要なさそう

    int preferredHeight = getPreferredSize().height;
    while (cellHeights.size() &lt;= row) {
      cellHeights.add(new ArrayList&lt;&gt;(column));
    }
    List&lt;Integer&gt; list = cellHeights.get(row);
    while (list.size() &lt;= column) {
      list.add(0);
    }
    list.set(column, preferredHeight);
    int max = list.stream().max(Integer::compare).get();
    if (table.getRowHeight(row) != max) {
      table.setRowHeight(row, max);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、セルレンダラーに`setLineWrap(true)`を指定した`JTextArea`を使用し、カラムサイズの変更が実行されるたびに、その`JTextArea`の高さを取得し、`JTable#setRowHeight(int)`メソッドで各行の高さを更新しています。

- - - -
- 上記の`TextAreaCellRenderer`を複数インスタンス生成して一つの`JTable`に設定すると正常に折り返しできなくなる
    - セルの高さをキャッシュしている`cellHeights`を`static`にすれば解決するが、その場合複数の`JTable`に適用するとダメになる
        
        <pre class="prettyprint"><code>// NG
        table.getColumnModel().getColumn(0).setCellRenderer(new TextAreaCellRenderer());
        table.getColumnModel().getColumn(1).setCellRenderer(new TextAreaCellRenderer());
        
        // OK
        TableCellRenderer renderer = new TextAreaCellRenderer();
        table.getColumnModel().getColumn(0).setCellRenderer(renderer);
        table.getColumnModel().getColumn(1).setCellRenderer(renderer);
</code></pre>
    - * 参考リンク [#reference]
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
