---
layout: post
category: swing
folder: ClearTable
title: JTableの行を全削除
tags: [JTable, DefaultTableModel]
author: aterai
pubdate: 2005-04-11T02:13:34+09:00
description: JTableのモデルから、カラムヘッダの状態は変更せず、すべての行を一括で削除します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJISEHcVI/AAAAAAAAAT4/syR1Ucd5n5o/s800/ClearTable.png
comments: true
---
## 概要
`JTable`のモデルから、カラムヘッダの状態は変更せず、すべての行を一括で削除します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTJISEHcVI/AAAAAAAAAT4/syR1Ucd5n5o/s800/ClearTable.png %}

## サンプルコード
<pre class="prettyprint"><code>button.addActionListener(new AbstractAction("clear") {
  @Override public void actionPerformed(ActionEvent e) {
    DefaultTableModel model = (DefaultTableModel) table.getModel();
    model.setRowCount(0);
  }
});
</code></pre>

## 解説
- `TableModel`が`DefaultTableModel`を継承している場合、`model.setRowCount(0)`ですべての行が削除される
- 空の`TableModel`を`JTable`に設定することでも、行の全削除を行うことが可能だが、ヘッダモデルの再作成が発生し、カラム幅や順番などが初期化されてしまう
    - `JTable#setAutoCreateColumnsFromModel(false)`とカラムをモデルから自動生成しないようにしておけば、`TableModel`を入れ替えても、列幅などは保存される

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.setAutoCreateColumnsFromModel(false);
table.setModel(new DefaultTableModel());
</code></pre>

- - - -
`DefaultTableModel`を継承していない場合は、モデルに以下の要領(詳細は`DefaultTableModel.java`のソースを参照)で行を全削除するメソッドを実装します。

<pre class="prettyprint"><code>public void clear() {
  //以下のdataVectorは実装に合わせて変更する
  int size = dataVector.size();
  dataVector.clear();
  fireTableRowsDeleted(0, size - 1);
  //fireTableDataChanged();
}
</code></pre>

## 参考リンク
- [JTableの行を追加、削除](https://ateraimemo.com/Swing/AddRow.html)
- [JTableのセルにJButtonを追加して行削除](https://ateraimemo.com/Swing/DeleteButtonInCell.html)
- [JDK-8032874 ArrayIndexOutOfBoundsException in JTable while clearing data in JTable - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8032874)
    - コメントの`ArrayIndexOutOfBoundsException`と似ている？`JDK-8032874`の件は修正済み

<!-- dummy comment line for breaking list -->

## コメント
- ソートした状態で「remove all rows」を押すと例外が発生しますよ -- *tohrisugari* 2013-07-23 (火) 08:51:30
    - ご指摘ありがとうございます。確かに`ArrayIndexOutOfBoundsException: 0 >= 0`が発生していますね。以前は正常だったはず？と思って調べてみたら、[Bug ID: JDK-6967479 JTable sorter fires even if the model is empty](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6967479)が原因？で、`6u10,6u20`以降で発生しているようです。 ~~`8`で修正される予定？らしいので、しばらくは別の方法を使用するように修正し~~ ~~何時修正されるか分からないので回避方法を考えてみようと思います。~~ -- *aterai* 2013-07-23 (火) 10:47:23
    - ~~`model.setRowCount(0);`の前に、`table.setRowSorter(null);`とソートを不可にする修正などを追加しました。~~ [Bug ID: JDK-6967479 JTable sorter fires even if the model is empty](http://bugs.java.com/bugdatabase/view_bug.do?bug_id=6967479)にあるように`DefaultTableModel#getColumnClass`をオーバーライドする方法が簡単なので、そのように修正しました。 -- *aterai* 2013-07-23 (火) 14:44:15
- Javaのバグだったのですね。ちなみに私はDefaultTableModel#getColumnClassのオーバーライドでは解決しなかったので、table.setRowSorter(null)の対応案を参考にさせていただきました。 -- *tohrisugari* 2013-07-26 (金) 12:08:04
    - 行の追加削除があるサンプルなのに、`model`が空の場合でも`TableModel#getValueAt(0, column).getClass()` ~~を呼ぶような~~ が呼ばれる可能性がある手抜きをしているのが悪いので、`Java`のバグというのはかわいそうな気も(面倒なので出来れば修正して欲しいですが)します(^^;。 -- *aterai* 2013-07-26 (金) 18:46:28

<!-- dummy comment line for breaking list -->
