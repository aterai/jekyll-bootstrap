---
layout: post
title: JTableのソート
category: swing
folder: SortableTable
tags: [JTable, JTableHeader]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-01-05

## JTableのソート
`JTable`のヘッダカラムをクリックすることで、行表示を降順、昇順にソートします。以下のサンプルは、[SortableTableExample](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples5.html)を参考にして作成しています。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTTXXYDR5I/AAAAAAAAAkQ/DeBHN6piDhQ/s800/SortableTable.png)

### サンプルコード
<pre class="prettyprint"><code>class SortableTableModel extends DefaultTableModel{
  public SortableTableModel(String[] str, int row) {
    super(str, row);
  }
  public void sortByColumn(int column, boolean isAscent) {
    Collections.sort(getDataVector(), new ColumnComparator(column, isAscent));
    fireTableDataChanged();
  }
}
class ColumnComparator implements Comparator{
  final protected int index;
  final protected boolean ascending;
  public ColumnComparator(int index, boolean ascending) {
    this.index = index;
    this.ascending = ascending;
  }
  public int compare(Object one, Object two) {
    if(one instanceof Vector &amp;&amp; two instanceof Vector) {
      Object oOne = ((Vector)one).elementAt(index);
      Object oTwo = ((Vector)two).elementAt(index);
      if(oOne==null &amp;&amp; oTwo==null) {
        return 0;
      }else if(oOne==null) {
        return ascending ? -1 :  1;
      }else if(oTwo==null) {
        return ascending ?  1 : -1;
      }else if(oOne instanceof Comparable &amp;&amp; oTwo instanceof Comparable) {
        Comparable cOne = (Comparable)oOne;
        Comparable cTwo = (Comparable)oTwo;
        return ascending ? cOne.compareTo(cTwo) : cTwo.compareTo(cOne);
      }
    }
    return 1;
  }
  public int compare(Number o1, Number o2) {
    double n1 = o1.doubleValue();
    double n2 = o2.doubleValue();
    if(n1 &lt; n2) {
      return -1;
    }else if(n1 &gt; n2) {
      return 1;
    }else{
      return 0;
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、カラムヘッダをクリックすることでソートできます。右クリックからポップアップメニューで、行を追加、削除したり、セルをダブルクリックして中身を色々編集するなどしてソートを試してみてください。

複数の列をキーにしてソートしたい場合や、ヘッダがボタンになるのがいやな場合は、[TableSorterでJTableをソート](http://terai.xrea.jp/Swing/TableSorter.html)を参照してください。

`JDK 1.6.0`では、`JTable`標準で簡単にソート機能を追加できるようになっています(参考:[TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html))。

### 参考リンク
- [SortableTableExample](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples5.html)
- [Sorting and Otherwise Manipulating Data - How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)

<!-- dummy comment line for breaking list -->

### コメント
- 非常に参考になりました。すぐに実装に使わせていただきます。 -- [akio](http://terai.xrea.jp/akio.html) 2005-01-12 18:11:14 (水)
- カラムをドラッグして移動したとき、矢印が残ってしまうようです。 ~~元からだったかデグレードしたのかちょっと不明です。~~ 元からのようです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2005-02-25 19:55:01 (金)
- 修正できたかな？ ~~確認中。~~ 確認済み。 -- [aterai](http://terai.xrea.jp/aterai.html) 2005-02-25 20:30:57 (金)
- `Swing`初心者の為このサイトのソースを参考に勉強させて頂いています。 -- [ao](http://terai.xrea.jp/ao.html) 2005-03-11 14:37:03 (金)
- 行を削除した後にソートを降順ソート、昇順ソート、初期状態と３回ソートを行うと削除した行が元に戻ってしまうようです。`TestModel.java`の`removeRow`に`list.remove(index);`を追加したらうまくいきましたが、本当にこれでよいのでしょうか？-- [ao](http://terai.xrea.jp/ao.html) 2005-03-11 14:40:10 (金)
- ~~いいと思います。バグなので修正しておきますm(_ _m)。~~ あ、ダメみたいです。以下のように行番号をキーにして削除しないとソート中は別の行を削除してしまいます。 -- [aterai](http://terai.xrea.jp/aterai.html) 2005-03-11 19:13:45 (金)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>public void removeRow(int index) {
  Integer num = (Integer)getValueAt(index, 0);
  Test test = (Test)list.elementAt(num.intValue()-1);
  list.removeElement(test);
  super.removeRow(index);
}
</code></pre>

- 初期状態に戻すのを止めたほうがいいかもしれません(エクスプローラも初期状態に戻したりしないし)。わざわざ`Vector`で`list`を別に持つ必要も、キーとして番号の列を作る必要もなくなります。 -- [aterai](http://terai.xrea.jp/aterai.html) 2005-03-11 19:23:16 (金)
- こちらのサンプルでは初期状態に戻すのを止めてみました。初期状態戻し有りにしたい場合は、[TableSorterでJTableをソート](http://terai.xrea.jp/Swing/TableSorter.html)の方を参考にしてみてください。 -- [aterai](http://terai.xrea.jp/aterai.html) 2005-03-11 21:08:34 (金)
- ありがとうございます！ -- [G](http://terai.xrea.jp/G.html) 2012-07-12 (木) 14:05:48
    - どうもです。関係ない話ですが、元サンプル(`SortableTableExample`)が公開されているところを探してリンクを修正する予定です。 -- [aterai](http://terai.xrea.jp/aterai.html) 2012-07-13 (金) 17:35:04

<!-- dummy comment line for breaking list -->
