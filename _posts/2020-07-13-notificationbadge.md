---
layout: post
category: swing
folder: NotificationBadge
title: JLabel内のアイコンにJLayerを使用してバッジを表示する
tags: [JLayer, JLabel, Icon, Font]
author: aterai
pubdate: 2020-07-13T00:17:27+09:00
description: JLabelに設定されたアイコンの上にJLayerを使用してバッジを表示します。
image: https://drive.google.com/uc?id=1EAKtyqN5V1bT8MKesW7z3M9tR5TnVcMP
comments: true
---
## 概要
`JLabel`に設定されたアイコンの上に`JLayer`を使用してバッジを表示します。

{% download https://drive.google.com/uc?id=1EAKtyqN5V1bT8MKesW7z3M9tR5TnVcMP %}

## サンプルコード
<pre class="prettyprint"><code>class BadgeLayerUI extends LayerUI&lt;BadgeLabel&gt; {
  private static final int BADGE_SIZE = 17;
  private static final Point OFFSET = new Point(6, 2);
  private final Rectangle viewRect = new Rectangle();
  private final Rectangle iconRect = new Rectangle();
  private final Rectangle textRect = new Rectangle();

  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      Graphics2D g2 = (Graphics2D) g.create();
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      iconRect.setBounds(0, 0, 0, 0);
      textRect.setBounds(0, 0, 0, 0);
      BadgeLabel label = (BadgeLabel) ((JLayer&lt;?&gt;) c).getView();
      SwingUtilities.calculateInnerArea(label, viewRect);
      SwingUtilities.layoutCompoundLabel(
          label,
          label.getFontMetrics(label.getFont()),
          label.getText(),
          label.getIcon(),
          label.getVerticalAlignment(),
          label.getHorizontalAlignment(),
          label.getVerticalTextPosition(),
          label.getHorizontalTextPosition(),
          viewRect,
          iconRect,
          textRect,
          label.getIconTextGap()
      );

      int x = iconRect.x + iconRect.width - BADGE_SIZE + OFFSET.x;
      int y = iconRect.y + iconRect.height - BADGE_SIZE + OFFSET.y;
      g2.translate(x, y);
      Icon badge = new BadgeIcon(label.getCounter(), Color.WHITE, new Color(0xAA_32_16_16, true));
      badge.paintIcon(label, g2, 0, 0);
      g2.dispose();
    }
  }
}
</code></pre>

## 解説
- `JLabel`に`JLayer`を設定して`JLabel`本体ではなく、内部の`Icon`領域の指定した角付近に`Badge`を表示する
    - `JLabel`内部の`Icon`領域は`SwingUtilities.layoutCompoundLabel(...)`メソッドで取得可能
        - 参考: [JLabelのアイコンとテキストのどちらにマウスカーソルがあるかを調査する](https://ateraimemo.com/Swing/LayoutCompoundLabel.html)
    - オフセットとして`x`軸方向に`6px`、`y`軸方向に`2px`ずらして`Badge`を表示しているので`JLabel`にそれ以上の余白を設定する必要がある
    - `JLabel`にテキストも表示する場合は上記のオフセットを考慮して`IconTextGap`を設定しないとテキストと`Badge`が重なる場合がある
- `Badge`用のアイコンは`17x17`の固定サイズで`RoundRectangle2D`か`Ellipse2D`を使用して作成
    - 値が`0`の場合は`Badge`は表示しない
    - 表示する数字が`4`桁以上になる場合はすべて`1K`に設定
        - `Java 12`では[NumberFormat.getCompactNumberInstance(...) (Java SE 12 & JDK 12)](https://docs.oracle.com/javase/jp/12/docs/api/java.base/java/text/NumberFormat.html#getCompactNumberInstance%28java.util.Locale,java.text.NumberFormat.Style%29)が使用可能
    - 表示する数字が`3`桁になる場合は`66%`の変形をかけて長体に設定
        - 参考: [Fontに長体をかけてJTextAreaで使用する](https://ateraimemo.com/Swing/CondensedFontLabel.html)
            
            <pre class="prettyprint"><code>class BadgeIcon implements Icon {
              private final Color badgeBgc;
              private final Color badgeFgc;
              private final int value;
            
              protected BadgeIcon(int value, Color fgc, Color bgc) {
                this.value = value;
                this.badgeFgc = fgc;
                this.badgeBgc = bgc;
              }
            
              @Override public void paintIcon(Component c, Graphics g, int x, int y) {
                if (value &lt;= 0) {
                  return;
                }
                int w = getIconWidth();
                int h = getIconHeight();
                Graphics2D g2 = (Graphics2D) g.create();
                g2.translate(x, y);
                RoundRectangle2D badge = new RoundRectangle2D.Double(0, 0, w, h, 6, 6);
                g2.setPaint(badgeBgc);
                g2.fill(badge);
                g2.setPaint(badgeBgc.darker());
                g2.draw(badge);
            
                g2.setPaint(badgeFgc);
                FontRenderContext frc = g2.getFontRenderContext();
                // Java 12:
                // NumberFormat fmt = NumberFormat.getCompactNumberInstance(
                //     Locale.US, NumberFormat.Style.SHORT);
                // String txt = fmt.format(value);
                String txt = value &gt; 999 ? "1K" : Objects.toString(value);
                AffineTransform at = txt.length() &lt; 3 ? null : AffineTransform.getScaleInstance(.66, 1d);
                Shape shape = new TextLayout(txt, g2.getFont(), frc).getOutline(at);
                Rectangle2D b = shape.getBounds();
                Point2D p = new Point2D.Double(
                    b.getX() + b.getWidth() / 2d, b.getY() + b.getHeight() / 2d);
                AffineTransform toCenterAT = AffineTransform.getTranslateInstance(
                    w / 2d - p.getX(), h / 2d - p.getY());
                g2.fill(toCenterAT.createTransformedShape(shape));
                g2.dispose();
              }
            
              @Override public int getIconWidth() {
                return 17;
              }
            
              @Override public int getIconHeight() {
                return 17;
              }
            }
</code></pre>
        - * 参考リンク [#reference]
- [JLabelのアイコンとテキストのどちらにマウスカーソルがあるかを調査する](https://ateraimemo.com/Swing/LayoutCompoundLabel.html)
- [Fontに長体をかけてJTextAreaで使用する](https://ateraimemo.com/Swing/CondensedFontLabel.html)

<!-- dummy comment line for breaking list -->

## コメント
