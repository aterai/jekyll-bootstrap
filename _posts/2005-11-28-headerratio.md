---
layout: post
category: swing
folder: HeaderRatio
title: TableColumnの幅を比率で設定
tags: [JTable, JTableHeader, TableColumn, JScrollPane]
author: aterai
pubdate: 2005-11-28T18:26:47+09:00
description: 列幅調整がデフォルトのJTableで、ヘッダの各TableColumnが指定した比率の幅になるように設定します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TSs6oj80RcI/AAAAAAAAAxs/hm2gp4ELiDI/s800/HeaderRatio.png
comments: true
---
## 概要
列幅調整がデフォルトの`JTable`で、ヘッダの各`TableColumn`が指定した比率の幅になるように設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TSs6oj80RcI/AAAAAAAAAxs/hm2gp4ELiDI/s800/HeaderRatio.png %}

## サンプルコード
<pre class="prettyprint"><code>private void setTableHeaderColumnRaito() {
  TableColumnModel m = table.getColumnModel();
  List&lt;Integer&gt; list = getWidthRaitoArray();
  int total = table.getSize().width;
  double raito = total / (double) getRaitoTotal(list);
  for (int i = 0; i &lt; m.getColumnCount() - 1; i++) {
    TableColumn col = m.getColumn(i);
    int colwidth = (int) (.5 + list.get(i) * raito);
    col.setPreferredWidth(colwidth);
    total -= colwidth;
  }
  // 最後のカラムで余りを解消
  m.getColumn(m.getColumnCount() - 1).setPreferredWidth(total);
  table.revalidate();
}
</code></pre>

## 解説
上記のサンプルでは、`JTextField`にコロン区切りで入力した比率に従って、各カラムヘッダの幅を調整しています。

- `ComponentListener#componentResized(...)`がチェックされている場合:
    - `JScrollPane`に追加した`ComponentListener`でリサイズが実行されると全ての列幅を設定し直すので、フレームのサイズを変更してもカラムの比率は保持される
- `ComponentListener#componentResized(...)`がチェックされていない場合:
    - 列幅調整が`AUTO_RESIZE_SUBSEQUENT_COLUMNS`(デフォルト)なので、フレームをリサイズするとその幅の変更([デルタ](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#doLayout--))がリサイズ可能なすべての列に分散して加算減算される
        - このため入力されている比率とは異なる列幅になる
    - `TableColumn#setMaxWidth`メソッドでカラムの幅を指定する場合、マウスのドラッグによるリサイズは不可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [デルタの分散 - JTable#doLayout() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTable.html#doLayout--)

<!-- dummy comment line for breaking list -->

## コメント
