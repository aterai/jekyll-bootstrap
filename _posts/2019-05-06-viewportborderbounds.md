---
layout: post
category: swing
folder: ViewportBorderBounds
title: JScrollPane内のコンテンツがJViewportの幅より大きい場合その右端に影を描画する
tags: [JScrollPane, JViewport, JScrollBar, BoundedRangeModel, JLayer]
author: aterai
pubdate: 2019-05-06T02:13:15+09:00
description: JScrollPaneに追加したコンポーネントのコンテンツ幅がJViewportの幅より大きく、水平スクロールバーが表示される状態の場合その右端に影を表示します。
image: https://drive.google.com/uc?id=1lQS2oCVJtFYtbAKfXuQLKqKv1FIE2rGBkg
comments: true
---
## 概要
`JScrollPane`に追加したコンポーネントのコンテンツ幅が`JViewport`の幅より大きく、水平スクロールバーが表示される状態の場合その右端に影を表示します。

{% download https://drive.google.com/uc?id=1lQS2oCVJtFYtbAKfXuQLKqKv1FIE2rGBkg %}

## サンプルコード
<pre class="prettyprint"><code>class ScrollPaneLayerUI extends LayerUI&lt;JScrollPane&gt; {
  @Override public void paint(Graphics g, JComponent c) {
    super.paint(g, c);
    if (c instanceof JLayer) {
      JScrollPane scroll = (JScrollPane) ((JLayer&lt;?&gt;) c).getView();
      Rectangle rect = scroll.getViewportBorderBounds();
      BoundedRangeModel m = scroll.getHorizontalScrollBar().getModel();
      int extent = m.getExtent();
      int maximum = m.getMaximum();
      int value = m.getValue();
      if (value + extent &lt; maximum) {
        int w = rect.width;
        int h = rect.height;
        int shd = 6;
        Graphics2D g2 = (Graphics2D) g.create();
        g2.translate(rect.x + w - shd, rect.y);
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                            RenderingHints.VALUE_ANTIALIAS_ON);
        g2.setPaint(new Color(0x08_00_00_00, true));
        for (int i = 0; i &lt; shd; i++) {
          g2.fillRect(i, 0, shd - i, h);
        }
        g2.fillRect(shd - 2, 0, 2, h); // Make the edge a bit darker
        g2.dispose();
      }
    }
  }
}
</code></pre>

## 解説
- `JScrollPane`に`JLayer`を設定し、コンテンツである`JEditorPane`の右側が非表示になっていることを示唆するために`JViewport`の右端に影を描画する
    - コンテンツが`JViewport`の幅より小さい場合や、`JViewport`の表示領域がコンテンツの右端まで到達している場合は影を描画しない
    - コンテンツの右側が非表示になっているかどうかは、`JScrollPane#getHorizontalScrollBar()#getModel()`で`BoundedRangeModel`を取得し、`m.getValue() + m.getExtent() < m.getMaximum()`かで判断
        - 水平スクロールバーが`ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER`で非表示の場合も判別可能
    - 影の描画位置は垂直・水平スクロールバーの表示・非表示に影響されないよう、`JScrollPane#getViewportBorderBounds()`メソッドで`JViewport`のボーダーの境界を取得して決定する

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollPane#getViewportBorderBounds() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JScrollPane.html#getViewportBorderBounds--)
- [JScrollBarが最後までスクロールしたことを確認する](https://ateraimemo.com/Swing/DetectScrollToBottom.html)

<!-- dummy comment line for breaking list -->

## コメント
