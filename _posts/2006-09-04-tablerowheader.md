---
layout: post
title: JTableに行ヘッダを追加
category: swing
folder: TableRowHeader
tags: [JTable, JList, JScrollPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-09-04

## JTableに行ヘッダを追加
`JTable`に行ヘッダを追加を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh3.ggpht.com/_9Z4BYR88imo/TQTUk9YzW7I/AAAAAAAAAmQ/wjin9CuyfBg/s800/TableRowHeader.png)

### サンプルコード
<pre class="prettyprint"><code>class RowHeaderList extends JList {
  private final JTable table;
  private final ListSelectionModel tableSelection;
  private final ListSelectionModel rListSelection;
  public RowHeaderList(ListModel model, JTable table) {
    super(model);
    this.table = table;
    setFixedCellHeight(table.getRowHeight());
    setCellRenderer(new RowHeaderRenderer(table.getTableHeader()));
    RollOverListener rol = new RollOverListener();
    addMouseListener(rol);
    addMouseMotionListener(rol);
    tableSelection = table.getSelectionModel();
    rListSelection = getSelectionModel();
  }
  class RowHeaderRenderer extends JLabel implements ListCellRenderer {
    private final JTableHeader header;
    public RowHeaderRenderer(JTableHeader header) {
      this.header = header;
      this.setOpaque(true);
      //this.setBorder(UIManager.getBorder("TableHeader.cellBorder"));
      this.setBorder(BorderFactory.createMatteBorder(0,0,1,2,Color.GRAY));
      this.setHorizontalAlignment(CENTER);
      this.setForeground(header.getForeground());
      this.setBackground(header.getBackground());
      this.setFont(header.getFont());
    }
    @Override public Component getListCellRendererComponent(JList list, Object value,
               int index, boolean isSelected, boolean cellHasFocus) {
      if(index==pressedRowIndex) {
        setBackground(Color.GRAY);
      }else if(index==rollOverRowIndex) {
        setBackground(Color.WHITE);
      }else if(isSelected) {
        setBackground(Color.GRAY.brighter());
      }else{
        setForeground(header.getForeground());
        setBackground(header.getBackground());
      }
      setText((value==null)?"":value.toString());
      return this;
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`JList`で作成した行ヘッダを`JScrollPane`に`setRowHeaderView`メソッドで追加しています。

表の余白などに色がついているのは、テストの名残です。特に意味は無いのですが、そのまま残しています。

<pre class="prettyprint"><code>rowHeader.setBackground(Color.BLUE);
scrollPane.setBackground(Color.RED);
scrollPane.getViewport().setBackground(Color.GREEN);
</code></pre>

### 参考リンク
- [JTable Examples](http://www.crionics.com/products/opensource/faq/swing_ex/JTableExamples1.html)
- [Swing - excel styled table?](https://forums.oracle.com/message/5889490)
- [JListのセルをカーソル移動でロールオーバー](http://terai.xrea.jp/Swing/RollOverListener.html)

<!-- dummy comment line for breaking list -->

### コメント
- 不正なセルレンダラーを設定していたので修正しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-11-16 (木) 20:22:33
- `excel`のように、行ヘッダをクリックしてその行が選択されたり、テーブルの本体にてセルをクリックしてそのセルだけが選択されたりすることはできますか？いろいろ試しましたが、なかなかできませんでした。 -- [javalover](http://terai.xrea.jp/javalover.html) 2008-03-11 (火) 09:52:12
    - セル選択は、`table.setCellSelectionEnabled(true);`で可能です。行ヘッダをクリックしてその行を選択することは、現在でも出来るような。もし、列のことなら、~~`JTableHeader`に以下のようなコードを書けばよさそうです。~~ [JTableHeaderをクリックしてそのColumnのセルを全選択](http://terai.xrea.jp/Swing/ColumnSelection.html)を参考にしてください。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-11 (火) 13:45:47
    - あ、もしかして、[TableCellRendererでセルの背景色を変更](http://terai.xrea.jp/Swing/StripeTable.html) の例のように、`JTable#prepareRenderer`をオーバーライドして行ごとの背景色を変更していますか？　あちらの例では、行選択しか考慮していなので`isRowSelected`を使って、一行まるごと選択色で塗りつぶすかどうかを判断しています(`table.setCellSelectionEnabled(true)`しても、一行選択されているように見えるようになっている)が、セル選択する場合は、ちゃんと`isCellSelected(int,int)`でそのセルが選択されているかを判断する必要があります。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-11 (火) 14:48:45
- ここのサンプルを変更して、行列ヘッダクリックで、各行列を選択するように変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-03-11 (火) 15:40:58
- プログラム自体大学で始めて触れてる者で参考にさせてもらっています。 -- [D.Umeda(ES)](http://terai.xrea.jp/D.Umeda(ES).html) 2009-02-26 (木) 06:14:52
- すいません、上のミスです。改行と思って`EnterKey`を..。`DefaultTableCellRenderer r1 = (DefaultTableCellRenderer)table.getTableHeader().getDefaultRenderer()`をした上でこの`r1`を必要な`Column`に`setCellRenderer`してやれば、その機能は再現できるのではないでしょうか？
- `Ver1.6`環境`Vista`で実行しましたが、オンマウス時の背景変化以外は全て実装できているように思います。
- `JScrollPane`に対して`JPanel`を追加、その上にテーブルヘッダを`1`行ずつ追加していけば`Vista`仕様でも`XP`仕様でもオンマウスの変化を再現できますが、`Vista`の場合、グラフィックの問題で`1px`ずれる上、結局リスナを設定しなければヘッダ選択による行の全選択が出来ないので前者の方が効率が良いですが。
- 逐一ヘッダを作って張ってなので後者は処理速度的にも実装形式的にも非効率だと思われます。ちなみに`Default`でも`TableCellRenderer`でも`Vista`上では結果は同じで`WindowsClassic`が適応されているように見えます。
- 多々間違いがあれば訂正か削除をお願いします。長文、ミス失礼しました。 -- [D.Umeda(ES)](http://terai.xrea.jp/D.Umeda(ES).html) 2009-02-26 (木) 06:27:46
    - どうもです。多分以下のような提案だと思っているのですが、合ってます？　処理速度とかは、この程度のサンプルだと、どちらもあまり気にしなくてもいいと思います。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-02-26 (木) 13:36:28

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.table.*;
public class HeaderRendererTest{
  public JComponent makeUI() {
    String[] columnNames = {"", "String", "Boolean"};
    Object[][] data = {
      {0, "AAA", true}, {1, "BBB", false},
    };
    DefaultTableModel model = new DefaultTableModel(data, columnNames) {
      @Override public Class&lt;?&gt; getColumnClass(int column) {
        return getValueAt(0, column).getClass();
      }
    };
    JTable table = new JTable(model);
    table.setRowSelectionAllowed(true);
    table.setSelectionMode(ListSelectionModel.SINGLE_INTERVAL_SELECTION);

    JTableHeader header = table.getTableHeader();
    header.setReorderingAllowed(false);

    TableCellRenderer hr = header.getDefaultRenderer();
    TableColumn col = table.getColumnModel().getColumn(0);
    col.setCellRenderer(new HeaderRenderer(table, hr));

    JPanel p = new JPanel(new BorderLayout());
    p.add(new JScrollPane(table));
    p.setPreferredSize(new Dimension(320, 160));
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
    try{
      UIManager.setLookAndFeel(
        UIManager.getSystemLookAndFeelClassName());
    }catch(Exception e) {
      e.printStackTrace();
    }
    JFrame frame = new JFrame();
    frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    frame.getContentPane().add(new HeaderRendererTest().makeUI());
    frame.pack();
    frame.setLocationRelativeTo(null);
    frame.setVisible(true);
  }
}
class HeaderRenderer implements TableCellRenderer {
  private final TableCellRenderer tcr;
  public HeaderRenderer(JTable table, TableCellRenderer tcr) {
    this.tcr  = tcr;
    RollOverListener rol = new RollOverListener();
    table.addMouseListener(rol);
    table.addMouseMotionListener(rol);
  }
  @Override public Component getTableCellRendererComponent(
    JTable tbl, Object val, boolean isS,
    boolean hasF, int row, int col) {
    JLabel l;
    boolean flg = (row==rollOverRowIndex);
    l = (JLabel)tcr.getTableCellRendererComponent(
      tbl, val, isS, flg?flg:hasF, row, col);
    l.setOpaque(!flg);
    return l;
  }
  private int rollOverRowIndex = -1;
  private class RollOverListener extends MouseInputAdapter {
    @Override public void mouseExited(MouseEvent e) {
      rollOverRowIndex = -1;
      JTable table = (JTable)e.getSource();
      table.repaint();
    }
    @Override public void mouseMoved(MouseEvent e) {
      JTable table = (JTable)e.getSource();
      Point pt = e.getPoint();
      int column = table.columnAtPoint(pt);
      rollOverRowIndex = (column==0)?table.rowAtPoint(pt):-1;
      table.repaint();
    }
    @Override public void mouseDragged(MouseEvent e) {}
    @Override public void mousePressed(MouseEvent e) {}
    @Override public void mouseReleased(MouseEvent e) {}
  }
}
</code></pre>
- すばやい返答ありがとうございます。わざわざサンプルまで。自分で定義する`HeaderRenderer`は無くとも`col.setCellRenderer(hr);`である程度再現できますが、やはりオンマウスやクリックでの変化は`UI`観点から見て必要ですね。やはり行ヘッダの領域を見るとどうしても`Vista`だとズレが生じてしまうのが気になりますが、結局`OS`依存しないプログラムを作ろうとすると`Metal`かカスタム`UI`ですね。列ヘッダを`Vista`,行ヘッダをクラシックにする誤差は生じないのですが。 -- [D.Umeda](http://terai.xrea.jp/D.Umeda.html) 2009-02-26 (木) 19:35:46
    - `Vista`は持ってないので、なんとも言えないのですが、`XP`でもオレンジのハイライト？が下に付くのはあれですね。まじめにやるなら右につけたいところです。-- [aterai](http://terai.xrea.jp/aterai.html)
- また醜い状態で設定してしまったorz見苦しいようであれば是非とも削除を。参考になるかは定かではありませんが、`javaForum`で掲示したところ次のようなサンプルURLを頂きました。[http://tips4java.wordpress.com/2008/11/18/row-number-table/](http://tips4java.wordpress.com/2008/11/18/row-number-table/)
    - camickrさんとこのブログですね。どこのjavaForum かは知らないのですが、いいとこ突いてると思います。 -- [aterai](http://terai.xrea.jp/aterai.html)
- 終わりに、わざわざサンプルを提示してくださってありがとうございました。これからも活用させてもらいます。
    - 文章で説明するより、サンプルのほうが簡単なので(^^;。 -- [aterai](http://terai.xrea.jp/aterai.html)
- 追記になりますが、処理速度の件は私がこれをする前に`1`列`1`行だけのヘッダを`rowHeaderView`のパネルにひたすら並べ続けた、ということを書きたかったんですが、きちんと用語を用いて説明する勉強もしなければいけないようです。データ数によってはヘッダを量産するので非常に非効率だと思ったのですが、勉強しておきます。 -- [D.Umeda](http://terai.xrea.jp/D.Umeda.html) 2009-02-26 (木) 19:46:39
    - あー、前者と後者が何を指しているのか誤解してたみたいです。 -- [aterai](http://terai.xrea.jp/aterai.html)
- こんばんは。ページ上部の「このページを編集する」で、だれでも適当に編集できます。パスワードは日付を更新せずに編集する場合に必要なだけです。とりあえず勝手に改行入れときましたm(_ _)m。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-02-26 (木) 20:15:21

<!-- dummy comment line for breaking list -->
