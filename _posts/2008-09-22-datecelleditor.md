---
layout: post
title: CellEditorをJSpinnerにして日付を変更
category: swing
folder: DateCellEditor
tags: [JTable, TableCellEditor, JSpinner, Focus, ChangeListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-09-22

## CellEditorをJSpinnerにして日付を変更
`JTable`で、日付を表示する列のセルエディタを`JSpinner`にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTKdTsjXPI/AAAAAAAAAWA/vtjdEFUkZA4/s800/DateCellEditor.png)

### サンプルコード
<pre class="prettyprint"><code>class SpinnerCellEditor extends JSpinner implements TableCellEditor {
  private final JSpinner.DateEditor editor;
  public SpinnerCellEditor() {
    super(new SpinnerDateModel());
    setEditor(editor = new JSpinner.DateEditor(this, "yyyy/MM/dd"));
    setArrowButtonEnabled(false);
    editor.getTextField().setHorizontalAlignment(JFormattedTextField.LEFT);

    addFocusListener(new FocusAdapter() {
      @Override public void focusGained(FocusEvent e) {
        //System.out.println("spinner");
        editor.getTextField().requestFocusInWindow();
      }
    });
    editor.getTextField().addFocusListener(new FocusAdapter() {
      @Override public void focusLost(FocusEvent e) {
        setArrowButtonEnabled(false);
      }
      @Override public void focusGained(FocusEvent e) {
        //System.out.println("getTextField");
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
    setBorder(BorderFactory.createEmptyBorder(0,0,0,0));
  }
  private void setArrowButtonEnabled(boolean flag) {
    for(Component c: getComponents()) {
      if(c instanceof JButton) {
        ((JButton)c).setEnabled(flag);
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

  //Copid from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;

  @Override public boolean stopCellEditing() {
    try{
      commitEdit();
    }catch(Exception pe) {
      Toolkit.getDefaultToolkit().beep();
      return false;
    }
    fireEditingStopped();
    return true;
  }

//......
</code></pre>

### 解説
`TableModel#getColumnClass(int)`で、第`2`列目が日付(`Date.class`)を返すように設定し、`JTable#setDefaultEditor(Class,CellEditor)`メソッドで上記のセルエディタを関連付けています。

<pre class="prettyprint"><code>table.setDefaultEditor(Date.class, new SpinnerCellEditor());
table.setSurrendersFocusOnKeystroke(true);
</code></pre>

この日付用のセルエディタ(`SpinnerCellEditor`)は、以下のような動作になっています。

- スピナエディタで左寄せ
    - デフォルトのセルレンダラーと合わせるため
    - `1.6.0_07`, `1.6.0_06`, `1.5.0_16`などで、`JSpinner`(`WindowsLookAndFeel`)の文字サイズ、余白が微妙に異なる？
- ダブルクリックで編集開始
- 編集開始時のキャレットは先頭の年(`yyyy`)ではなく日(`dd`)で、日(`dd`)が選択状態になる
    - スピナボタン、<kbd>Up</kbd><kbd>Down</kbd>キーなどで、日(`dd`)から値が変更されるようにするため
- 編集開始時、スピナエディタにフォーカスが無い場合は、スピナボタンはクリック不可
    - 編集開始と同時に、スピナボタンが押されて日付が変更されるのを防止するため

<!-- dummy comment line for breaking list -->

### 参考リンク
- [JTableのセルに複数のJButtonを配置する](http://terai.xrea.jp/Swing/MultipleButtonsInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JTextField`を直接編集して、<kbd>Tab</kbd>キーなどで編集終了すると`ArrayIndexOutOfBoundsException`が発生するバグを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-30 (木) 19:56:25

<!-- dummy comment line for breaking list -->

