---
layout: post
title: JTableのセルの高さを自動調整
category: swing
folder: AutoWrapTableCell
tags: [JTable, JTextArea, TableCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-10-25

## JTableのセルの高さを自動調整
`JTable`のセルの高さを、文字列の折り返しに応じて自動調整します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH4TWFB1I/AAAAAAAAAR4/8C89wEJ8EUA/s800/AutoWrapTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>JTable table = new JTable(model) {
  @Override public void doLayout() {
    initPreferredHeight();
    super.doLayout();
  }
  @Override public void columnMarginChanged(ChangeEvent e) {
    initPreferredHeight();
    super.columnMarginChanged(e);
  }
  private void initPreferredHeight() {
    int vc = convertColumnIndexToView(AUTOWRAP_COLUMN);
    TableColumn col = getColumnModel().getColumn(vc);
    for(int row=0; row&lt;getRowCount(); row++) {
      Component c = prepareRenderer(col.getCellRenderer(), row, vc);
      if(c instanceof JTextArea) {
        JTextArea a = (JTextArea)c;
        int h = getPreferredHeight(a); // + getIntercellSpacing().height;
        //if(getRowHeight(row)!=h)
        setRowHeight(row, h);
      }
    }
  }
  //http://tips4java.wordpress.com/2008/10/26/text-utilities/
  private int getPreferredHeight(JTextComponent c) {
    Insets insets = c.getInsets();
    View view = c.getUI().getRootView(c).getView(0);
    int preferredHeight = (int)view.getPreferredSpan(View.Y_AXIS);
    return preferredHeight + insets.top + insets.bottom;
  }
};
</code></pre>

### 解説
上記のサンプルでは、セルレンダラーに、`setLineWrap(true)`とした`JTextArea`を使用し、カラムサイズの変更などがあったときに、その`JTextArea`の高さを取得して`JTable#setRowHeight(int)`メソッドで各行の高さとして設定しています。

### 参考リンク
- [Text Utilities « Java Tips Weblog](http://tips4java.wordpress.com/2008/10/26/text-utilities/)
- [JTableのセル幅で文字列を折り返し](http://terai.xrea.jp/Swing/TableCellRenderer.html)

<!-- dummy comment line for breaking list -->

### コメント
- 高さが微妙に更新されない場合がある…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-10-27 (水) 14:02:02
- フレームのサイズ(`JTable`の高さ)を微妙に調整すると、スクロールバーが表示・非表示を繰り返す場合がある。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-11-02 (火) 20:23:55
- ~~上二つの原因は同じだと思うけど、今のところ何が問題なのか分からず、お手上げ状態です。~~ -- [aterai](http://terai.xrea.jp/aterai.html) 2010-11-02 (火) 20:26:21
- レンダラーに以下のようなコードを追加して調整するサンプルを発見: [JTable multiline cell renderer](http://blog.botunge.dk/post/2009/10/09/JTable-multiline-cell-renderer.aspx) -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-21 (火) 04:18:52

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private ArrayList&lt;ArrayList&lt;Integer&gt;&gt; rowColHeight = new ArrayList&lt;ArrayList&lt;Integer&gt;&gt;();
private void adjustRowHeight(JTable table, int row, int column) {
  //int cWidth = table.getTableHeader().getColumnModel().getColumn(column).getWidth();
  int cWidth = table.getCellRect(row, column, false).width; //セルの内余白は含めない
  //setSize(new Dimension(cWidth, 1000)); //注目
  setBounds(table.getCellRect(row, column, false)); //もしくは？
  //doLayout();

  int prefH = getPreferredSize().height;
  while(rowColHeight.size() &lt;= row) {
    rowColHeight.add(new ArrayList&lt;Integer&gt;(column));
  }
  ArrayList&lt;Integer&gt; colHeights = rowColHeight.get(row);
  while(colHeights.size() &lt;= column) {
    colHeights.add(0);
  }
  colHeights.set(column, prefH);
  int maxH = prefH;
  for(Integer colHeight : colHeights) {
    if(colHeight &gt; maxH) {
      maxH = colHeight;
    }
  }
  if(table.getRowHeight(row) != maxH) {
    table.setRowHeight(row, maxH);
  }
}
</code></pre>
    - この方法だと、セルを描画する毎に、行の高さを調整するようになるので、これまでのドラッグでリサイズ中の微妙なサイズは無くなるはず(多少重くなるかもしれないけど、違いは全く感じられない)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-21 (火) 18:43:54

<!-- dummy comment line for breaking list -->

