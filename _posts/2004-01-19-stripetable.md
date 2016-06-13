---
layout: post
category: swing
folder: StripeTable
title: TableCellRendererでセルの背景色を変更
tags: [JTable, TableCellRenderer, UIManager]
author: aterai
pubdate: 2004-01-19
description: TableCellRendererを継承するレンダラーを作ってテーブルのセルを修飾します。
comments: true
---
## 概要
`TableCellRenderer`を継承するレンダラーを作ってテーブルのセルを修飾します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTT1bwXoBI/AAAAAAAAAlE/jmpoFwDpvqs/s800/StripeTable.png %}

## サンプルコード
<pre class="prettyprint"><code>class StripeTableRenderer extends DefaultTableCellRenderer {
  private static final Color evenColor = new Color(240, 240, 255);
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
                           boolean isSelected, boolean hasFocus,
                           int row, int column) {
    super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column);
    if (isSelected) {
      setForeground(table.getSelectionForeground());
      setBackground(table.getSelectionBackground());
    } else {
      setForeground(table.getForeground());
      setBackground((row % 2 == 0) ? evenColor : table.getBackground());
    }
    setHorizontalAlignment((value instanceof Number) ? RIGHT : LEFT);
    return this;
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下のようなセルレンダラーを作成し、`Object`を継承するクラスのデフォルトレンダラーとして設定しています。

- 奇数偶数で行の背景色を変更してテーブルをストライプ模様にする
- 第`0`列のカラムのセルを右寄せ
    - ここでは、`TableColumn#setCellRenderer(TableCellRenderer)`を使わず、`Object.classのDefaultRenderer`ひとつにまとめているため、`TableModel#getColumnClass(0)`が`Integer.class`を返すようにしている
    - メモ: `JTable#setDefaultRenderer(Class, TableCellRenderer)`でクラスに関連付けるより、各カラムに関連付けした方が優先順位が高い

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.setDefaultRenderer(Object.class, new StripeTableRenderer());
</code></pre>

あるセルが描画されるとき、設定された`TableCellRenderer`の`getTableCellRendererComponent`メソッドが呼び出されます。レンダラーは、引数などから得られる情報(選択されているか、何行何列目かなど)を使って、コンポーネントを修飾してから`return`します。

サンプルの`TestRenderer`では、`JLabel`を継承する`DefaultTableCellRenderer`を継承しているので、自分自身(`this`)を`setForeground`、`setHorizontalAlignment`などのメソッドで修飾し直し、さらに自分自身(`this`)を戻り値としています。このようにコンポーネントを使い回しているため、セルの数が膨大になっても、オブジェクトを大量に生成しなくて済むようになっています。

また、返されたコンポーネントはセルの描画のためだけに利用され、マウスイベントなどは無視されます。

- - - -
セルレンダラーで色を変更する代わりに、以下のように`JTable#prepareRenderer`メソッドをオーバーライドする方法もあります。使用するセルレンダラーに関係なく、テーブル全体で前処理することができます。このため、`Number`クラス用のデフォルトレンダラーである`JTable$NumberRenderer`がそのまま使われるので、`TableModel#getColumnClass(int)`が、`Number.class`を返すようにしておけば、勝手に右寄せしてくれます。

<pre class="prettyprint"><code>JTable table = new JTable(model) {
  private final Color evenColor = new Color(240, 240, 255);
  @Override public Component prepareRenderer(TableCellRenderer tcr, int row, int column) {
    Component c = super.prepareRenderer(tcr, row, column);
    if (isRowSelected(row)) {
      c.setForeground(getSelectionForeground());
      c.setBackground(getSelectionBackground());
    } else {
      c.setForeground(getForeground());
      c.setBackground((row % 2 == 0) ? evenColor : getBackground());
    }
    return c;
  }
};
</code></pre>

- - - -
`JDK 1.6.0_10`以降なら、以下のように設定する方法もあります。

- [java.net Forums : JTable-Zebra with one line ... ...](http://forums.java.net/jive/thread.jspa?messageID=338905)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>UIManager.put("Table.alternateRowColor", Color.PINK);
</code></pre>

- 注: デフォルトの`Boolean`用レンダラーの背景色は変更されない

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import javax.swing.*;
import javax.swing.table.*;
public class TableAlternateRowColorTest {
  public static void main(String... args) {
    EventQueue.invokeLater(() -&gt; {
      UIManager.put("Table.alternateRowColor", Color.ORANGE);
      String[] columnNames = {"String", "Integer", "Boolean"};
      Object[][] data = {
        {"A", 1, true}, {"B", 2, false}, {"C", 0, true}
      };
      TableModel model = new DefaultTableModel(data, columnNames) {
        @Override public Class&lt;?&gt; getColumnClass(int column) {
          return getValueAt(0, column).getClass();
        }
      };
      JFrame f = new JFrame();
      f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      f.getContentPane().add(new JScrollPane(new JTable(model)));
      f.setSize(320, 240);
      f.setLocationRelativeTo(null);
      f.setVisible(true);
    });
  }
}
</code></pre>

## 参考リンク
- [Sorting and Otherwise Manipulating Data - How to Use Tables (The Java™ Tutorials > Creating a GUI with JFC/Swing > Using Swing Components)](http://docs.oracle.com/javase/tutorial/uiswing/components/table.html#sorting)
- [SwingのJTableコンポーネントでセルを描く](http://www.ibm.com/developerworks/jp/java/library/j-jtable/)

<!-- dummy comment line for breaking list -->

## コメント
- `JTable#prepareRenderer`メソッドを使用する場合のサンプルを修正。 -- *aterai* 2007-04-04 (水) 19:41:37
- メモ: [JTable でセルのないところに行っぽい表示を出せますか？ - KrdLabの不定期日記](http://d.hatena.ne.jp/KrdLab/20071209/1197143960)。これおもしろいです。 -- *aterai* 2007-12-10 (月) 17:25:47
- ↑ありがとうございます．terai様のサイトは情報が充実していてすばらしいです．参考にさせていただきます． -- *KrdLab* 2008-01-27 (日) 14:27:53

<!-- dummy comment line for breaking list -->
