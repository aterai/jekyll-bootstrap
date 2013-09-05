---
layout: post
title: JTableのセルを横方向に連結する
category: swing
folder: ColumnSpanningCellRenderer
tags: [JTable, TableCellRenderer, JTextArea, JScrollPane]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2013-05-13

## JTableのセルを横方向に連結する
`JTable`のセルを横方向に連結するセルレンダラーを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/-wcXag_bBidU/UY-uA3riCRI/AAAAAAAABrs/Q_V-fdNVRu8/s800/ColumnSpanningCellRenderer.png)

### サンプルコード
<pre class="prettyprint"><code>class ColumnSpanningCellRenderer extends JPanel implements TableCellRenderer{
  private final JTextArea textArea = new JTextArea(2, 999999);
  private final JLabel label = new JLabel();
  private final JLabel iconLabel = new JLabel();
  private final JScrollPane scroll = new JScrollPane();

  public ColumnSpanningCellRenderer() {
    super(new BorderLayout(0, 0));

    scroll.setViewportView(textArea);
    scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
    scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
    scroll.setBorder(BorderFactory.createEmptyBorder());
    scroll.setViewportBorder(BorderFactory.createEmptyBorder());
    scroll.setOpaque(false);
    scroll.getViewport().setOpaque(false);

    textArea.setBorder(BorderFactory.createEmptyBorder());
    textArea.setMargin(new Insets(0, 0, 0, 0));
    textArea.setForeground(Color.RED);
    textArea.setEditable(false);
    textArea.setFocusable(false);
    textArea.setOpaque(false);

    iconLabel.setBorder(BorderFactory.createEmptyBorder(0, 4, 0, 4));
    iconLabel.setOpaque(false);

    Border b1 = BorderFactory.createEmptyBorder(2, 2, 2, 2);
    Border b2 = BorderFactory.createMatteBorder(0, 0, 1, 1, Color.GRAY);
    label.setBorder(BorderFactory.createCompoundBorder(b2, b1));

    setBackground(textArea.getBackground());
    setOpaque(true);
    add(label, BorderLayout.NORTH);
    add(scroll);
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected,
      boolean hasFocus, int row, int column) {
    Test test;
    if(value instanceof Test) {
      test = (Test)value;
      add(iconLabel, BorderLayout.WEST);
    }else{
      int mrow = table.convertRowIndexToModel(row);
      String title = value!=null ? value.toString() : "";
      Test t = (Test)table.getModel().getValueAt(mrow, 0);
      String text = t!=null ? t.text : "";
      Icon icon = t!=null ? t.icon : null;
      test = new Test(title, icon, text);
      remove(iconLabel);
    }
    label.setText(test.title);
    textArea.setText(test.text);
    iconLabel.setIcon(test.icon);

    Rectangle cr = table.getCellRect(row, column, false);
/*/ //Flickering on first visible row ?
    if(column==0) {
      cr.x = 0;
      cr.width -= iconLabel.getPreferredSize().width;
    }else{
      cr.x -= iconLabel.getPreferredSize().width;
    }
    textArea.scrollRectToVisible(cr);
/*/
    if(column!=0) cr.x -= iconLabel.getPreferredSize().width;
    scroll.getViewport().setViewPosition(cr.getLocation());
//*/
    if(isSelected) {
      setBackground(Color.ORANGE);
    }else{
      setBackground(Color.WHITE);
    }
    return this;
  }
}
</code></pre>

### 解説
文字列を配置した`JTextArea`を各カラムごとに`JViewport`で表示する領域を切り取ってセルに貼り付けています。さらに、`JTable`のセルの縦罫線自体は、`table.setShowVerticalLines(false);`などで非表示にすることでレンダラー内の`JTextArea`は、連続しているように見せかけ、上部の`JLabel`は`Border`を設定することで区切りを表示しています。

- メモ
    - 列の入れ替えには対応していない
    - `0`行目だけカラムヘッダのサイズを変更すると、描画がおかしくなる？
        - `0`行目ではなく、一番上に表示されている行の表示が乱れている
        - `JTextArea#scrollRectToVisible(...)`ではなく、`JViewport#setViewPosition(Point)`を使用すると正常にリサイズできる
        - ~~`0`行目だけ高さ`1`のダミー行を追加して回避(ソートなどで問題が残る)~~
    - ~~`JTable`のクリック(セル選択？)などで表示が乱れる場合がある~~
        - ~~`JTable#repaint(Rectangle)`をオーバーライドして常に全体を描画することで回避~~

<!-- dummy comment line for breaking list -->

### 参考リンク
- [PDF: Extreme GUI Makeover 2007](http://docs.huihoo.com/javaone/2007/desktop/TS-3548.pdf)
    - via: [java - JTable : Complex Cell Renderer - Stack Overflow](http://stackoverflow.com/questions/16305023/jtable-complex-cell-renderer)
- [JTableの罫線の有無とセルの内余白を変更](http://terai.xrea.jp/Swing/IntercellSpacing.html)

<!-- dummy comment line for breaking list -->

### コメント
- JTableをスクロールするとおかしくなる？ -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-04 (火) 13:37:19
    - `0`行目ではなく、一番上に表示されている行の表示が原因かもしれない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-04 (火) 13:44:14
    - 移動の幅からみて、`TableCellRenderer`の`Border`が関連しているような気がするけど、よく分からない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-04 (火) 15:08:18
    - 一番上の行のみの症状なので、ヘッダレンダラーとか関係してるのかと調べてたけど、`JViewport#setViewPosition(Point)`を使って直接ジャンプ？すれは、正常にヘッダサイズを変更できるようだ。もしかしたら[次にビューポートにペイントが呼び出されたときに、クリッピング領域がビューポートサイズより小さい場合には、タイマーが開始され全体をペイントし直す](http://docs.oracle.com/javase/jp/6/api/javax/swing/JViewport.html)せいだった？ -- [aterai](http://terai.xrea.jp/aterai.html) 2013-06-04 (火) 18:29:12

<!-- dummy comment line for breaking list -->
