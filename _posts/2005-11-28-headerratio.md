---
layout: post
title: TableColumnの幅を比率で設定
category: swing
folder: HeaderRatio
tags: [JTable, JTableHeader, TableColumn, JScrollPane]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-11-28

## TableColumnの幅を比率で設定
`TableColumn`の幅を比率で設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TSs6oj80RcI/AAAAAAAAAxs/hm2gp4ELiDI/s800/HeaderRatio.png)

### サンプルコード
<pre class="prettyprint"><code>private void setTableHeaderColumnRaito() {
  int[] list = getWidthRaitoArray();
  //System.out.println("a: "+table.getColumnModel().getTotalColumnWidth());
  //System.out.println("b: "+table.getSize().width);
  int total = table.getSize().width; //table.getColumnModel().getTotalColumnWidth();
  int raito = total/getRaitoTotal(list);
  for(int i=0;i&lt;table.getColumnModel().getColumnCount()-1;i++) {
    TableColumn col = table.getColumnModel().getColumn(i);
    int colwidth = list[i]*raito;
    col.setPreferredWidth(colwidth); //col.setMaxWidth(colwidth);
    total -= colwidth;
  }
  table.getColumnModel().getColumn(
    table.getColumnModel().getColumnCount()-1).setPreferredWidth(total);
  //table.getColumnModel().getColumnCount()-1).setMaxWidth(total);
  table.revalidate();
}

private void setRaito() {
  int[] list = getWidthRaitoArray();
  int total = getTotalColumnWidth(table);
  int raito = total/getRaitoTotal(table, list);
  for(int i=0;i&lt;table.getColumnModel().getColumnCount()-1;i++) {
    TableColumn col = table.getColumnModel().getColumn(i);
    int colwidth = list[i]*raito;
    col.setMaxWidth(colwidth);
    total = total - colwidth;
  }
  //最後のカラムで誤差を吸収
  table.getColumnModel().getColumn(
    table.getColumnModel().getColumnCount()-1).setMaxWidth(total);
  table.revalidate();
}
</code></pre>

### 解説
上記のサンプルでは、`JTextField`にコロン区切りで入力した比率に従って、ヘッダカラムの幅を調整するようになっています。

- `ComponentListener#componentResized(...)`がチェックされている場合
    - `JScrollPane`に追加した`ComponentListener`で、リサイズされる毎に全ての列幅を設定し直すので、フレームのサイズを変更してもカラムの比率は保持される
- `ComponentListener#componentResized(...)`がチェックされていない場合
    - 列幅調整が`AUTO_RESIZE_SUBSEQUENT_COLUMNS`(デフォルト)なので、フレームをリサイズすると、その幅の変更([デルタ](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTable.html#doLayout%28%29))が、リサイズ可能なすべての列に分散して加算減算される
        - このため、入力されている比率とは異なる列幅になる

<!-- dummy comment line for breaking list -->

- - - -
`TableColumn#setMaxWidth`メソッドでカラムの幅を指定する場合は、マウスのドラッグによるサイズの変更はできません。


### 参考リンク
- [デルタの分散 - JTable#doLayout()](http://docs.oracle.com/javase/jp/6/api/javax/swing/JTable.html#doLayout%28%29)

<!-- dummy comment line for breaking list -->

### コメント
