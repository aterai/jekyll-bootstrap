---
layout: post
title: JTableのCellEditorに設定したJComboBoxに余白を追加する
category: swing
folder: ComboBoxCellEditorInsets
tags: [JTable, TableCellEditor, TableCellRenderer, JComboBox, LayoutManager]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-05-07

## JTableのCellEditorに設定したJComboBoxに余白を追加する
`JTable`の`CellEditor`に設定した`JComboBox`に余白を追加します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-dIea13PoJ70/T6c7YezP1BI/AAAAAAAABMQ/e0IqDjxhjpw/s800/ComboBoxCellEditorInsets.png)

### サンプルコード
<pre class="prettyprint"><code>class ComboBoxPanel extends JPanel {
  public final JComboBox comboBox = new JComboBox(new String[] {"aaaaaa", "bbb", "c"});
  public ComboBoxPanel() {
    super(new GridBagLayout());
    GridBagConstraints c = new GridBagConstraints();

    c.weightx = 1.0;
    c.insets = new Insets(0, 10, 0, 10);
    c.fill = GridBagConstraints.HORIZONTAL;

    comboBox.setEditable(true);
    setOpaque(true);
    add(comboBox, c);
    comboBox.setSelectedIndex(0);
  }
}
</code></pre>

### 解説
- `Border`(左)
    - `JComboBox`自身に余白を設定し、これを`CellRenderer`, `CellEditor`に使用
    - ドロップダウンリストの位置、サイズが余白を含んだ幅になる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>combo.setBorder(BorderFactory.createCompoundBorder(BorderFactory.createEmptyBorder(8,10,8,10), combo.getBorder()));
</code></pre>

- `JPanel` + `JComboBox`(右)
    - `GridBagLayout`を使用する`JPanel`に`JComboBox`を追加
    - `fill`フィールドを`GridBagConstraints.HORIZONTAL`として、垂直には`JComboBox`のサイズを変更しない
    - `insets`フィールドを設定して、`JComboBox`の外側に別途(ドロップダウンリストの位置、サイズに影響しないように)余白を追加

<!-- dummy comment line for breaking list -->

- - - -
セルの中にある`JComboBox`の幅を可変ではなく固定にする場合は、以下のような`FlowLayout`のパネルに`getPreferredSize()`をオーバーライドして幅を固定した`JComboBox`を使用する方法がある。

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

### 参考リンク
- [JTableのCellRendererにJComboBoxを設定](http://terai.xrea.jp/Swing/ComboCellRenderer.html)

<!-- dummy comment line for breaking list -->

### コメント