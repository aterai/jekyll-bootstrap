---
layout: post
title: JTableで行の追加、削除アニメーション
category: swing
folder: SlideTableRows
tags: [JTable, Animation]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-04-06

## JTableで行の追加、削除アニメーション
`JTable`の行追加や削除をスライドアニメーションで強調します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTTP0i2yxI/AAAAAAAAAkE/DQKpmn3BIQo/s800/SlideTableRows.png %}

### サンプルコード
<pre class="prettyprint"><code>private void testCreateActionPerformed(ActionEvent e) {
  model.addTest(new Test("New name", ""));
  (new javax.swing.Timer(DELAY, new ActionListener() {
    int i = table.convertRowIndexToView(model.getRowCount()-1);
    int h = START_HEIGHT;
    @Override public void actionPerformed(ActionEvent e) {
      if(h&lt;END_HEIGHT) {
        table.setRowHeight(i, h++);
      }else{
        ((javax.swing.Timer)e.getSource()).stop();
      }
    }
  })).start();
}

private void deleteActionPerformed(ActionEvent evt) {
  final int[] selection = table.getSelectedRows();
  if(selection==null || selection.length&lt;=0) return;
  (new javax.swing.Timer(DELAY, new ActionListener() {
    int h = END_HEIGHT;
    @Override public void actionPerformed(ActionEvent e) {
      h--;
      if(h&gt;START_HEIGHT) {
        for(int i=selection.length-1;i&gt;=0;i--)
          table.setRowHeight(selection[i], h);
      }else{
        ((javax.swing.Timer)e.getSource()).stop();
        for(int i=selection.length-1;i&gt;=0;i--)
          model.removeRow(table.convertRowIndexToModel(selection[i]));
      }
    }
  })).start();
}
</code></pre>

### 解説
上記のサンプルでは、`javax.swing.Timer`を使用して、徐々に行の高さを変更することで、アニメーションを行っています。

- 追加
    - 行を追加したあとで、`JTable#setRowHeight(int, int)`メソッドを使用して追加された行の高さを変更

<!-- dummy comment line for breaking list -->

- 削除
    - 選択された行の高さを、`JTable#setRowHeight(int, int)`メソッドを使用して変更
    - 高さが一定以下になったら、選択されていた行を削除

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableの行を追加、削除](http://terai.xrea.jp/Swing/AddRow.html)
- [JTableの行の高さを変更する](http://terai.xrea.jp/Swing/FishEyeTable.html)

<!-- dummy comment line for breaking list -->

### コメント
