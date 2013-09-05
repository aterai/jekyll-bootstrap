---
layout: post
title: JTableHeaderの字揃えを変更
category: swing
folder: HorizontalAlignmentHeaderRenderer
tags: [JTable, JTableHeader, LookAndFeel]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2010-11-29

## JTableHeaderの字揃えを変更
`JTableHeader`の字揃えを変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh5.ggpht.com/_9Z4BYR88imo/TQTN5ZuPeZI/AAAAAAAAAbg/Fivi4R1rR-Y/s800/HorizontalAlignmentHeaderRenderer.png)

### サンプルコード
<pre class="prettyprint"><code>class HorizontalAlignmentHeaderRenderer implements TableCellRenderer{
  private int horizontalAlignment = SwingConstants.LEFT;
  public HorizontalAlignmentHeaderRenderer(int horizontalAlignment) {
    this.horizontalAlignment = horizontalAlignment;
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    TableCellRenderer r = table.getTableHeader().getDefaultRenderer();
    JLabel l = (JLabel)r.getTableCellRendererComponent(
        table,value,isSelected,hasFocus,row,column);
    l.setHorizontalAlignment(horizontalAlignment);
    return l;
  }
}
</code></pre>

### 解説
- `Test1`:
    - `JTableHeader`から、`DefaultRenderer`を取得し、`setHorizontalAlignment`メソッドで字揃えを設定
    - すべての列の字揃えが変更される

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>((JLabel)table.getTableHeader().getDefaultRenderer()).setHorizontalAlignment(SwingConstants.CENTER);
</code></pre>

- `Test2`:
    - `DefaultTableCellRenderer`を継承するレンダラーを設定
    - `LookAndFeel`の色などが表示されない？

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.getTableHeader().setDefaultRenderer(new DefaultTableCellRenderer() {
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    super.getTableCellRendererComponent(
        table,value,isSelected,hasFocus,row,column);
    setHorizontalAlignment(SwingConstants.CENTER);
    return this;
    }
});
</code></pre>

- `Test3`:
    - `TableCellRenderer#getTableCellRendererComponent(...)`メソッド内で、デフォルトのヘッダレンダラーを取得し、字揃えを設定
    - 上記の`HorizontalAlignmentHeaderRenderer`を全ての列に設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>table.getColumnModel().getColumn(0).setHeaderRenderer(
    new HorizontalAlignmentHeaderRenderer(SwingConstants.LEFT));
table.getColumnModel().getColumn(1).setHeaderRenderer(
    new HorizontalAlignmentHeaderRenderer(SwingConstants.CENTER));
table.getColumnModel().getColumn(2).setHeaderRenderer(
    new HorizontalAlignmentHeaderRenderer(SwingConstants.RIGHT));
</code></pre>

- - - -
以下の方法でも `0`列目だけ中央揃えにすることが可能だが、初回が`WindowsLookAndFeel`などの`SystemLookAndFeel`の場合、`LookAndFeel`を変更すると`NullPointerException`が発生する(それ以外の場合でもヘッダの`LookAndFeel`が切り替わらない)。

<pre class="prettyprint"><code>try{
  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
}catch(Exception e) {
  e.printStackTrace();
}
//...
final TableCellRenderer renderer = table.getTableHeader().getDefaultRenderer();
//table.getColumnModel().getColumn(0).setHeaderRenderer(new TableCellRenderer() {
table.getTableHeader().setDefaultRenderer(new TableCellRenderer() {
  @Override public Component getTableCellRendererComponent(JTable table, Object value,
          boolean isSelected, boolean hasFocus, int row, int column) {
    JLabel l = (JLabel)renderer.getTableCellRendererComponent(
          table,value,isSelected,hasFocus,row,column);
    if(table.convertColumnIndexToModel(column)==0) {
      l.setHorizontalAlignment(SwingConstants.CENTER);
    }else{
      l.setHorizontalAlignment(SwingConstants.LEFT);
    }
    return l;
  }
});
</code></pre>

### 参考リンク
- [JTableHeaderのフォントを変更](http://terai.xrea.jp/Swing/HeaderFont.html)

<!-- dummy comment line for breaking list -->

### コメント