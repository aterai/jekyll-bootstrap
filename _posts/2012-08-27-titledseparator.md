---
layout: post
category: swing
folder: TitledSeparator
title: TitledBorderとMatteBorderを使用してTitledSeparatorを作成する
tags: [JSeparator, TitledBorder, MatteBorder, JLabel, Icon, LinearGradientPaint]
author: aterai
pubdate: 2012-08-27T18:52:36+09:00
description: TitledBorderとMatteBorderを使用してTitle付きのSeparatorを作成します。
image: https://lh3.googleusercontent.com/-sRtVayYL37Q/UDs_iiXRk7I/AAAAAAAABRk/71qZoe9vM60/s800/TitledSeparator.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2012/09/create-gradient-titled-separator.html
    lang: en
comments: true
---
## 概要
`TitledBorder`と`MatteBorder`を使用して`Title`付きの`Separator`を作成します。

{% download https://lh3.googleusercontent.com/-sRtVayYL37Q/UDs_iiXRk7I/AAAAAAAABRk/71qZoe9vM60/s800/TitledSeparator.png %}

## サンプルコード
<pre class="prettyprint"><code>class TitledSeparator extends JLabel {
  private final String title;
  private final Color target;
  private final int height;
  private final int titlePosition;
  public TitledSeparator(String title, int height, int titlePosition) {
    this(title, null, height, titlePosition);
  }
  public TitledSeparator(
      String title, Color target, int height, int titlePosition) {
    super();
    this.title = title;
    this.target = target;
    this.height = height;
    this.titlePosition = titlePosition;
    updateBorder();
  }
  private void updateBorder() {
    Icon icon = new TitledSeparatorIcon();
    setBorder(BorderFactory.createTitledBorder(
        BorderFactory.createMatteBorder(height, 0, 0, 0, icon), title,
        TitledBorder.DEFAULT_JUSTIFICATION, titlePosition));
  }
  @Override public Dimension getMaximumSize() {
    Dimension d = super.getPreferredSize();
    d.width = Short.MAX_VALUE;
    return d;
  }
  @Override public void updateUI() {
    super.updateUI();
    updateBorder();
  }
  private class TitledSeparatorIcon implements Icon {
    private int width = -1;
    private Paint painter1;
    private Paint painter2;
    @Override public void paintIcon(Component c, Graphics g, int x, int y) {
      int w = c.getWidth();
      if (w != width || painter1 == null || painter2 == null) {
        width = w;
        Point2D start = new Point2D.Float();
        Point2D end   = new Point2D.Float(width, 0);
        float[] dist  = {0f, 1f};
        Color ec = Optional.ofNullable(getBackground())
                           .orElse(UIManager.getColor("Panel.background"));
        Color sc = Optional.ofNullable(target).orElse(ec);
        painter1 = new LinearGradientPaint(start, end, dist, new Color[] {sc.darker(), ec});
        painter2 = new LinearGradientPaint(start, end, dist, new Color[] {sc.brighter(), ec});
      }
      int h = getIconHeight() / 2;
      Graphics2D g2  = (Graphics2D) g.create();
      g2.setPaint(painter1);
      g2.fillRect(x, y, width, getIconHeight());
      g2.setPaint(painter2);
      g2.fillRect(x, y + h, width, getIconHeight() - h);
      g2.dispose();
    }
    @Override public int getIconWidth() {
      return 200; //dummy width
    }
    @Override public int getIconHeight() {
      return height;
    }
  }
}
</code></pre>

## 解説
`TitledBorder`と、上辺の余白のみグラデーション用のタイル・アイコンを描画する`MatteBorder`を組み合わせ、これを空の`JLabel`に設定することで`TitledSeparator`を作成しています。

- 上
    - タイトルの垂直位置をデフォルトの`TitledBorder.DEFAULT_POSITION`にして、`Separator`上に重なるように表示
    - `Java 1.6.0`では、タイトルの上に`Separator`が表示される場合がある？(`1.7.0`では正常)
    - 垂直方向は未対応
- 中
    - タイトルの垂直位置が上(`TitledBorder.ABOVE_TOP`)で、`Separator`の上に表示
- 下
    - デフォルトの`JSeparator`を使用

<!-- dummy comment line for breaking list -->

## 参考リンク
- [TitledBorderのタイトル位置](https://ateraimemo.com/Swing/TitledBorder.html)
- [Separatorのグラデーション](https://ateraimemo.com/Swing/Gradient.html)

<!-- dummy comment line for breaking list -->

## コメント
