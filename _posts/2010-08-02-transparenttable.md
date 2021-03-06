---
layout: post
category: swing
folder: TransparentTable
title: JTableを半透明にする
tags: [JTable, Transparent, Translucent, TableCellEditor, JViewport, JCheckBox]
author: aterai
pubdate: 2010-08-02T19:24:12+09:00
description: JTable自体をsetOpaque(false)で透明に、またセル描画に使用されるJTableの背景色を半透明にするなどの設定で、半透明のJTableを作成します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTV-0biw5I/AAAAAAAAAog/GI9-wLqeOK8/s800/TransparentTable.png

hreflang:
    href: https://java-swing-tips.blogspot.com/2010/08/transparent-translucent-jtable.html
    lang: en
comments: true
---
## 概要
`JTable`自体を`setOpaque(false)`で透明に、またセル描画に使用される`JTable`の背景色を半透明にするなどの設定で、半透明の`JTable`を作成します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTV-0biw5I/AAAAAAAAAog/GI9-wLqeOK8/s800/TransparentTable.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(table) {
  private final TexturePaint texture = makeImageTexture();
  @Override protected JViewport createViewport() {
    return new JViewport() {
      @Override protected void paintComponent(Graphics g) {
        if (texture != null) {
          Graphics2D g2 = (Graphics2D) g;
          g2.setPaint(texture);
          g2.fillRect(0, 0, getWidth(), getHeight());
        }
        super.paintComponent(g);
      }
    };
  }
};
Color alphaZero = new Color(0x0, true);
table.setOpaque(false);
table.setBackground(alphaZero);
scroll.getViewport().setOpaque(false);
scroll.getViewport().setBackground(alphaZero);
</code></pre>

## 解説
上記のサンプルでは、`JViewport`と`JTable`のそれぞれに`setOpaque(false)`, `setBackground(new Color(0x0, true));`と設定することで、透明な`JTable`を作成しています。テクスチャ画像は`JViewport`の`paintComponent(...)`メソッドをオーバーライドして表示しています。

- - - -
- `JTable`の`CellEditor`は`JTable#prepareEditor(...)`をオーバーライドして、以下のように設定
    - `JTextField`: `Object.class`のデフォルト
        - 常に`setOpaque(false);`
    - `JCheckBox`: `Boolean.class`のデフォルト
        - 常に`setBackground(JTable#getSelectionBackground());`

<!-- dummy comment line for breaking list -->

- - - -
- `JTable`の背景色にアルファ値を設定して透過性を持たせた場合、デフォルトの`BooleanRenderer`では色が濃くなる(`2`重に描画されてしまう)ので、`paintComponent(...)`メソッドを以下のようにオーバーライドして回避

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>class TranslucentBooleanRenderer extends JCheckBox implements TableCellRenderer {
  private final Border noFocusBorder = new EmptyBorder(1, 1, 1, 1);
  public TranslucentBooleanRenderer() {
    super();
    setHorizontalAlignment(SwingConstants.CENTER);
    setBorderPainted(true);
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    setHorizontalAlignment(SwingConstants.CENTER);
    if (isSelected) {
      setOpaque(true);
      setForeground(table.getSelectionForeground());
      super.setBackground(table.getSelectionBackground());
    } else {
      setOpaque(false);
      setForeground(table.getForeground());
      setBackground(table.getBackground());
    }
    setSelected((value != null &amp;&amp; ((Boolean) value).booleanValue()));
    if (hasFocus) {
      setBorder(UIManager.getBorder("Table.focusCellHighlightBorder"));
    } else {
      setBorder(noFocusBorder);
    }
    return this;
  }
  @Override protected void paintComponent(Graphics g) {
    if (!isOpaque()) {
      g.setColor(getBackground());
      g.fillRect(0, 0, getWidth(), getHeight());
    }
    super.paintComponent(g);
  }
}
</code></pre>

## 参考リンク
- [江戸の文様（和風素材・デスクトップ壁紙）](http://www.viva-edo.com/komon/edokomon.html)
- [JTextFieldの背景色を半透明にする](https://ateraimemo.com/Swing/TranslucentTextField.html)
- [Unleash Your Creativity with Swing and the Java 2D API!](http://web.archive.org/web/20091205092230/http://java.sun.com/products/jfc/tsc/articles/swing2d/index.html)
- [JTableのヘッダを透明化](https://ateraimemo.com/Swing/TransparentTableHeader.html)

<!-- dummy comment line for breaking list -->

## コメント
