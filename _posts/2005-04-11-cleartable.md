---
layout: post
title: JTableの行を全削除
category: swing
folder: ClearTable
tags: [JTable, DefaultTableModel]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-04-11

## JTableの行を全削除
`JTable`の行を一括で全削除します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJISEHcVI/AAAAAAAAAT4/syR1Ucd5n5o/s800/ClearTable.png)

### サンプルコード
<pre class="prettyprint"><code>button.addActionListener(new AbstractAction("clear") {
  @Override public void actionPerformed(ActionEvent e) {
    DefaultTableModel model = (DefaultTableModel)table.getModel();
    model.setRowCount(0);
  }
});
</code></pre>

### 解説
モデルが`DefaultTableModel`を継承しているなら、`setRowCount(0)`ですべての行を削除することができます。この場合、モデルを作り直している訳ではないので、カラムの幅などは削除する前と同じ値を保っています。

`DefaultTableModel`を継承していない場合は、モデルに以下の要領(詳細は`DefaultTableModel.java`のソースを参照)で行を全削除するメソッドを実装します。

<pre class="prettyprint"><code>public void clear() {
  //以下のdataVectorは実装に合わせて変更する
  int size = dataVector.size();
  dataVector.clear();
  fireTableRowsDeleted(0, size-1);
  //fireTableDataChanged();
}
</code></pre>

- - - -
`JTable#setAutoCreateColumnsFromModel(false)`としておけば、`TableModel`を入れ替えても、上記の方法と同じように既存の列はクリアされません。

<pre class="prettyprint"><code>//((DefaultTableModel)table.getModel()).setRowCount(0);
table.setAutoCreateColumnsFromModel(false);
table.setModel(new DefaultTableModel());
</code></pre>

### 参考リンク
- [JTableの行を追加、削除](http://terai.xrea.jp/Swing/AddRow.html)
- [JTableのセルにJButtonを追加して行削除](http://terai.xrea.jp/Swing/DeleteButtonInCell.html)

<!-- dummy comment line for breaking list -->

### コメント
- ソートした状態で「remove all rows」を押すと例外が発生しますよ -- [tohrisugari](http://terai.xrea.jp/tohrisugari.html) 2013-07-23 (火) 08:51:30
    - ご指摘ありがとうございます。確かに`ArrayIndexOutOfBoundsException: 0 >= 0`が発生していますね。以前は正常だったはず？と思って調べてみたら、[Bug ID: JDK-6967479 JTable sorter fires even if the model is empty](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6967479)が原因？で、`6u10,6u20`以降で発生しているようです。 ~~`8`で修正される予定？みたいなので、しばらくは別の方法を使用するように修正し~~ ~~何時修正されるか分からないので回避方法を考えてみようと思います。~~ -- [aterai](http://terai.xrea.jp/aterai.html) 2013-07-23 (火) 10:47:23
    - ~~`model.setRowCount(0);`の前に、`table.setRowSorter(null);`とソートを不可にする修正などを追加しました。~~ [Bug ID: JDK-6967479 JTable sorter fires even if the model is empty](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6967479)にあるように`DefaultTableModel#getColumnClass`をオーバーライドする方法が簡単なので、そのように修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-07-23 (火) 14:44:15
- Javaのバグだったのですね。ちなみに私はDefaultTableModel#getColumnClassのオーバライドでは解決しなかったので、table.setRowSorter(null)の対応案を参考にさせていただきました。 -- [tohrisugari](http://terai.xrea.jp/tohrisugari.html) 2013-07-26 (金) 12:08:04
    - 行の追加削除があるサンプルなのに、`model`が空の場合でも`TableModel#getValueAt(0, column).getClass()` ~~を呼ぶような~~ が呼ばれる可能性がある手抜きをしているのが悪いので、`Java`のバグというのはかわいそうな気も(面倒なので出来れば修正して欲しいですが)します(^^;。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-07-26 (金) 18:46:28

<!-- dummy comment line for breaking list -->

