---
layout: post
category: swing
folder: DragHereIcon
title: Iconを生成する
tags: [Icon, Graphics, DragAndDrop, TransferHandler]
author: aterai
pubdate: 2012-06-18T18:09:18+09:00
description: Iconインタフェースから固定サイズのアイコンを作成します。
image: https://lh5.googleusercontent.com/-PTY9ydf9DFE/T97u-rwg5lI/AAAAAAAABN0/52xJLmkoNak/s800/DragHereIcon.png
comments: true
---
## 概要
`Icon`インタフェースから固定サイズのアイコンを作成します。

{% download https://lh5.googleusercontent.com/-PTY9ydf9DFE/T97u-rwg5lI/AAAAAAAABN0/52xJLmkoNak/s800/DragHereIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>class DragHereIcon implements Icon {
  private static int ICON_SIZE = 100;
  private static float BORDER_WIDTH = 8f;
  private static float SLIT_WIDTH = 8f;
  private static int ARC_SIZE = 16;
  private static int SLIT_NUM = 3;
  private static Shape BORDER = new RoundRectangle2D.Float(
    BORDER_WIDTH, BORDER_WIDTH,
    ICON_SIZE - 2 * BORDER_WIDTH - 1, ICON_SIZE-2*BORDER_WIDTH - 1,
    ARC_SIZE, ARC_SIZE);
  private static Font font = new Font(Font.MONOSPACED, Font.BOLD, ICON_SIZE);
  private static FontRenderContext frc = new FontRenderContext(null, true, true);
  //DOWNWARDS WHITE ARROW
  private static Shape ARROW = new TextLayout("\u21E9", font, frc).getOutline(null);
  //DOWNWARDS BLACK ARROW
  //private static Shape ARROW = new TextLayout("\u2B07", font, frc).getOutline(null);
  private static Color LINE_COLOR = Color.GRAY;
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {
    Graphics2D g2 = (Graphics2D) g.create();
    g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                        RenderingHints.VALUE_ANTIALIAS_ON);
    g2.translate(x, y);

    g2.setStroke(new BasicStroke(BORDER_WIDTH));
    g2.setPaint(LINE_COLOR);
    g2.draw(BORDER);

    g2.setStroke(new BasicStroke(SLIT_WIDTH));
    g2.setColor(UIManager.getColor("Panel.background"));

    int n = SLIT_NUM + 1;
    int v = ICON_SIZE / n;
    int m = n * v;
    for (int i = 1; i &lt; n; i++) {
      int a = i * v;
      g2.drawLine(a, 0, a, m);
      g2.drawLine(0, a, m, a);
    }

    //g2.drawLine(1 * v, 0 * v, 1 * v, 4 * v);
    //g2.drawLine(2 * v, 0 * v, 2 * v, 4 * v);
    //g2.drawLine(3 * v, 0 * v, 3 * v, 4 * v);
    //g2.drawLine(0 * v, 1 * v, 4 * v, 1 * v);
    //g2.drawLine(0 * v, 2 * v, 4 * v, 2 * v);
    //g2.drawLine(0 * v, 3 * v, 4 * v, 3 * v);

    g2.setPaint(LINE_COLOR);
    Rectangle2D b = ARROW.getBounds2D();
    Point2D p = new Point2D.Double(
        b.getX() + b.getWidth() / 2d, b.getY() + b.getHeight() / 2d);
    AffineTransform toCenterAT = AffineTransform.getTranslateInstance(
        ICON_SIZE / 2d - p.getX(), ICON_SIZE / 2d - p.getY());
    g2.fill(toCenterAT.createTransformedShape(ARROW));
    g2.dispose();
  }
  @Override public int getIconWidth()  {
    return ICON_SIZE;
  }
  @Override public int getIconHeight() {
    return ICON_SIZE;
  }
}
</code></pre>

## 解説
上記のサンプルでは、以下のように`Icon`インタフェースを実装してアイコンを作成しています。フチもアイコンの内部に描画していますが、`BasicStroke`の破線ではなく背景色と同じ色の直線でパターンを表現しています。

- `Icon#paintIcon(Component c, Graphics g, int x, int y)`を実装
    - 原点を移動
    - ラウンド矩形でフチを描画
    - 直線で格子状のスリットを上書き
    - 矢印のアウトラインをフォントから取得して中心に描画
    - 原点を戻す
        - 直接`g.translate(x, y)`で原点を変更した場合、`g.translate(-x, -y)`で元に戻す必要がある
        - または、`Graphics2D g2 = (Graphics2D) g.create()`で別の`Graphics`を生成し、原点を移動した場合は、最後に`g2.dispose()`で破棄する
- `Icon#getIconWidth()`, `Icon#getIconHeight()`を実装してアイコンのサイズを指定-

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Fileのドラッグ＆ドロップ](https://ateraimemo.com/Swing/FileListFlavor.html)
- [swing - Java application with fancy Drag & Drop - Stack Overflow](https://stackoverflow.com/questions/10751001/java-application-with-fancy-drag-drop)

<!-- dummy comment line for breaking list -->

## コメント
- `TransferHandler`でファイルがドロップされるとき、カーソルを常にコピーにする(移動ではなく)方法が分からない(のでこのサンプルでは`DropTarget`を使用)。 -- *aterai* 2012-06-18 (月) 18:25:50

<!-- dummy comment line for breaking list -->
