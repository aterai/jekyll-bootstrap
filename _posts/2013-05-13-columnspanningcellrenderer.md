---
layout: post
category: swing
folder: ColumnSpanningCellRenderer
title: JTableのセルを横方向に連結する
tags: [JTable, TableCellRenderer, JTextArea, JScrollPane]
author: aterai
pubdate: 2013-05-13T16:59:22+09:00
description: JTableのセルを横方向に連結するセルレンダラーを作成します。
image: https://lh5.googleusercontent.com/-wcXag_bBidU/UY-uA3riCRI/AAAAAAAABrs/Q_V-fdNVRu8/s800/ColumnSpanningCellRenderer.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2013/05/column-spanning-tablecellrenderer.html
    lang: en
comments: true
---
## 概要
`JTable`のセルを横方向に連結するセルレンダラーを作成します。

{% download https://lh5.googleusercontent.com/-wcXag_bBidU/UY-uA3riCRI/AAAAAAAABrs/Q_V-fdNVRu8/s800/ColumnSpanningCellRenderer.png %}

## サンプルコード
<pre class="prettyprint"><code>class ColumnSpanningCellRenderer extends JPanel implements TableCellRenderer {
  private static final int TARGET_COLIDX = 0;
  private final JTextArea textArea = new JTextArea(2, 999999);
  private final JLabel label = new JLabel();
  private final JLabel iconLabel = new JLabel();
  private final JScrollPane scroll = new JScrollPane(textArea);

  protected ColumnSpanningCellRenderer() {
    super(new BorderLayout());

    scroll.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
    scroll.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
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
    OptionPaneDescription d;
    if (value instanceof OptionPaneDescription) {
      d = (OptionPaneDescription) value;
      add(iconLabel, BorderLayout.WEST);
    } else {
      String title = Objects.toString(value, "");
      int mrow = table.convertRowIndexToModel(row);
      Object o = table.getModel().getValueAt(mrow, 0);
      if (o instanceof OptionPaneDescription) {
        OptionPaneDescription t = (OptionPaneDescription) o;
        d = new OptionPaneDescription(title, t.icon, t.text);
      } else {
        d = new OptionPaneDescription(title, null, "");
      }
      remove(iconLabel);
    }
    label.setText(d.title);
    textArea.setText(d.text);
    iconLabel.setIcon(d.icon);

    Rectangle cr = table.getCellRect(row, column, false);
    if (column != TARGET_COLIDX) {
      cr.x -= iconLabel.getPreferredSize().width;
    }
    scroll.getViewport().setViewPosition(cr.getLocation());

    if (isSelected) {
      setBackground(Color.ORANGE);
    } else {
      setBackground(Color.WHITE);
    }
    return this;
  }
}

class OptionPaneDescription {
  public final String title;
  public final Icon icon;
  public final String text;
  protected OptionPaneDescription(String title, Icon icon, String text) {
    this.title = title;
    this.icon  = icon;
    this.text  = text;
  }
}
</code></pre>

## 解説
文字列を配置した`JTextArea`を各カラムごとに`JViewport`で表示する領域を切り取ってセルに貼り付けています。さらに`JTable`のセルの縦罫線自体を`table.setShowVerticalLines(false)`などで非表示にしてレンダラー内の`JTextArea`は連続しているように見せかけ、代わりに上部の`JLabel`は`Border`を設定することで区切りを表示しています。

- 列の入れ替えには対応していない
- `0`行目だけカラムヘッダのサイズを変更すると描画がおかしくなる？
    - `0`行目ではなく、一番上に表示されている行の表示が乱れている
    - `JTextArea#scrollRectToVisible(...)`ではなく、`JViewport#setViewPosition(Point)`を使用すると正常にリサイズ可能
    - ~~`0`行目だけ高さ`1`のダミー行を追加して回避(ソートなどで問題が残る)~~
- ~~`JTable`のクリック(セル選択？)などで表示が乱れる場合がある~~
    - ~~`JTable#repaint(Rectangle)`をオーバーライドして常に全体を描画することで回避~~
- `JScrollPane`内に`JTextArea`を配置せずに直接`JTextArea`から表示領域を切り取っても良さそう？

<!-- dummy comment line for breaking list -->

## 参考リンク
- [PDF: Extreme GUI Makeover 2007](http://docs.huihoo.com/javaone/2007/desktop/TS-3548.pdf)
    - via: [java - JTable : Complex Cell Renderer - Stack Overflow](https://stackoverflow.com/questions/16305023/jtable-complex-cell-renderer)
- [JTableの罫線の有無とセルの内余白を変更](https://ateraimemo.com/Swing/IntercellSpacing.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JTable`をスクロールするとおかしくなる？ -- *aterai* 2013-06-04 (火) 13:37:19
    - `0`行目ではなく、一番上に表示されている行の表示が原因かもしれない。 -- *aterai* 2013-06-04 (火) 13:44:14
    - 移動の幅からみて、`TableCellRenderer`の`Border`が関連しているような気がするけど、よく分からない。 -- *aterai* 2013-06-04 (火) 15:08:18
    - 一番上の行のみの症状なので、ヘッダセルレンダラーとか関係してるのかと調べてたけど、`JViewport#setViewPosition(Point)`を使って直接ジャンプ？すれは、正常にヘッダサイズを変更できるようだ。もしかしたら[次にビューポートにペイントが呼び出されたときに、クリッピング領域がビューポートサイズより小さい場合には、タイマーが開始され全体をペイントし直す](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JViewport.html)せい？ -- *aterai* 2013-06-04 (火) 18:29:12

<!-- dummy comment line for breaking list -->
