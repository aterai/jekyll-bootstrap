---
layout: post
category: swing
folder: DisableScrollDueToClickInTrack
title: JSliderのトラックをクリックしても値の変更が発生しないように設定する
tags: [JSlider, JLayer]
author: aterai
pubdate: 2016-10-10T01:47:45+09:00
description: JSliderのノブのドラッグとカーソルキーでのみ値変更を許可し、トラックのマウスクリックによる値変更を無効にします。
image: https://drive.google.com/uc?id=1ifIQLyAQgYQFw_5p3MbXRm4Z9j5VB33lSg
comments: true
---
## 概要
`JSlider`のノブのドラッグとカーソルキーでのみ値変更を許可し、トラックのマウスクリックによる値変更を無効にします。

{% download https://drive.google.com/uc?id=1ifIQLyAQgYQFw_5p3MbXRm4Z9j5VB33lSg %}

## サンプルコード
<pre class="prettyprint"><code>slider.setUI(new MetalSliderUI() {
  @Override protected TrackListener createTrackListener(JSlider slider) {
    return new TrackListener() {
      @Override public boolean shouldScroll(int direction) {
        return false;
      }
    };
  }
});
</code></pre>

## 解説
上記のサンプルでは、以下の`2`種類の方法で`Slider`のトラックをマウスでクリックしても値変更が発生しないように設定しています。

- `Override TrackListener#shouldScroll(...): false`
    - `BasicSliderUI#createTrackListener(...)`メソッドをオーバーライドし、`shouldScroll(...)`メソッドが常に`false`を返す`TrackListener`を生成する
    - `BasicSliderUI#scrollDueToClickInTrack(...)`メソッドを空にしても、長押しでスクロールを行う`Timer`が起動して`BasicSliderUI#scrollByBlock(...)`などが実行されて値が変化する
- `JLayer + Slider.onlyLeftMouseButtonDrag: false`
    - `UIManager.put("Slider.onlyLeftMouseButtonDrag", false);`を設定し、かつマウスの右ボタンでノブのドラッグを可能に設定して`JLayer`を使用して左ボタンの押下を右ボタンの押下に入れ替える
    - 参考: [JSliderのノブをマウスの右ボタンで操作不可に設定する](https://ateraimemo.com/Swing/OnlyLeftMouseButtonDrag.html)
    - トラックの右クリックは元々無効なので、この入れ替えによりトラックのクリックによる値変更は無効になる
        
        <pre class="prettyprint"><code>class DisableLeftPressedLayerUI extends LayerUI&lt;JSlider&gt; {
          @Override public void installUI(JComponent c) {
            super.installUI(c);
            if (c instanceof JLayer) {
              ((JLayer) c).setLayerEventMask(AWTEvent.MOUSE_EVENT_MASK);
            }
          }
          @Override public void uninstallUI(JComponent c) {
            if (c instanceof JLayer) {
              ((JLayer) c).setLayerEventMask(0);
            }
            super.uninstallUI(c);
          }
          @Override protected void processMouseEvent(
              MouseEvent e, JLayer&lt;? extends JSlider&gt; l) {
            if (e.getID() == MouseEvent.MOUSE_PRESSED
                &amp;&amp; SwingUtilities.isLeftMouseButton(e)) {
              e.getComponent().dispatchEvent(new MouseEvent(
                  e.getComponent(),
                  e.getID(), e.getWhen(),
                  InputEvent.BUTTON3_DOWN_MASK, //e.getModifiers(),
                  e.getX(), e.getY(),
                  e.getXOnScreen(), e.getYOnScreen(),
                  e.getClickCount(),
                  e.isPopupTrigger(),
                  MouseEvent.BUTTON3)); //e.getButton());
              e.consume();
            }
          }
        }
</code></pre>
    - * 参考リンク [#reference]
- [java - Stopping the jslider from moving when clicked - Stack Overflow](https://stackoverflow.com/questions/39904127/stopping-the-jslider-from-moving-when-clicked)

<!-- dummy comment line for breaking list -->

## コメント
