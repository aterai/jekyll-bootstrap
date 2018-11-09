---
layout: post
category: swing
folder: TableRowSorter
title: TableRowSorterでJTableのソート
tags: [JTable, TableRowSorter, JTableHeader]
author: aterai
pubdate: 2007-02-12T18:36:03+09:00
description: JDK 6で導入された、TableRowSorterを利用して、JTableの行を降順、昇順にソートします。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUnbg2jyI/AAAAAAAAAmU/-7yjlGSjBmo/s800/TableRowSorter.png
comments: true
---
## 概要
`JDK 6`で導入された、`TableRowSorter`を利用して、`JTable`の行を降順、昇順にソートします。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTUnbg2jyI/AAAAAAAAAmU/-7yjlGSjBmo/s800/TableRowSorter.png %}

## サンプルコード
<pre class="prettyprint"><code>TableModel model = makeTestTableModel();
JTable table = new JTable(model);
RowSorter&lt;TableModel&gt; sorter = new TableRowSorter&lt;TableModel&gt;(model);
table.setRowSorter(sorter);
</code></pre>

## 解説
`JDK 6`では、`JTable`に`TableRowSorter`を設定することで、カラムヘッダのクリックによる行ソートが行えます。

- 以下のように`JTable#autoCreateRowSorter(true)`メソッドを使用した場合も、`JTable`が自動的に`RowSorter`を作成してソートが可能になる
    
    <pre class="prettyprint"><code>JTable table = new JTable(model);
    table.setAutoCreateRowSorter(true);
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
`TableRowSorter`のデフォルトでは、ヘッダクリックで(降順、昇順)とソートが切り替わり、`TableSorter.java`のように(降順、昇順、初期状態)ではなくなっています。上記のサンプルでは、下のボタンをクリックすると、`DefaultRowSorter#setSortKeys(List)`に`null`を代入することで初期状態に戻るようにしています。

- `SwingLabs`の`JXTable`のように「<kbd>Shift</kbd>+ヘッダクリック」で初期状態
    - [TableRowSorterのSortKeysをクリアする](https://ateraimemo.com/Swing/ClearSortingState.html)
- `TableSorter.java`のようにヘッダクリックで降順、昇順、初期状態とループ
    - [TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更](https://ateraimemo.com/Swing/TriStateSorting.html)

<!-- dummy comment line for breaking list -->

- - - -
~~第二キーを使ったソートは`TableRowSorter`版では存在しない?ようなので、`TableSorter.java`を使う場合もまだあるかもしれません。~~ 複数キーを使ったソートも可能です(ページ下部にあるsyoさんのコメントを参照)。デフォルトではソートキーは`3`つで、ヘッダにマークが表示されるのは最新のソートキーのみですが、クリックした順に保持されるようです。詳しくはドキュメントや[Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html)などを参照してください。

- [Multisort Table Header Cell Renderer « Java Tips Weblog](https://tips4java.wordpress.com/2010/08/29/multisort-table-header-cell-renderer/)
    - 第二キー以下を薄く表示するサンプルがある
- [JTableの複数キーを使ったソートをヘッダに表示する](https://ateraimemo.com/Swing/MultisortHeaderRenderer.html)
    - ソートキーの状態を文字列にして追加

<!-- dummy comment line for breaking list -->

- - - -
- `TableModel`に要素を追加した後で、`table.setRowSorter(sorter);`とすると、`IndexOutOfBoundsException`: `Invalid range`が、モデルへの追加、削除、編集中に別の行クリックなどで発生する
    - 以下のサンプルの場合、`model.fireTableDataChanged()`メソッドを`table.setRowSorter(sorter)`の後で呼び出すと回避可能

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.table.*;
public class RowSorterTest extends JPanel {
  public RowSorterTest() {
    super(new BorderLayout());
    final DefaultTableModel model = new DefaultTableModel(null, new String[] {"A", "B", "C"});
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
    frame.setSize(320, 240);
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
</code></pre>

- [RowSorter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/RowSorter.html)

<!-- dummy comment line for breaking list -->
<blockquote><p>
 `RowSorter`の具象実装は、`TableModel`、`ListModel`などのモデルを参照する必要があります。`JTable`や`JList`などのビュークラスも、モデルを参照します。順序の依存性を回避するため、`RowSorter`実装がモデル上にリスナーをインストールしないようにしてください。モデルが変更されると、ビュークラスが`RowSorter`を呼び出します。例えば、`TableModel` `JTable` で行が更新された場合、`rowsUpdated`が呼び出されます。モデルが変更されると、ビューは、`modelStructureChanged`、`allRowsChanged`、`rowsInserted`、`rowsDeleted`、`rowsUpdated`のいずれかのメソッドを呼び出します。
</p></blockquote>

## 参考リンク
- [TableRowSorter (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/table/TableRowSorter.html)
- [How to Use Tables](https://docs.oracle.com/javase/tutorial/uiswing/components/table.html)
- [TableSorterでJTableをソート](https://ateraimemo.com/Swing/TableSorter.html)
- [TableRowSorterのSortKeysをクリアする](https://ateraimemo.com/Swing/ClearSortingState.html)
- [TableRowSorterのソートをヘッダクリックで昇順、降順、初期状態に変更](https://ateraimemo.com/Swing/TriStateSorting.html)
- [Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html)

<!-- dummy comment line for breaking list -->

## コメント
- `DefaultRowSorter#setMaxSortKeys(int)`で複数のキーを用いたソートも出来ているように思います(`b86`)。ただ、ヘッダー部分がわかりにくいですが。 -- *syo* 2006-08-03 (木) 11:12:55
    - ご指摘ありがとうございます。なるほど、こちら([Tableの内容をソート](http://syo.cocolog-nifty.com/freely/2006/08/table_616d.html))を使えばうまくいきそうですね。解説を修正しました。 -- *aterai* 2006-08-03 (木) 12:34:53
- `renderer`がないので、基本的に数字は左揃え、文字列は右揃えで、中央揃えするにはどうすれば宜しいでしょうか？ -- *パンダ* 2007-06-14 (木) 09:40:20
    - 長いので[JTableのセル文字揃え](https://ateraimemo.com/Swing/CellTextAlignment.html)に移動しました。 -- *aterai* 2007-06-14 (木) 13:19:36

<!-- dummy comment line for breaking list -->
