---
layout: post
category: swing
folder: TableHeaderTabArea
title: JTableHeaderで作成したタブエリアでCardLayoutのコンテナを切り替える
tags: [JTabbedPane, CardLayout, TableColumn, MouseListener]
author: aterai
pubdate: 2015-06-29T04:23:18+09:00
description: JTableHeaderをタブエリアとして使用し、TableColumnをクリックするとCardLayoutのコンテナが切り替わるようにマウスリスナーを設定します。
image: https://lh3.googleusercontent.com/-ZfZAc1Xgx9Q/VZBDTAXsteI/AAAAAAAAN7c/VEw9Z6haOP0/s800/TableHeaderTabArea.png
comments: true
---
## 概要
`JTableHeader`をタブエリアとして使用し、`TableColumn`をクリックすると`CardLayout`のコンテナが切り替わるようにマウスリスナーを設定します。

{% download https://lh3.googleusercontent.com/-ZfZAc1Xgx9Q/VZBDTAXsteI/AAAAAAAAN7c/VEw9Z6haOP0/s800/TableHeaderTabArea.png %}

## サンプルコード
<pre class="prettyprint"><code>class TableHeaderTabbedPane extends JPanel {
  protected final CardLayout cardLayout = new CardLayout();
  protected final JPanel tabPanel = new JPanel(new GridLayout(1, 0, 0, 0));
  protected final JPanel contentsPanel = new JPanel(cardLayout);
  protected final TableColumnModel model;
  private final JTableHeader header;
  private Object selectedColumn;
  private int rolloverColumn = -1;

  public TableHeaderTabbedPane() {
    super(new BorderLayout());

    int left  = 1;
    int right = 3;
    tabPanel.setBorder(BorderFactory.createEmptyBorder(1, left, 0, right));
    contentsPanel.setBorder(BorderFactory.createEmptyBorder(4, left, 2, right));

    JTable table = new JTable(new DefaultTableModel(null, new String[] {}));
    //table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
    header = table.getTableHeader();
    model = (TableColumnModel) header.getColumnModel();

    MouseAdapter handler = new MouseInputHandler();
    header.addMouseListener(handler);
    header.addMouseMotionListener(handler);

    final TabButton l = new TabButton();
    header.setDefaultRenderer(new TableCellRenderer() {
      @Override public Component getTableCellRendererComponent(
          JTable tbl, Object val, boolean isS, boolean hasF, int row, int col) {
        l.setText((String) val);
        l.setSelected(Objects.equals(val, selectedColumn)
                   || Objects.equals(col, rolloverColumn));
        return l;
      }
    });

    JScrollPane sp = new JScrollPane();
    JViewport vp = new JViewport() {
      @Override public Dimension getPreferredSize() {
        return new Dimension();
      }
    };
    vp.setView(table);
    sp.setViewport(vp);
    //JPanel wrapPanel = new JPanel(new BorderLayout(0, 0));
    //wrapPanel.add(sp);
    //add(wrapPanel, BorderLayout.NORTH);
    add(sp, BorderLayout.NORTH);
    add(contentsPanel);
  }
  public void addTab(final String title, final Component comp) {
    contentsPanel.add(comp, title);
    TableColumn tc = new TableColumn(
        model.getColumnCount(), 75, header.getDefaultRenderer(), null);
    tc.setHeaderValue(title);
    model.addColumn(tc);
    if (Objects.isNull(selectedColumn)) {
      cardLayout.show(contentsPanel, title);
      selectedColumn = title;
    }
  }
  private class MouseInputHandler extends MouseAdapter {
    @Override public void mousePressed(MouseEvent e) {
      JTableHeader header = (JTableHeader) e.getComponent();
      int index = header.columnAtPoint(e.getPoint());
      if (index &lt; 0) {
        return;
      }
      Object title = model.getColumn(index).getHeaderValue();
      cardLayout.show(contentsPanel, (String) title);
      selectedColumn = title;
    }
    @Override public void mouseEntered(MouseEvent e) {
      updateRolloverColumn(e);
    }
    @Override public void mouseMoved(MouseEvent e) {
      updateRolloverColumn(e);
    }
    @Override public void mouseDragged(MouseEvent e) {
      rolloverColumn = -1;
      updateRolloverColumn(e);
    }
    @Override public void mouseExited(MouseEvent e) {
      //int oldRolloverColumn = rolloverColumn;
      rolloverColumn = -1;
    }
    //@see BasicTableHeaderUI.MouseInputHandler
    private void updateRolloverColumn(MouseEvent e) {
      if (Objects.isNull(header.getDraggedColumn())
          &amp;&amp; header.contains(e.getPoint())) {
        int col = header.columnAtPoint(e.getPoint());
        if (col != rolloverColumn) {
          //int oldRolloverColumn = rolloverColumn;
          rolloverColumn = col;
          //rolloverColumnUpdated(oldRolloverColumn, rolloverColumn);
        }
      }
    }
  }
}
</code></pre>

## 解説
このサンプルでは、`CardLayout`と`JTableHeader`を使用して、コンテナの切り替えを行う`JTabbedPane`風のコンポーネントを作成しています。

- `JTableHeader`は、空の`JTable`を作成してそこから取得
    - `new JTableHeader(TableColumnModel cm)`より簡単なため
- `JScrollPane`にサイズ`0`の`JViewport`を設定し、上記の`JTable`を追加
    - 直接`JTableHeader`を追加すると、うまくリサイズできない？
- `JTableHeader`に`MouseListener`を追加し、`TableColumn`(タブとして代用)がクリックされると、そのタイトル文字列を引数にして`CardLayout#show(...)`を実行してコンテナの切り替えを行う
- `JTableHeader`デフォルト機能であるドラッグ＆ドロップによる入れ替えや、ヘッダ(タブ)幅のリサイズが利用可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [CardLayoutを使ってJTabbedPane風のコンポーネントを作成](https://ateraimemo.com/Swing/CardLayoutTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
