---
layout: post
category: swing
folder: InheritsPopupMenu
title: JPopupMenuの取得を親に委譲
tags: [JPopupMenu, JScrollPane, JViewport, JTable, JTableHeader]
author: aterai
pubdate: 2008-03-17T13:34:51+09:00
description: 親コンポーネントに設定されているJPopupMenuを取得して、これを表示します。
comments: true
---
## 概要
親コンポーネントに設定されている`JPopupMenu`を取得して、これを表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOe9ph-LI/AAAAAAAAAcc/iwxbgnjvxg8/s800/InheritsPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(table);
scroll.setComponentPopupMenu(new TablePopupMenu());
//scroll.getViewport().setInheritsPopupMenu(true); // JDK 1.5
table.setInheritsPopupMenu(true);
//table.getTableHeader().setInheritsPopupMenu(true);
</code></pre>
<pre class="prettyprint"><code>private class TablePopupMenu extends JPopupMenu {
  private final Action deleteAction = new DeleteAction("delete", null);
  private final Action createAction = new CreateAction("add", null);
  public TablePopupMenu() {
    super();
    add(createAction);
    addSeparator();
    add(deleteAction);
  }
  @Override public void show(Component c, int x, int y) {
    int[] l = table.getSelectedRows();
    deleteAction.setEnabled(l!=null &amp;&amp; l.length&gt;0);
    super.show(c, x, y);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JScrollPane`に`setComponentPopupMenu(JPopupMenu)`メソッドで、ポップアップメニューを追加し、`JTable`の方は、`setInheritsPopupMenu(true)`とすることで、親の`JScrollPane`に設定したポップアップメニューを使用するようになっています。

`JDK 1.5`では、`JViewport`も`setInheritsPopupMenu(true)`とする必要がありましたが、`JDK 1.6`ではデフォルトが変更されているようです。

- - - -
`JDK 1.6`では、`JTable`のヘッダも、`setInheritsPopupMenu(true)`で、`JScrollPane`からポップアップメニューを取得して表示することができます。ただし、`JDK 1.6` + `WindowsLookAndFeel`で、`JTableHeader`上にポップアップメニューを表示すると、以下のようにうまく再描画できない場合があるようです。

1. ヘッダを右クリックしながら、右端にドラッグ、ポップアップ表示
1. <kbd>Esc</kbd>キーで、ポップアップ非表示
1. ヘッダ上で右クリック、ポップアップ、<kbd>Esc</kbd>キー

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTOhYdteZI/AAAAAAAAAcg/CzWZOSF9pVw/s800/InheritsPopupMenu1.png)

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.table.*;
public class HeaderPopupMenuTest {
  public JComponent makeUI() {
    JScrollPane scroll = new JScrollPane(makeTable());
    scroll.setComponentPopupMenu(new TablePopupMenu());
    JPanel p = new JPanel(new BorderLayout());
    p.add(scroll);
    return p;
  }
  private JTable makeTable() {
    String[] columnNames = {"String", "Integer", "Boolean"};
    Object[][] data = { {"AAA", 1, true}, {"BBB", 2, false} };
    DefaultTableModel model = new DefaultTableModel(data, columnNames) {
      @Override public Class&lt;?&gt; getColumnClass(int column) {
        return getValueAt(0, column).getClass();
      }
    };
    JTable table = new JTable(model);
    table.setInheritsPopupMenu(true);
    table.getTableHeader().setInheritsPopupMenu(true);
    table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
    return table;
  }
  private class TablePopupMenu extends JPopupMenu {
    public TablePopupMenu() {
      super();
      add(new DummyAction("add"));
      addSeparator();
      add(new DummyAction("delete"));
    }
  }
  class DummyAction extends AbstractAction{
    public DummyAction(String label) {
      super(label);
    }
    @Override public void actionPerformed(ActionEvent e) {}
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() { createAndShowGUI(); }
    });
  }
  public static void createAndShowGUI() {
    try{
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    }catch(Exception e) {
      e.printStackTrace();
    }
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new HeaderPopupMenuTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>

## 参考リンク
- [JPopupMenuをコンポーネントに追加](http://ateraimemo.com/Swing/ComponentPopupMenu.html)

<!-- dummy comment line for breaking list -->

## コメント
