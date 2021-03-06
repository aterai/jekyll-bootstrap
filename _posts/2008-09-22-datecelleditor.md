---
layout: post
category: swing
folder: DateCellEditor
title: CellEditorをJSpinnerにして日付を変更
tags: [JTable, TableCellEditor, JSpinner, Focus, ChangeListener]
author: aterai
pubdate: 2008-09-22T13:48:58+09:00
description: JTableで、日付を表示する列のセルエディタをJSpinnerにします。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKdTsjXPI/AAAAAAAAAWA/vtjdEFUkZA4/s800/DateCellEditor.png
comments: true
---
## 概要
`JTable`で、日付を表示する列のセルエディタを`JSpinner`にします。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKdTsjXPI/AAAAAAAAAWA/vtjdEFUkZA4/s800/DateCellEditor.png %}

## サンプルコード
<pre class="prettyprint"><code>class SpinnerCellEditor extends JSpinner implements TableCellEditor {
  private final JSpinner.DateEditor editor;
  public SpinnerCellEditor() {
    super(new SpinnerDateModel());
    setEditor(editor = new JSpinner.DateEditor(this, "yyyy/MM/dd"));
    setArrowButtonEnabled(false);
    editor.getTextField().setHorizontalAlignment(JFormattedTextField.LEFT);

    addFocusListener(new FocusAdapter() {
      @Override public void focusGained(FocusEvent e) {
        // System.out.println("spinner");
        editor.getTextField().requestFocusInWindow();
      }
    });
    editor.getTextField().addFocusListener(new FocusAdapter() {
      @Override public void focusLost(FocusEvent e) {
        setArrowButtonEnabled(false);
      }

      @Override public void focusGained(FocusEvent e) {
        // System.out.println("getTextField");
        setArrowButtonEnabled(true);
        EventQueue.invokeLater(new Runnable() {
          @Override public void run() {
            editor.getTextField().setCaretPosition(8);
            editor.getTextField().setSelectionStart(8);
            editor.getTextField().setSelectionEnd(10);
          }
        });
      }
    });
    setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 0));
  }

  private void setArrowButtonEnabled(boolean flag) {
    for (Component c : getComponents()) {
      if (c instanceof JButton) {
        ((JButton) c).setEnabled(flag);
      }
    }
  }

  @Override public Component getTableCellEditorComponent(JTable table,
      Object value, boolean isSelected, int row, int column) {
    setValue(value);
    return this;
  }

  @Override public Object getCellEditorValue() {
    return getValue();
  }

  // Copied from AbstractCellEditor
  // protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;

  @Override public boolean stopCellEditing() {
    try {
      commitEdit();
    } catch (Exception pe) {
      Toolkit.getDefaultToolkit().beep();
      return false;
    }
    fireEditingStopped();
    return true;
  }
  // ...
</code></pre>

## 解説
`TableModel#getColumnClass(int)`で第`2`列目が日付(`Date.class`)を返すように設定し、`JTable#setDefaultEditor(Class,CellEditor)`メソッドで上記のセルエディタを関連付けています。

<pre class="prettyprint"><code>table.setDefaultEditor(Date.class, new SpinnerCellEditor());
table.setSurrendersFocusOnKeystroke(true);
</code></pre>

この日付用のセルエディタ(`SpinnerCellEditor`)は、以下のような動作になっています。

- `SpinnerEditor`で左寄せ
    - デフォルトのセルレンダラーと合わせるため
    - ~~`1.6.0_07`, `1.6.0_06`, `1.5.0_16`などで、`JSpinner`(`WindowsLookAndFeel`)の文字サイズ、余白が微妙に異なる？~~
- ダブルクリックで編集開始
- 編集開始時のキャレットは先頭の「年(`yyyy`)」ではなく「日(`dd`)」上にあり、この「日(`dd`)」が選択状態になるよう設定
    - 編集開始直後に<kbd>Up</kbd>、<kbd>Down</kbd>キーで「日(`dd`)」の値を変更可能にするために必要
- 編集開始時、スピナエディタにフォーカスが無い場合は、スピナボタンはクリック不可に設定
    - 編集開始と同時に、スピナボタンが押されて日付が変更されるのを防止するため

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルに複数のJButtonを配置する](https://ateraimemo.com/Swing/MultipleButtonsInTableCell.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JTextField`を直接編集して、<kbd>Tab</kbd>キーなどで編集終了すると`ArrayIndexOutOfBoundsException`が発生するバグを修正。 -- *aterai* 2013-05-30 (木) 19:56:25

<!-- dummy comment line for breaking list -->
