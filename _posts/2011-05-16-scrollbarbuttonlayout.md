---
layout: post
title: JScrollBarのButtonの位置を変更
category: swing
folder: ScrollBarButtonLayout
tags: [JScrollPane, JScrollBar, ArrowButton]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2011-05-16

## JScrollBarのButtonの位置を変更
`JScrollBar`の`Button`の位置を変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TdC-jTZ434I/AAAAAAAAA7I/cnbdjlwODJg/s800/ScrollBarButtonLayout.png)

### サンプルコード
<pre class="prettyprint"><code>scrollbar.setUI(new WindowsScrollBarUI() {
  //Quote from javax.swing.plaf.basic.BasicScrollBarUI
  @Override protected void layoutVScrollbar(JScrollBar sb) {
    Dimension sbSize = sb.getSize();
    Insets sbInsets = sb.getInsets();

    /*
     * Width and left edge of the buttons and thumb.
     */
    int itemW = sbSize.width - (sbInsets.left + sbInsets.right);
    int itemX = sbInsets.left;

    /* Nominal locations of the buttons, assuming their preferred
     * size will fit.
     */
    boolean squareButtons = false;
    //DefaultLookup.getBoolean(scrollbar, this, "ScrollBar.squareButtons", false);
    int decrButtonH = squareButtons
      ? itemW : decrButton.getPreferredSize().height;
    int incrButtonH = squareButtons
      ? itemW : incrButton.getPreferredSize().height;

    //int decrButtonY = sbInsets.top;
    int decrButtonY = sbSize.height - (sbInsets.bottom + incrButtonH + decrButtonH);
    int incrButtonY = sbSize.height - (sbInsets.bottom + incrButtonH);

    /* The thumb must fit within the height left over after we
     * subtract the preferredSize of the buttons and the insets
     * and the gaps
     */
    int sbInsetsH = sbInsets.top + sbInsets.bottom;
    int sbButtonsH = decrButtonH + incrButtonH;

    //need before 1.7.0 ----&gt;
    int decrGap = 0; //ins
    int incrGap = 0; //ins
    //incrGap = UIManager.getInt("ScrollBar.incrementButtonGap");
    //decrGap = UIManager.getInt("ScrollBar.decrementButtonGap");
    //&lt;----

    int gaps = decrGap + incrGap;
    float trackH = sbSize.height - (sbInsetsH + sbButtonsH) - gaps;

    /* Compute the height and origin of the thumb.   The case
     * where the thumb is at the bottom edge is handled specially
     * to avoid numerical problems in computing thumbY.  Enforce
     * the thumbs min/max dimensions.  If the thumb doesn't
     * fit in the track (trackH) we'll hide it later.
     */
    float min = sb.getMinimum();
    float extent = sb.getVisibleAmount();
    float range = sb.getMaximum() - min;
    //float value = getValue(sb); //del
    float value = sb.getValue(); //ins

    int thumbH = (range &lt;= 0) ? getMaximumThumbSize().height
                              : (int)(trackH * (extent / range));
    thumbH = Math.max(thumbH, getMinimumThumbSize().height);
    thumbH = Math.min(thumbH, getMaximumThumbSize().height);

    int thumbY = incrButtonY - incrGap - thumbH;
    if(value &lt; (sb.getMaximum() - sb.getVisibleAmount())) {
      float thumbRange = trackH - thumbH;
      thumbY = (int)(0.5f + (thumbRange * ((value - min) / (range - extent))));
      //thumbY +=  decrButtonY + decrButtonH + decrGap; //del
    }

    /* If the buttons don't fit, allocate half of the available
     * space to each and move the lower one (incrButton) down.
     */
    int sbAvailButtonH = (sbSize.height - sbInsetsH);
    if(sbAvailButtonH &lt; sbButtonsH) {
      incrButtonH = decrButtonH = sbAvailButtonH / 2;
      incrButtonY = sbSize.height - (sbInsets.bottom + incrButtonH);
    }
    decrButton.setBounds(itemX, decrButtonY, itemW, decrButtonH);
    incrButton.setBounds(itemX, incrButtonY, itemW, incrButtonH);

    /* Update the trackRect field.
     */
    //int itrackY = decrButtonY + decrButtonH + decrGap; //del
    //int itrackH = incrButtonY - incrGap - itrackY; //del
    int itrackY = 0; //ins
    int itrackH = decrButtonY - itrackY; //ins
    trackRect.setBounds(itemX, itrackY, itemW, itrackH);

    /* If the thumb isn't going to fit, zero it's bounds.  Otherwise
     * make sure it fits between the buttons.  Note that setting the
     * thumbs bounds will cause a repaint.
     */
    if(thumbH &gt;= (int)trackH) {
      setThumbBounds(0, 0, 0, 0);
    }else{
      //if((thumbY + thumbH) &gt; incrButtonY - incrGap) {
      //  thumbY = incrButtonY - incrGap - thumbH;
      //}
      //if(thumbY &lt; (decrButtonY + decrButtonH + decrGap)) {
      //  thumbY = decrButtonY + decrButtonH + decrGap + 1;
      //}
      if((thumbY + thumbH) &gt; decrButtonY - decrGap) {
        thumbY = decrButtonY - decrGap - thumbH;
      }
      if(thumbY &lt; 0) { //(decrButtonY + decrButtonH + decrGap)) {
        thumbY = 1; //decrButtonY + decrButtonH + decrGap + 1;
      }
      setThumbBounds(itemX, thumbY, itemW, thumbH);
    }
  }
});
</code></pre>

### 解説
上記のサンプルでは、`WindowsScrollBarUI#layoutVScrollbar(...)`をオーバーライドして、垂直スクロールバーの増加、減少ボタンが両方下側に配置されるようにレイアウトマネージャを変更しています。

### 参考リンク
- スクロールバーのボタンの位置ではなく、スクロールバー自体の位置を変更する場合は、[JScrollBarをJScrollPaneの左と上に配置](http://terai.xrea.jp/Swing/LeftScrollBar.html)

<!-- dummy comment line for breaking list -->

### コメント
- 水平スクロールバーには今のところ対応していない。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-05-16 (月) 15:08:24

<!-- dummy comment line for breaking list -->

