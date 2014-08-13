---
layout: post
title: TableCellEditorをスクロール可能にする
category: swing
folder: ScrollingCellEditor
tags: [JTable, JScrollPane, JTextArea, TableCellEditor, Focus]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-06-20

## TableCellEditorをスクロール可能にする
`JTable`の`TableCellEditor`として、`JTextArea`と`JScrollPane`を使用します。


{% download https://lh4.googleusercontent.com/-DDRbJ9WhSJk/Tf7btYjUE7I/AAAAAAAAA9s/yVKIKC55zIw/s800/ScrollingCellEditor.png %}

### サンプルコード
<pre class="prettyprint"><code>class TextAreaCellEditor extends JTextArea implements TableCellEditor {
  private final JScrollPane scroll;
  public TextAreaCellEditor() {
    scroll = new JScrollPane(this);
    setLineWrap(true);
    KeyStroke enter = KeyStroke.getKeyStroke(
        KeyEvent.VK_ENTER, InputEvent.CTRL_MASK);
    getInputMap(JComponent.WHEN_FOCUSED).put(enter, new AbstractAction() {
      @Override public void actionPerformed(ActionEvent e) {
        stopCellEditing();
      }
    });
  }
  @Override public Object getCellEditorValue() {
    return getText();
  }
  @Override public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    setFont(table.getFont());
    setText((value!=null)?value.toString():"");
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        setCaretPosition(getText().length());
        requestFocusInWindow();
      }
    });
    return scroll;
  }
  @Override public boolean isCellEditable(final EventObject e) {
    if(e instanceof MouseEvent) {
      return ((MouseEvent)e).getClickCount() &gt;= 2;
    }
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        if(e instanceof KeyEvent) {
          KeyEvent ke = (KeyEvent)e;
          char kc = ke.getKeyChar();
          if(Character.isUnicodeIdentifierStart(kc)) {
            setText(getText()+kc);
          }
        }
      }
    });
    return true;
  }
//......
</code></pre>

### 解説
上記のサンプルでは、`0`列目にデフォルトの`TableCellEditor(JTextField)`、`1`列目に`JTextArea`を継承した`TableCellEditor`を設定しています。

- `TableCellEditor#isCellEditable`
    - マウスのダブルクリックで編集開始
- `TableCellEditor#getTableCellEditorComponent`
    - `JTextArea`に現在表示されているセル文字列をコピーし、戻り値の`Component`として、`JScrollPane`を返す
- `TableCellEditor#isCellEditable`, `EventQueue.invokeLater`
    - キー入力で編集開始した場合、その入力を`JTextArea`の文字列末尾に追加
- `TableCellEditor#getTableCellEditorComponent`, `EventQueue.invokeLater`
    - `JTextArea`にフォーカスを移動し、`JTextArea`のキャレットも文字列末尾に移動

<!-- dummy comment line for breaking list -->

### 参考リンク
- [TableCellEditorのレイアウトを変更](http://terai.xrea.jp/Swing/CellEditorLayout.html)
- [JTableのセル幅で文字列を折り返し](http://terai.xrea.jp/Swing/TableCellRenderer.html)

<!-- dummy comment line for breaking list -->

### コメント
