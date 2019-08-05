---
layout: post
category: swing
folder: ComboBoxCellEditorInsets
title: JTableのCellEditorに設定したJComboBoxに余白を追加する
tags: [JTable, TableCellEditor, TableCellRenderer, JComboBox, LayoutManager]
author: aterai
pubdate: 2012-05-07T12:28:04+09:00
description: JTableのCellEditorに設定したJComboBoxに余白を追加します。
image: https://lh4.googleusercontent.com/-dIea13PoJ70/T6c7YezP1BI/AAAAAAAABMQ/e0IqDjxhjpw/s800/ComboBoxCellEditorInsets.png
comments: true
---
## 概要
`JTable`の`CellEditor`に設定した`JComboBox`に余白を追加します。

{% download https://lh4.googleusercontent.com/-dIea13PoJ70/T6c7YezP1BI/AAAAAAAABMQ/e0IqDjxhjpw/s800/ComboBoxCellEditorInsets.png %}

## サンプルコード
<pre class="prettyprint"><code>class ComboBoxPanel extends JPanel {
  public final JComboBox&lt;String&gt; comboBox = new JComboBox&lt;&gt;(
      new String[] {"aaaaaa", "bbb", "c"});
  public ComboBoxPanel() {
    super(new GridBagLayout());
    GridBagConstraints c = new GridBagConstraints();
    c.weightx = 1.0;
    c.insets = new Insets(0, 10, 0, 10);
    c.fill = GridBagConstraints.HORIZONTAL;
    add(comboBox, c);

    comboBox.setEditable(true);
    comboBox.setSelectedIndex(0);
    setOpaque(true);
  }
}
class ComboBoxCellRenderer extends ComboBoxPanel implements TableCellRenderer {
  public ComboBoxCellRenderer() {
    super();
    setName("Table.cellRenderer");
  }

  @Override public Component getTableCellRendererComponent(
      JTable table, Object value,
      boolean isSelected, boolean hasFocus, int row, int column) {
    this.setBackground(isSelected ? table.getSelectionBackground()
                                  : table.getBackground());
    if (value != null) {
      comboBox.setSelectedItem(value);
    }
    return this;
  }
}
</code></pre>

## 解説
- `Border`(左)
    - `JComboBox`自身に余白を設定し、これを`CellRenderer`と`CellEditor`に適用
    - ドロップダウンリストの位置、サイズが余白を含んだ幅になる
        
        <pre class="prettyprint"><code>combo.setBorder(BorderFactory.createCompoundBorder(
                        BorderFactory.createEmptyBorder(8, 10, 8, 10), combo.getBorder()));
</code></pre>
- `JPanel` + `JComboBox`(右)
    - `GridBagLayout`を使用する`JPanel`に`JComboBox`を追加
    - `fill`フィールドを`GridBagConstraints.HORIZONTAL`として、垂直方向には`JComboBox`のサイズを変更しない
    - `insets`フィールドを設定して、`JComboBox`の外側に別途(ドロップダウンリストの位置、サイズに影響しないように)余白を追加

<!-- dummy comment line for breaking list -->

- - - -
セルの中にある`JComboBox`の幅を可変ではなく固定にする場合は、以下のような`FlowLayout`のパネルに`getPreferredSize()`をオーバーライドして幅を固定した`JComboBox`を使用する方法もあります。

<pre class="prettyprint"><code>class ComboBoxPanel extends JPanel {
  private String[] m = new String[] {"a", "b", "c"};
  protected JComboBox&lt;String&gt; comboBox = new JComboBox&lt;String&gt;(m) {
    @Override public Dimension getPreferredSize() {
      Dimension d = super.getPreferredSize();
      return new Dimension(40, d.height);
    }
  };
  public ComboBoxPanel() {
    super();
    setOpaque(true);
    comboBox.setEditable(true);
    add(comboBox);
  }
}
</code></pre>

## 参考リンク
- [JTableのCellRendererにJComboBoxを設定](https://ateraimemo.com/Swing/ComboCellRenderer.html)

<!-- dummy comment line for breaking list -->

## コメント
