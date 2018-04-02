---
layout: post
category: swing
folder: DropdownTableComboBox
title: JComboBoxのドロップダウンリストとしてJTableを使用する
tags: [JComboBox , JTable, BasicComboPopup]
author: aterai
pubdate: 2018-04-02T17:25:49+09:00
description: JComboBoxのドロップダウンリストとしてJListの代わりにJTableを使用します。
image: https://drive.google.com/uc?id=170XdYlh7LDQaucke8xUxSSN1qlcPWcrGrw
comments: true
---
## 概要
`JComboBox`のドロップダウンリストとして`JList`の代わりに`JTable`を使用します。

{% download https://drive.google.com/uc?id=170XdYlh7LDQaucke8xUxSSN1qlcPWcrGrw %}

## サンプルコード
<pre class="prettyprint"><code>class DropdownTableComboBox&lt;E extends Vector&lt;Object&gt;&gt; extends JComboBox&lt;E&gt; {
  protected final transient HighlightListener highlighter = new HighlightListener();
  protected final JTable table = new JTable() {
    @Override public Component prepareRenderer(
          TableCellRenderer renderer, int row, int column) {
      Component c = super.prepareRenderer(renderer, row, column);
      c.setForeground(Color.BLACK);
      if (highlighter.isHighlightableRow(row)) {
        c.setBackground(new Color(255, 200, 200));
      } else if (isRowSelected(row)) {
        c.setBackground(Color.CYAN);
      } else {
        c.setBackground(Color.WHITE);
      }
      return c;
    }
    @Override public void updateUI() {
      removeMouseListener(highlighter);
      removeMouseMotionListener(highlighter);
      super.updateUI();
      addMouseListener(highlighter);
      addMouseMotionListener(highlighter);
      getTableHeader().setReorderingAllowed(false);
    }
  };
  protected final List&lt;E&gt; list;

  protected DropdownTableComboBox(List&lt;E&gt; list, DefaultTableModel model) {
    super();
    this.list = list;
    table.setModel(model);
    list.forEach(this::addItem);
    list.forEach(model::addRow);
  }

  @Override public void updateUI() {
    super.updateUI();
    EventQueue.invokeLater(() -&gt; {
      setUI(new MetalComboBoxUI() {
        @Override protected ComboPopup createPopup() {
          return new ComboTablePopup(comboBox, table);
        }
      });
      setEditable(false);
    });
  }
  public List&lt;Object&gt; getSelectedRow() {
    return list.get(getSelectedIndex());
  }
}
</code></pre>

## 解説
上記のサンプルでは、`MetalComboBoxUI#createPopup()`メソッドをオーバーライドして、以下のように`JList`ではなく`JTable`を使用する`BasicComboPopup`を返す`JComboBox`を作成しています。

<pre class="prettyprint"><code>class ComboTablePopup extends BasicComboPopup {
  private final JTable table;
  private final JScrollPane scroll;
  protected ComboTablePopup(JComboBox&lt;?&gt; combo, JTable table) {
    super(combo);
    this.table = table;

    ListSelectionModel sm = table.getSelectionModel();
    sm.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    sm.addListSelectionListener(e -&gt; {
      combo.setSelectedIndex(table.getSelectedRow());
    });

    combo.addItemListener(e -&gt; {
      if (e.getStateChange() == ItemEvent.SELECTED) {
        setRowSelection(combo.getSelectedIndex());
      }
    });

    table.addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        combo.setSelectedIndex(table.rowAtPoint(e.getPoint()));
        setVisible(false);
      }
    });

    scroll = new JScrollPane(table);
    setBorder(BorderFactory.createEmptyBorder());
  }
  @Override public void show() {
    if (isEnabled()) {
      Insets ins = scroll.getInsets();
      int tableh = table.getPreferredSize().height;
      int headerh = table.getTableHeader().getPreferredSize().height;
      scroll.setPreferredSize(new Dimension(
          240, tableh + headerh + ins.top + ins.bottom));
      super.removeAll();
      super.add(scroll);
      setRowSelection(comboBox.getSelectedIndex());
      super.show(comboBox, 0, comboBox.getBounds().height);
    }
  }
  private void setRowSelection(int index) {
    if (index != -1) {
      table.setRowSelectionInterval(index, index);
      table.scrollRectToVisible(table.getCellRect(index, 0, true));
    }
  }
}
</code></pre>

- - - -
- 注: ドロップダウンリストの幅は、`240px`固定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのItemを左右にクリップして配置](https://ateraimemo.com/Swing/ClippedLRComboBox.html)
- [JTableのセルのハイライト](https://ateraimemo.com/Swing/CellHighlight.html)

<!-- dummy comment line for breaking list -->

## コメント
