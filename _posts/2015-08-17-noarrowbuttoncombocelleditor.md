---
layout: post
category: swing
folder: NoArrowButtonComboCellEditor
title: JTableのCellEditorにArrowButtonを非表示にしたJComboBoxを設定
tags: [JTable, CellEditor, JComboBox, ArrowButton, LocalDateTime]
author: aterai
pubdate: 2015-08-17T01:24:54+09:00
description: JTableのCellEditorとしてArrowButtonを非表示にしたJComboBoxを使用します。
image: https://lh3.googleusercontent.com/-rMRAQF0w4iQ/VdC10-8iyjI/AAAAAAAAN_c/5hX5mZ8KFUg/s800-Ic42/NoArrowButtonComboCellEditor.png
comments: true
---
## 概要
`JTable`の`CellEditor`として`ArrowButton`を非表示にした`JComboBox`を使用します。

{% download https://lh3.googleusercontent.com/-rMRAQF0w4iQ/VdC10-8iyjI/AAAAAAAAN_c/5hX5mZ8KFUg/s800-Ic42/NoArrowButtonComboCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class LocalDateTimeTableCellEditor extends AbstractCellEditor
                                   implements TableCellEditor {
  private final JComboBox&lt;LocalDateTime&gt; comboBox;
  private LocalDateTime selectedDate;

  public LocalDateTimeTableCellEditor() {
    super();
    UIManager.put("ComboBox.squareButton", Boolean.FALSE);
    comboBox = new JComboBox&lt;LocalDateTime&gt;() {
      @Override public void updateUI() {
        super.updateUI();
        setBorder(BorderFactory.createEmptyBorder());
        setOpaque(true);
        setRenderer(new LocalDateTimeCellRenderer&lt;LocalDateTime&gt;());
        setUI(new BasicComboBoxUI() {
          @Override protected JButton createArrowButton() {
            JButton button = new JButton(); //.createArrowButton();
            button.setBorder(BorderFactory.createEmptyBorder());
            button.setVisible(false);
            return button;
          }
        });
      }
    };
    comboBox.putClientProperty("JComboBox.isTableCellEditor", Boolean.TRUE);
  }
  @Override public Component getTableCellEditorComponent(
      JTable table, final Object value, boolean isSelected, int row, int column) {
    if (value instanceof LocalDateTime) {
      comboBox.setModel(new DefaultComboBoxModel&lt;LocalDateTime&gt;() {
        @Override public LocalDateTime getElementAt(int index) {
          if (index &gt;= 0 &amp;&amp; index &lt; getSize()) {
            return LocalDateTime.now().plusDays(index);
          } else {
            return LocalDateTime.now();
          }
        }
        @Override public int getSize() {
          return 7;
        }
        @Override public Object getSelectedItem() {
          return selectedDate;
        }
        @Override public void setSelectedItem(Object anItem) {
          selectedDate = (LocalDateTime) anItem;
        }
      });
      selectedDate = (LocalDateTime) value;
    }
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        comboBox.setSelectedItem(value);
      }
    });
    return comboBox;
  }
  @Override public Object getCellEditorValue() {
    return comboBox.getSelectedItem();
  }
  @Override public boolean shouldSelectCell(EventObject anEvent) {
    if (anEvent instanceof MouseEvent) {
      MouseEvent e = (MouseEvent) anEvent;
      return e.getID() != MouseEvent.MOUSE_DRAGGED;
    }
    return true;
  }
  @Override public boolean stopCellEditing() {
    if (comboBox.isEditable()) {
      // Commit edited value.
      comboBox.actionPerformed(new ActionEvent(this, 0, ""));
    }
    return super.stopCellEditing();
  }
  @Override public boolean isCellEditable(EventObject e) {
    return true;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`ArrowButton`を非表示にした`JComboBox`を使用する`TableCellEditor`を作成しています。

- メモ
    - この`JComboBox`で編集する値は`LocalDateTime`なので、`DefaultCellEditor`は使用せず、`AbstractCellEditor`を継承して`TableCellEditor`を作成
    - `LocalDateTime.now()`で取得した日付から7日分を`JComboBox`で選択可能になるよう、`TableCellEditor#getTableCellEditorComponent(...)`内で、`ComboBoxModel`を更新

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComboBoxのArrowButtonを隠す](http://ateraimemo.com/Swing/HideComboArrowButton.html)
- [JTableのCellEditorにJComboBoxを設定](http://ateraimemo.com/Swing/ComboCellEditor.html)

<!-- dummy comment line for breaking list -->

## コメント
