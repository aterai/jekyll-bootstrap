---
layout: post
category: swing
folder: CheckBoxCellEditor
title: JTableのセル内部にあるJCheckBoxのみクリック可能にする
tags: [JTable, JCheckBox, TableCellEditor, JPanel]
author: aterai
pubdate: 2015-07-20T03:24:10+09:00
description: JTableのセルエディタとしてJPanel中央に配置したJCheckBoxを設定し、そのJCheckBoxをクリックした場合のみ選択状態が変化するように設定します。
image: https://lh3.googleusercontent.com/-t1TDt_cSOzU/VavlaZDRBaI/AAAAAAAAN9c/nVCdYcC71e8/s800-Ic42/CheckBoxCellEditor.png
comments: true
---
## 概要
`JTable`のセルエディタとして`JPanel`中央に配置した`JCheckBox`を設定し、その`JCheckBox`をクリックした場合のみ選択状態が変化するように設定します。

{% download https://lh3.googleusercontent.com/-t1TDt_cSOzU/VavlaZDRBaI/AAAAAAAAN9c/nVCdYcC71e8/s800-Ic42/CheckBoxCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class CheckBoxPanelEditor extends AbstractCellEditor implements TableCellEditor {
  private final JPanel p = new JPanel(new GridBagLayout());
  private final JCheckBox checkBox = new JCheckBox();
  public CheckBoxPanelEditor() {
    super();
    checkBox.setOpaque(false);
    checkBox.setFocusable(false);
    checkBox.setRolloverEnabled(false);
    Handler handler = new Handler();
    checkBox.addActionListener(handler);
    checkBox.addMouseListener(handler);
    p.addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        fireEditingStopped();
      }
    });
    p.add(checkBox);
    p.setBorder(UIManager.getBorder("Table.noFocusBorder"));
  }
  @Override public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    checkBox.setSelected(Objects.equals(value, Boolean.TRUE));
    //p.setBackground(table.getSelectionBackground());
    return p;
  }
  @Override public Object getCellEditorValue() {
    return checkBox.isSelected();
  }
  private class Handler extends MouseAdapter implements ActionListener {
    @Override public void actionPerformed(ActionEvent e) {
      fireEditingStopped();
    }
    @Override public void mousePressed(MouseEvent e) {
      Container c = SwingUtilities.getAncestorOfClass(JTable.class, e.getComponent());
      if (c instanceof JTable) {
        JTable table = (JTable) c;
        if (checkBox.getModel().isPressed()
            &amp;&amp; table.isRowSelected(table.getEditingRow()) &amp;&amp; e.isControlDown()) {
          p.setBackground(table.getBackground());
        } else {
          p.setBackground(table.getSelectionBackground());
        }
      }
    }
    @Override public void mouseExited(MouseEvent e) {
      Container c = SwingUtilities.getAncestorOfClass(JTable.class, e.getComponent());
      if (c instanceof JTable) {
        JTable table = (JTable) c;
        if (table.isEditing() &amp;&amp; !table.getCellEditor().stopCellEditing()) {
          table.getCellEditor().cancelCellEditing();
        }
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JTable`の`Boolean`に対応する`TableCellEditor`として、中央に`JCheckBox`を配置した`JPanel`を適用しています。

- デフォルトの`JTable.BooleanEditor`
    - セル全体が`JCheckBox`になるため、チェックアイコン以外の余白をマウスでクリックした場合でも選択状態が変化する
- `CheckBoxPanelEditor`
    - `JPanel`の中央に`JCheckBox`を配置して作成
    - 余白となる`JPanel`部分をクリックしても、`JCheckBox`の状態は変化しない
    - `JCheckBox`をマウスでクリックした場合のみ、その選択状態が変化する

<!-- dummy comment line for breaking list -->

- - - -
- 以下のように`getTableCellEditorComponent(...)`内で`JPanel`の背景色をセルの選択色にする場合、<kbd>Ctrl</kbd>キーを押しながら`JCheckBox`をクリックするとセルの選択状態にズレが発生する
    - このサンプルでは、セルエディタの`JCheckBox`に以下のようなマウスリスナーを追加することで回避
        
        <pre class="prettyprint"><code>class CheckBoxPanelEditor extends AbstractCellEditor implements TableCellEditor {
          private final JPanel p = new JPanel(new GridBagLayout());
          private final JCheckBox checkBox = new JCheckBox();
          public CheckBoxPanelEditor() {
            super();
            checkBox.setOpaque(false);
            checkBox.setFocusable(false);
            checkBox.setRolloverEnabled(false);
            checkBox.addActionListener(new ActionListener() {
              @Override public void actionPerformed(ActionEvent e) {
                fireEditingStopped();
              }
            });
            p.add(checkBox);
            p.setBorder(UIManager.getBorder("Table.noFocusBorder"));
          }
          @Override public Component getTableCellEditorComponent(
              JTable table, Object value, boolean isSelected, int row, int column) {
            checkBox.setSelected(Objects.equals(value, Boolean.TRUE));
            p.setBackground(table.getSelectionBackground());
            return p;
          }
          @Override public Object getCellEditorValue() {
            return checkBox.isSelected();
          }
        }
</code></pre>
    - * 参考リンク [#reference]
- [JTableのCellにJCheckBoxを複数配置する](https://ateraimemo.com/Swing/CheckBoxesInTableCell.html)
- [JCheckBoxのセルをロールオーバーする](https://ateraimemo.com/Swing/RolloverBooleanRenderer.html)

<!-- dummy comment line for breaking list -->

## コメント
