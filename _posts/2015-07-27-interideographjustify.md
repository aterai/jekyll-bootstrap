---
layout: post
category: swing
folder: InterIdeographJustify
title: JTableのセル内文字列を両端揃えにする
tags: [JTable, TableCellRenderer, JLabel]
author: aterai
pubdate: 2015-07-27T01:01:41+09:00
description: JTableのセル内に配置した文字列を両端揃えに設定します。
image: https://lh3.googleusercontent.com/-TCAfQOApIl0/VbUAibr0qaI/AAAAAAAAN94/StM8EiBCt_w/s800-Ic42/InterIdeographJustify.png
comments: true
---
## 概要
`JTable`のセル内に配置した文字列を両端揃えに設定します。

{% download https://lh3.googleusercontent.com/-TCAfQOApIl0/VbUAibr0qaI/AAAAAAAAN94/StM8EiBCt_w/s800-Ic42/InterIdeographJustify.png %}

## サンプルコード
<pre class="prettyprint"><code>class InterIdeographJustifyCellRenderer implements TableCellRenderer {
  private final JustifiedLabel l = new JustifiedLabel();
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean selected, boolean focused,
      int row, int column) {
    l.setBorder(BorderFactory.createEmptyBorder(0, 5, 0, 5));
    l.setText(Objects.toString(value, ""));
    return l;
  }
}

class JustifiedLabel extends JLabel {
  private transient TextLayout layout;
  private int prevWidth = -1;
  public JustifiedLabel() {
    this(null);
  }
  public JustifiedLabel(String str) {
    super(str);
  }
  @Override public void setText(String text) {
    super.setText(text);
    prevWidth = -1;
  }
  @Override protected void paintComponent(Graphics g) {
    Graphics2D g2 = (Graphics2D) g.create();
    Font font = getFont();
    Insets ins = getInsets();
    Dimension d = getSize();
    int w = d.width - ins.left - ins.right;
    if (w != prevWidth) {
      prevWidth = w;
      String s = getText();
      TextLayout tl = new TextLayout(s, font, g2.getFontRenderContext());
      layout = tl.getJustifiedLayout((float) w);
    }
    g2.setPaint(getBackground());
    g2.fillRect(0, 0, d.width, d.height);
    g2.setPaint(getForeground());
    int baseline = ins.top + font.getSize();
    layout.draw(g2, (float) ins.left, (float) baseline);
    g2.dispose();
  }
}
</code></pre>

## 解説
上記のサンプルでは、セルレンダラーとして文字列を両端揃えで表示する`JLabel`を作成し、`0`列目に設定しています。

- この`JLabel`は`TextLayout#getJustifiedLayout(float)`メソッドを使用して両端揃えを行った`TextLayout`を描画しているため、セルの幅が文字列幅より短くなる場合は文字が重なる
- デフォルトの`JLabel`のようにセル幅が足りない場合は`...`で省略する機能を実装していない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JLabelの文字揃え](https://ateraimemo.com/Swing/JustifiedLabel.html)
    - `GlyphVector`を使用して`JLabel`で両端揃えを行うサンプル
- [JTableのセル文字揃え](https://ateraimemo.com/Swing/CellTextAlignment.html)

<!-- dummy comment line for breaking list -->

## コメント
