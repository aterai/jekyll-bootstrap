---
layout: post
title: TableSorterでJTableをソート
category: swing
folder: TableSorter
tags: [JTable, TableSorter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-02-28

## TableSorterでJTableをソート
`JDK 1.5.0`以前に、`The Java™ Tutorial`にあった`TableSorter.java`を使用して、`JTable`の行を降順、昇順、初期状態にソートします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTUp0MLx6I/AAAAAAAAAmY/omjw4LoJbbc/s800/TableSorter.png)

### サンプルコード
<pre class="prettyprint"><code>//DefaultTableModel model = new DefaultTableModel();
TestModel model = new TestModel();
TableSorter sorter = new TableSorter(model);
JTable table = new JTable(sorter);
sorter.setTableHeader(table.getTableHeader());
</code></pre>

### 解説
`The Java™ Tutorial`版の`TableSorter`を使用して、[JTableのソート](http://terai.xrea.jp/Swing/SortableTable.html)で使用しているものと同じ`TableModel`でソートしています。

`TableSorter`には、<kbd>Ctrl</kbd>キーを押しながらヘッダをクリックすると、そのカラムを第二キーとしてソートする機能もあります。

`JDK 1.4.x`と`Windows XP`の環境で、ヘッダにカーソルを置いてもロールオーバーしない場合があるようです。上記のスクリーンショットは`JDK 1.5.0_01`で撮っています。

- - - -
`JDK 1.5.0`で`Generics`の警告を出さないようにするには、`TableSorter.java`に、以下のような修正を加えれば良いようです。

<pre class="prettyprint"><code>private static class ComparableComparator implements Comparator {
  @SuppressWarnings("unchecked")
  public int compare(Object o1, Object o2) {
    return ((Comparable)o1).compareTo(o2);
  }
}
public static final ComparableComparator COMPARABLE_COMAPRATOR
    = new ComparableComparator();
public static final ComparableComparator LEXICAL_COMPARATOR
    = new ComparableComparator() {
  @SuppressWarnings("unchecked")
  public int compare(Object o1, Object o2) {
    return o1.toString().compareTo(o2.toString());
  }
};
private TableModelListener tableModelListener;
private Map&lt;Class, Comparator&gt; columnComparators = new HashMap&lt;Class, Comparator&gt;();
private List&lt;Directive&gt; sortingColumns = new ArrayList&lt;Directive&gt;();

protected ComparableComparator getComparator(int column) {
  Class columnType = tableModel.getColumnClass(column);
  ComparableComparator comparator
      = (ComparableComparator) columnComparators.get(columnType);
    if (comparator != null) {
      return comparator;
    }
 private class Row implements Comparable&lt;Row&gt; {
  private int modelIndex;
  public Row(int index) {
    this.modelIndex = index;
  }
  public int compareTo(Row o) {
    int row1 = modelIndex;
    int row2 = o.modelIndex;
//......
</code></pre>

- - - -
- `JDK 1.6.0`から`JTable`には標準でソート機能が追加されています。
    - [SORTING AND FILTERING TABLES](http://java.sun.com/developer/JDCTechTips/2005/tt1115.html#2)
    - [TableRowSorterでJTableのソート](http://terai.xrea.jp/Swing/TableRowSorter.html)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Sorting and Otherwise Manipulating Data - How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)
- [How to Use Tables](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html)
- [Generics - Simple method but hard with generics: compareTo()](https://forums.oracle.com/thread/1185784)
- [TableSorter.java](http://docs.oracle.com/javase/tutorial/uiswing/examples/components/TableSorterDemoProject/src/components/TableSorter.java)

<!-- dummy comment line for breaking list -->

### コメント
- いつもお世話になっております。 `jtable`を下記のように初期化します。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//DefaultTableModel model = new DefaultTableModel();
TestModel model = new TestModel();
TableSorter sorter = new TableSorter(model);
JTable table = new JTable(sorter);
sorter.setTableHeader(table.getTableHeader());
</code></pre>

- その後、ソートした状態で、一行づつのデータを取り出した場合、 どうすればよろしいでしょうか？例えば、`No.`欄をソートして、下り順で`No.`欄と`Name`欄のデータを`System.out.println(model.getValueAt(row, 1))`したい場合、その`row`は`sorter`に関連していると思います。 `row=?`かが分かりません。説明下手で、大変申し訳ございません。ご教示をください。よろしくお願い致します。 -- [Tiger](http://terai.xrea.jp/Tiger.html) 2010-08-05 (木) 06:07:47
    - こんにちは。多分、`sorter.modelIndex(viewIndex);`でいいと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-05 (木) 13:17:51

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.table.*;
public class SorterModelIndex {
  public JComponent makeUI() {
    String[] columnNames = {"String", "Integer", "Boolean"};
    Object[][] data = {
      {"aaa", 12, true}, {"bbb", 5, false},
      {"CCC", 92, true}, {"DDD", 0, false}
    };
    final DefaultTableModel model = new DefaultTableModel(data, columnNames) {
      @Override public Class&lt;?&gt; getColumnClass(int column) {
        return getValueAt(0, column).getClass();
      }
    };
    final TableSorter sorter = new TableSorter(model);
    final JTable table = new JTable(sorter);
    sorter.setTableHeader(table.getTableHeader());
    table.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
      public void valueChanged(ListSelectionEvent e) {
        int viewIndex = table.getSelectedRow();
        if (!e.getValueIsAdjusting() &amp;&amp; viewIndex&gt;=0) {
          Object o = model.getValueAt(sorter.modelIndex(viewIndex), 0);
          System.out.println(o);
        }
      }
    });

    JPanel p = new JPanel(new BorderLayout());
    p.add(new JScrollPane(table));
    return p;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new SorterModelIndex().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>

- 早速のご回答、ありがとうございました。 選択された行の値を取り出すことができますが、今回表(`jTable`)の内容を`CSV`に書き出そうとしております。即ち選択した行がない場合、ソートをして(上り順`CCC`、`DDD`, `aaa`、`bbb`), `jTable.getValueAt(sorter.modelIndex(i),j);`（ `i`:行　`j`：列）、書き出した結果は（`aaa`, `bbb`, `CCC`, `DDD`）。即ち`sorter`していなかったの状態で書き出されました。読みにくいかもしれませんが、ご教示ください。 宜しくお願い致します -- [Tiger](http://terai.xrea.jp/Tiger.html) 2010-08-05 (木) 15:42:51
    - `JTable`に表示されている見たまま(全選択、<kbd>Ctrl+C</kbd>でコピーして`TSV`)の状態でということでしょうか。それなら`sorter`は関係なく、以下のように`JTable#getValueAt`メソッドを普通に使えばいいかもしれません(`TableModel#getValueAt`と`JTable#getValueAt`の違いに注意)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-08-05 (木) 17:54:10

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>p.add(new JButton(new AbstractAction("test") {
  @Override public void actionPerformed(ActionEvent e) {
    for (int i=0; i&lt;table.getRowCount(); i++) {
      for (int j=0; j&lt;table.getColumnCount(); j++) {
        //Object o = table.getValueAt(i, table.convertColumnIndexToView(j));
        Object o = table.getValueAt(i, j);
        System.out.print(o+",");
      }
      System.out.print("\n");
    }
    System.out.println("----");
  }
}), BorderLayout.SOUTH);
</code></pre>

- ありがとうございました。ご指摘の通り、できました。 -- [Tiger](http://terai.xrea.jp/Tiger.html) 2010-08-05 (木) 18:08:42
- いつもお世話になっております。`JDK1.5`を使っています。`Name`と`Comment`欄をソートするとき、`No.`欄はソートさせないで、固定のままできますか？ご教示をよろしくお願いいたします。 -- [Tiger](http://terai.xrea.jp/Tiger.html) 2010-09-10 (金) 12:41:32
    - こんにちは。以下のようなレンダラーを使って、表示を`row(View)`にしてしまうのが簡単な気がします(<kbd>Ctrl+C</kbd>などでコピーすると`Model`の値がコピーされたりしますが…)。 -- [aterai](http://terai.xrea.jp/aterai.html) 2010-09-10 (金) 14:45:58

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>TableColumn col = table.getColumnModel().getColumn(0);
col.setCellRenderer(new DefaultTableCellRenderer() {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object v, boolean isS, boolean hasF, int row, int col) {
    Component c = super.getTableCellRendererComponent(table, v, isS, hasF, row, col);
    if(c instanceof JLabel) ((JLabel)c).setText(""+row);
    return c;
  }
});
</code></pre>
- ご教示、ありがとうございました。思ったとおりの動きです。 -- [Tiger](http://terai.xrea.jp/Tiger.html) 2010-09-10 (金) 16:32:27

<!-- dummy comment line for breaking list -->

