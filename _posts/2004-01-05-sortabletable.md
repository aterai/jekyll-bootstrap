---
layout: post
category: swing
folder: SortableTable
title: JTableのソート
tags: [JTable, JTableHeader]
author: aterai
pubdate: 2004-01-05
description: JTableのカラムヘッダをクリックすることで、行表示を降順、昇順にソートします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTXXYDR5I/AAAAAAAAAkQ/DeBHN6piDhQ/s800/SortableTable.png
comments: true
---
## 概要
`JTable`のカラムヘッダをクリックすることで、行表示を降順、昇順にソートします。以下のサンプルは、~~[SortableTableExample](http://www2.gol.com/users/tame/swing/examples/JTableExamples5.html)~~を参考にして作成しています。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTTXXYDR5I/AAAAAAAAAkQ/DeBHN6piDhQ/s800/SortableTable.png %}

## サンプルコード
<pre class="prettyprint"><code>class SortableTableModel extends DefaultTableModel {
  public SortableTableModel(String[] str, int row) {
    super(str, row);
  }
  public void sortByColumn(int column, boolean isAscent) {
    Collections.sort(getDataVector(), new ColumnComparator(column, isAscent));
    fireTableDataChanged();
  }
}

class ColumnComparator implements Comparator&lt;Object&gt;, Serializable {
  private static final long serialVersionUID = 1L;
  protected final int index;
  protected final boolean ascending;

  protected ColumnComparator(int index, boolean ascending) {
    this.index = index;
    this.ascending = ascending;
  }

  @SuppressWarnings("unchecked")
  @Override public int compare(Object one, Object two) {
    if (one instanceof List &amp;&amp; two instanceof List) {
      Comparable&lt;Object&gt; o1 = (Comparable&lt;Object&gt;) ((List&lt;Object&gt;) one).get(index);
      Comparable&lt;Object&gt; o2 = (Comparable&lt;Object&gt;) ((List&lt;Object&gt;) two).get(index);
      int c = Objects.compare(
          o1, o2, Comparator.nullsFirst(Comparator.&lt;Comparable&lt;Object&gt;&gt;naturalOrder()));
      return c * (ascending ? 1 : -1);
    }
    return 0;
}
</code></pre>

## 解説
上記のサンプルでは、各カラムヘッダのクリックでソート可能になっています。

- メモ
    - 複数の列をキーにしてソートしたい場合は、[TableSorterでJTableをソート](https://ateraimemo.com/Swing/TableSorter.html)を参照
    - `JDK 1.6.0`で、`JTable`のソートが標準機能として追加された
        - [TableRowSorterでJTableのソート](https://ateraimemo.com/Swing/TableRowSorter.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- ~~[SortableTableExample](http://www2.gol.com/users/tame/swing/examples/JTableExamples5.html)~~
- [Sorting and Otherwise Manipulating Data - How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](https://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)

<!-- dummy comment line for breaking list -->

## コメント
- 非常に参考になりました。すぐに実装に使わせていただきます。 -- *akio* 2005-01-12 18:11:14 (水)
- カラムをドラッグして移動したとき、矢印が残ってしまうようです。 ~~元からかデグレードしたのかちょっと不明です。~~ 元からのようです。 -- *aterai* 2005-02-25 19:55:01 (金)
- 修正できたかな？ ~~確認中。~~ 確認済み。 -- *aterai* 2005-02-25 20:30:57 (金)
- `Swing`初心者の為このサイトのソースを参考に勉強させて頂いています。 -- *ao* 2005-03-11 14:37:03 (金)
- 行を削除した後にソートを降順ソート、昇順ソート、初期状態と３回ソートを行うと削除した行が元に戻ってしまうようです。`TestModel.java`の`removeRow`に`list.remove(index);`を追加したらうまくいきましたが、本当にこれでよいのでしょうか？ -- *ao* 2005-03-11 14:40:10 (金)
- ~~いいと思います。バグなので修正しておきますm(_ _m)。~~ あ、ダメみたいです。以下のように行番号をキーにして削除しないとソート中は別の行を削除してしまいます。 -- *aterai* 2005-03-11 19:13:45 (金)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public void removeRow(int index) {
  Integer num = (Integer) getValueAt(index, 0);
  Test test = (Test) list.elementAt(num.intValue() - 1);
  list.removeElement(test);
  super.removeRow(index);
}
</code></pre>

- 初期状態に戻すのを止めたほうがいいかもしれません(エクスプローラも初期状態に戻したりしないし)。わざわざ`Vector`で`list`を別に持つ必要も、キーとして番号の列を作る必要もなくなります。 -- *aterai* 2005-03-11 19:23:16 (金)
- こちらのサンプルでは初期状態に戻すのを止めてみました。初期状態戻し有りにしたい場合は、[TableSorterでJTableをソート](https://ateraimemo.com/Swing/TableSorter.html)の方を参考にしてみてください。 -- *aterai* 2005-03-11 21:08:34 (金)
- ありがとうございます！ -- *G* 2012-07-12 (木) 14:05:48
    - どうもです。関係ない話ですが、元サンプル(`SortableTableExample`)が公開されているところを探してリンクを修正する予定です。 -- *aterai* 2012-07-13 (金) 17:35:04

<!-- dummy comment line for breaking list -->
