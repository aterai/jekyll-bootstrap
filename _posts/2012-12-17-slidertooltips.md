---
layout: post
category: swing
folder: SliderToolTips
title: JSliderのノブをドラッグ中にToolTipで値を表示
tags: [JSlider, JWindow, JToolTip]
author: aterai
pubdate: 2012-12-17T00:06:15+09:00
description: JSliderのノブをドラッグ中にToolTipでその現在値を表示します。
image: https://lh6.googleusercontent.com/-RBRHhAqSA3A/UM3gOvnmIOI/AAAAAAAABZM/LdLir_Y4dQc/s800/SliderToolTips.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2015/10/display-tooltip-while-dragging-jslider.html
    lang: en
comments: true
---
## 概要
`JSlider`のノブをドラッグ中に`ToolTip`でその現在値を表示します。

{% download https://lh6.googleusercontent.com/-RBRHhAqSA3A/UM3gOvnmIOI/AAAAAAAABZM/LdLir_Y4dQc/s800/SliderToolTips.png %}

## サンプルコード
<pre class="prettyprint"><code>class SliderPopupListener extends MouseAdapter {
  private final JWindow toolTip = new JWindow();
  private final JLabel label = new JLabel("", SwingConstants.CENTER);
  private final Dimension size = new Dimension(30, 20);
  private int prevValue = -1;

  public SliderPopupListener() {
    label.setOpaque(false);
    label.setBackground(UIManager.getColor("ToolTip.background"));
    label.setBorder(UIManager.getBorder("ToolTip.border"));
    toolTip.add(label);
    toolTip.setSize(size);
  }

  protected void updateToolTip(MouseEvent me) {
    JSlider slider = (JSlider) me.getSource();
    int intValue = (int) slider.getValue();
    if (prevValue != intValue) {
      label.setText(String.format("%03d", slider.getValue()));
      Point pt = me.getPoint();
      pt.y = -size.height;
      SwingUtilities.convertPointToScreen(pt, (Component) me.getSource());
      pt.translate(-size.width / 2, 0);
      toolTip.setLocation(pt);
    }
    prevValue = intValue;
  }

  @Override public void mouseDragged(MouseEvent me) {
    updateToolTip(me);
  }

  @Override public void mousePressed(MouseEvent me) {
    toolTip.setVisible(true);
    updateToolTip(me);
  }

  @Override public void mouseReleased(MouseEvent me) {
    toolTip.setVisible(false);
  }
}
</code></pre>

## 解説
上記のサンプルでは、ノブをマウスでドラッグ中の場合のみ値を表示するために、`JToolTip`ではなく`JWindow`を使用しています。

- `JWindow`
    - `JToolTip`と背景色などが同じになるよう設定
- `MouseListener`
    - `JWindow`の表示非表示の切り替え
- `MouseMotionListener`
    - `JSlider`が指す値と`JWindow`の位置(中心がマウスカーソルの`x`座標、`JWindow`の下端が`JSlider`の上端)の更新

<!-- dummy comment line for breaking list -->

- - - -
- デフォルトの`JSlider`ではノブ以外の位置をクリックすると段階的に位置が変化するため、上記の`MouseListener`を使用するとマウスカーソルの位置とノブの表示位置がずれる
- [JSliderでクリックした位置にノブをスライド](https://ateraimemo.com/Swing/JumpToClickedPositionSlider.html)を使用してクリック直後にその位置にノブ移動するように設定
- `SwingConstants.VERTICAL`には未対応

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSliderでクリックした位置にノブをスライド](https://ateraimemo.com/Swing/JumpToClickedPositionSlider.html)
- [JToolTipの表示位置](https://ateraimemo.com/Swing/ToolTipLocation.html)

<!-- dummy comment line for breaking list -->

## コメント
