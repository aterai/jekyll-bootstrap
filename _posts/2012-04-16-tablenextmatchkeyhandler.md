---
layout: post
title: JTableで先頭文字のキー入力による検索を行う
category: swing
folder: TableNextMatchKeyHandler
tags: [JTable, KeyListener]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-04-16

## JTableで先頭文字のキー入力による検索を行う
`JTable`にフォーカスがある状態でキー入力をした場合、先頭文字が一致する行を検索して選択状態にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/-UATkJ0JfmBQ/T4u5j_rhkGI/AAAAAAAABLc/1rVNsbM9D98/s800/TableNextMatchKeyHandler.png)

### サンプルコード
<pre class="prettyprint"><code>//@see javax/swing/plaf/basic/BasicListUI.Handler
//@see javax/swing/plaf/basic/BasicTreeUI.Handler
class TableNextMatchKeyHandler extends KeyAdapter{
  private static final int TARGET_COLUMN = 0;
  private String prefix = "";
  private String typedString = "";
  private long lastTime = 0L;
  private long timeFactor;
  public TableNextMatchKeyHandler() {
    //Long l = (Long)UIManager.get("List.timeFactor");
    timeFactor = 500L; //(l!=null) ? l.longValue() : 1000L;
  }
  private boolean isNavigationKey(KeyEvent e) {
    JTable t = (JTable)e.getSource();
    InputMap im = t.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
    KeyStroke key = KeyStroke.getKeyStrokeForEvent(e);
    if(im != null &amp;&amp; im.get(key) != null) {
      return true;
    }
    return false;
  }
  @Override public void keyPressed(KeyEvent e) {
    if(isNavigationKey(e)) {
      prefix = "";
      typedString = "";
      lastTime = 0L;
    }
  }
  @Override public void keyTyped(KeyEvent e) {
    JTable src = (JTable)e.getSource();
    int max = src.getRowCount();
    if(max == 0 || e.isAltDown() || isNavigationKey(e)) {
      // Nothing to select
      return;
    }
    boolean startingFromSelection = true;
    char c = e.getKeyChar();
    int increment = e.isShiftDown() ? -1 : 1;
    long time = e.getWhen();
    int startIndex = src.getSelectedRow();
    if(time - lastTime &lt; timeFactor) {
      typedString += c;
      if((prefix.length() == 1) &amp;&amp; (c == prefix.charAt(0))) {
        // Subsequent same key presses move the keyboard focus to the next
        // object that starts with the same letter.
        startIndex += increment;
      }else{
        prefix = typedString;
      }
    }else{
      startIndex += increment;
      typedString = "" + c;
      prefix = typedString;
    }
    lastTime = time;

    if(startIndex &lt; 0 || startIndex &gt;= max) {
      if(e.isShiftDown()) {
        startIndex = max-1;
      }else{
        startingFromSelection = false;
        startIndex = 0;
      }
    }
    Position.Bias bias = e.isShiftDown()?Position.Bias.Backward
                                        :Position.Bias.Forward;
    int index = getNextMatch(src, prefix, startIndex, bias);
    if(index &gt;= 0) {
      src.getSelectionModel().setSelectionInterval(index, index);
      src.scrollRectToVisible(src.getCellRect(index, TARGET_COLUMN, true));
    }else if(startingFromSelection) { // wrap
      index = getNextMatch(src, prefix, 0, bias);
      if(index &gt;= 0) {
        src.getSelectionModel().setSelectionInterval(index, index);
        src.scrollRectToVisible(src.getCellRect(index, TARGET_COLUMN, true));
      }
    }
  }
  //@see JList#getNextMatch(String prefix, int startIndex, Position.Bias bias)
  //@see JTree#getNextMatch(String prefix, int startIndex, Position.Bias bias)
  public static int getNextMatch(
      JTable table, String prefix, int startingRow, Position.Bias bias) {
    int max = table.getRowCount();
    if(prefix == null) {
      throw new IllegalArgumentException();
    }
    if(startingRow &lt; 0 || startingRow &gt;= max) {
      throw new IllegalArgumentException();
    }
    prefix = prefix.toUpperCase();

    // start search from the next/previous element froom the
    // selected element
    int increment = (bias == Position.Bias.Forward) ? 1 : -1;
    int row = startingRow;
    do{
      Object value = table.getValueAt(row, TARGET_COLUMN);
      String text = value!=null?value.toString():"";
      if(text.toUpperCase().startsWith(prefix)) {
        return row;
      }
      row = (row + increment + max) % max;
    }while(row != startingRow);
    return -1;
  }
}
</code></pre>

### 解説
上記のサンプルでは、キー入力と`0`列目の文字列の先頭文字が一致(大文字小文字は無視)する行を検索、選択し、そこまでスクロールします。
検索方法は、`BasicListUI.Handler`、`BasicTreeUI.Handler`、`JList#getNextMatch(...)`、`JTree#getNextMatch(...)`のものと、ほぼ同じ(<kbd>Shift</kbd>キーを同時に押すと逆検索を追加)です。

- - - -
- `table.putClientProperty("JTable.autoStartsEdit", Boolean.FALSE);`として、キー入力で編集を開始しないように設定
    - マウスクリック、<kbd>F2</kbd>キーでの編集は可能

<!-- dummy comment line for breaking list -->

### コメント