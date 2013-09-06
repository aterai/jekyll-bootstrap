---
layout: post
title: TableRowSorterでJTableのソート
category: swing
folder: TableRowSorter
tags: [JTable, TableRowSorter, JTableHeader]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-02-12

## TableRowSorterでJTableのソート
`JDK 6`で導入された、`TableRowSorter`を利用して、`JTable`の行を降順、昇順にソートします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUnbg2jyI/AAAAAAAAAmU/-7yjlGSjBmo/s800/TableRowSorter.png)

### サンプルコード
<pre class="prettyprint"><code>TableModel model = makeTestTableModel();
JTable table = new JTable(model);
RowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model);
table.setRowSorter(sorter);
</code></pre>

### 解説
`JDK 6`では、`JTable`に`TableRowSorter`を設定することで、カラムヘッダのクリックによる行ソートが行えます。

以下のように、`JTable#autoCreateRowSorter(true);`メソッドを使用した場合も、`JTable`が自動的に`RowSorter`を作成して、ソートが出来るようになります。

<pre class="prettyprint"><code>JTable table = new JTable(model);
table.setAutoCreateRowSorter(true);
</code></pre>

- - - -
`TableRowSorter`のデフォルトでは、ヘッダクリックで(降順、昇順)とソートが切り替わり、`TableSorter.java`のように(降順、昇順、初期状態)ではなくなっています。上記のサンプルでは、下のボタンをクリックすると、`DefaultRowSorter#setSortKeys(List)`に`null`を代入することで初期状態に戻るようにしています。

- `SwingLabs`の`JXTable`のように「<kbd>Shift</kbd>+ヘッダクリック」で初期状態
    - [TableRowSorterのSortKeysをクリアする](http://terai.xrea.jp/Swing/ClearSortingState.html)
- `TableSorter.java`のようにヘッダクリックで降順、昇順、初期状態とループ
    - [TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更](http://terai.xrea.jp/Swing/TriStateSorting.html)

<!-- dummy comment line for breaking list -->

- - - -
~~第二キーを使ったソートは`TableRowSorter`版では出来ない?ようなので、`TableSorter.java`を使う場合もまだあるかもしれません。~~ 複数キーを使ったソートも可能です(ページ下部にあるsyoさんのコメントを参照)。デフォルトではソートキーは`3`つで、ヘッダにマークが表示されるのは最新のソートキーのみですが、クリックした順に保持されるようです。詳しくはドキュメントや[Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html)などを参照してください。

- [Multisort Table Header Cell Renderer « Java Tips Weblog](http://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
    - 第二キー以下を薄く表示するサンプルがあります。

<!-- dummy comment line for breaking list -->

- - - -
- `TableModel`に要素を追加した後で、`table.setRowSorter(sorter);`とすると、`IndexOutOfBoundsException`: `Invalid range`が、モデルへの追加、削除、編集中に別の行クリックなどで発生する。
    - 以下のサンプルの場合、`model.fireTableDataChanged()`メソッドを`table.setRowSorter(sorter)`の後で呼び出すと回避できる。

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.table.*;
public class RowSorterTest extends JPanel{
  public RowSorterTest() {
    super(new BorderLayout());
    final DefaultTableModel model = new DefaultTableModel(null, new String[] {"A","B","C"});
    JTable table = new JTable(model);
    TableRowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model);
    //table.setRowSorter(sorter); // OK
    model.addRow(new String[] {"aa", "bb", "cc"});
    model.addRow(new String[] {"dd", "ee", "ff"});
    table.setRowSorter(sorter); // IndexOutOfBoundsException: Invalid range
    //model.fireTableDataChanged(); // &lt;----
    add(new JButton(new AbstractAction("model.addRow(...); -&gt; IndexOutOfBoundsException") {
      @Override public void actionPerformed(ActionEvent e) {
        model.addRow(new String[] {"gg", "hh", "ii"});
      }
    }), BorderLayout.SOUTH);
    add(new JScrollPane(table));
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() { createAndShowGUI(); }
    });
  }
  public static void createAndShowGUI() {
    JFrame frame = new JFrame("Test");
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(new RowSorterTest());
    frame.setSize(320,240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
</code></pre>

- [RowSorter (Java Platform SE 6)](http://docs.oracle.com/javase/jp/6/api/javax/swing/RowSorter.html)
    - `RowSorter`の具象実装は、`TableModel`、`ListModel`などのモデルを参照する必要があります。`JTable`や`JList`などのビュークラスも、モデルを参照します。順序の依存性を回避するため、`RowSorter`実装がモデル上にリスナーをインストールしないようにしてください。モデルが変更されると、ビュークラスが`RowSorter`を呼び出します。例えば、`TableModel` `JTable` で行が更新された場合、`rowsUpdated`が呼び出されます。モデルが変更されると、ビューは、`modelStructureChanged`、`allRowsChanged`、`rowsInserted`、`rowsDeleted`、`rowsUpdated`のいずれかのメソッドを呼び出します。

<!-- dummy comment line for breaking list -->

### 参考リンク
- [How to Use Tables](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html)
- [TableSorterでJTableをソート](http://terai.xrea.jp/Swing/TableSorter.html)
- [TableRowSorterのSortKeysをクリアする](http://terai.xrea.jp/Swing/ClearSortingState.html)
- [TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更](http://terai.xrea.jp/Swing/TriStateSorting.html)
- [Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html)

<!-- dummy comment line for breaking list -->

### コメント
- `DefaultRowSorter#setMaxSortKeys(int)`で複数のキーを用いたソートも出来ているように思います(`b86`)。ただ、ヘッダー部分がわかりにくいですが。 -- [syo](http://terai.xrea.jp/syo.html) 2006-08-03 (木) 11:12:55
    - ご指摘ありがとうございます。なるほど、こちら([Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html))を使えばうまくいきそうですね。解説を修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-08-03 (木) 12:34:53
- `renderer`がないので、基本的に数字は左揃え、文字列は右揃えで、中央揃えするにはどうすれば宜しいでしょうか？ -- [パンダ](http://terai.xrea.jp/パンダ.html) 2007-06-14 (木) 09:40:20
    - 長いので[JTableのセル文字揃え](http://terai.xrea.jp/Swing/CellTextAlignment.html)に移動しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2007-06-14 (木) 13:19:36

<!-- dummy comment line for breaking list -->

