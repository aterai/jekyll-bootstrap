---
layout: post
category: swing
folder: SlideTableRows
title: JTableで行の追加、削除アニメーション
tags: [JTable, Animation]
author: aterai
pubdate: 2009-04-06T14:03:11+09:00
description: JTableの行追加や削除をスライドアニメーションで強調します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTP0i2yxI/AAAAAAAAAkE/DQKpmn3BIQo/s800/SlideTableRows.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2009/04/animating-jtable-rows.html
    lang: en
comments: true
---
## 概要
`JTable`の行追加や削除をスライドアニメーションで強調します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTP0i2yxI/AAAAAAAAAkE/DQKpmn3BIQo/s800/SlideTableRows.png %}

## サンプルコード
<pre class="prettyprint"><code>private void testCreateActionPerformed(ActionEvent e) {
  model.addTest(new Test("New name", ""));
  (new Timer(DELAY, new ActionListener() {
    int i = table.convertRowIndexToView(model.getRowCount() - 1);
    int h = START_HEIGHT;
    @Override public void actionPerformed(ActionEvent e) {
      if (h &lt; END_HEIGHT) {
        table.setRowHeight(i, h++);
      } else {
        ((Timer) e.getSource()).stop();
      }
    }
  })).start();
}

private void deleteActionPerformed(ActionEvent evt) {
  final int[] selection = table.getSelectedRows();
  if (selection.length &lt;= 0) {
    return;
  }
  (new Timer(DELAY, new ActionListener() {
    int h = END_HEIGHT;
    @Override public void actionPerformed(ActionEvent e) {
      h--;
      if (h &gt; START_HEIGHT) {
        for (int i = selection.length - 1; i &gt;= 0; i--)
          table.setRowHeight(selection[i], h);
      } else {
        ((Timer) e.getSource()).stop();
        for (int i = selection.length - 1; i &gt;= 0; i--) {
          model.removeRow(table.convertRowIndexToModel(selection[i]));
        }
      }
    }
  })).start();
}
</code></pre>

## 解説
上記のサンプルでは、`javax.swing.Timer`を使用して、徐々に行の高さを変更することで、アニメーションを行っています。

- 行の追加
    - 高さ`0`の行を追加したあと、`JTable#setRowHeight(int, int)`メソッドを使用してその高さを変更

<!-- dummy comment line for breaking list -->

- 行の削除
    - 選択された行の高さを、`JTable#setRowHeight(int, int)`メソッドを使用して変更
    - 高さが一定以下になったら、その行を削除

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableの行を追加、削除](http://ateraimemo.com/Swing/AddRow.html)
- [JTableの行の高さを変更する](http://ateraimemo.com/Swing/FishEyeTable.html)

<!-- dummy comment line for breaking list -->

## コメント
