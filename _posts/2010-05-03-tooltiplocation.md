---
layout: post
category: swing
folder: ToolTipLocation
title: JToolTipの表示位置
tags: [JToolTip, JWindow, MouseListener, MouseMotionListener]
author: aterai
pubdate: 2010-05-03T22:32:22+09:00
description: JToolTipの表示位置がドラッグでマウスカーソルに追従するように設定します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTVoUwnbfI/AAAAAAAAAn8/lAHqv08RJKA/s800/ToolTipLocation.png
comments: true
---
## 概要
`JToolTip`の表示位置がドラッグでマウスカーソルに追従するように設定します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTVoUwnbfI/AAAAAAAAAn8/lAHqv08RJKA/s800/ToolTipLocation.png %}

## サンプルコード
<pre class="prettyprint"><code>private void updateTipText(MouseEvent e) {
  Point pt = e.getPoint();
  String txt = String.format("Window(x, y)=(%d, %d)", pt.x, pt.y);
  tip.setTipText(txt);
  Point p = getToolTipLocation(e);
  if (SwingUtilities.isLeftMouseButton(e)) {
    if (prev.length() != txt.length()) {
      window.pack();
    }
    window.setLocation(p);
    window.setAlwaysOnTop(true);
  } else {
    if (popup != null) {
      popup.hide();
    }
    popup = factory.getPopup(e.getComponent(), tip, p.x, p.y);
    Container c = tip.getTopLevelAncestor();
    if (c instanceof JWindow &amp;&amp;
        ((JWindow) c).getType() == Window.Type.POPUP) {
      System.out.println("Popup$HeavyWeightWindow");
    } else {
      popup.show();
    }
  }
  prev = txt;
}
</code></pre>

## 解説
- 左クリックしてドラッグ
    - `JWindow`に`JToolTip`を追加し、`Window#setLocation()`メソッドで移動
    - テキスト文字数が変更された場合のみ`JWindow#pack()`メソッドを呼び出してサイズを更新
- 左クリック以外でドラッグ
    - `PopupFactory#getPopup()`で`Popup`を取得して表示
    - `Popup`の位置が変更できずこれを再作成しているため、親フレームの外に`JToolTip`が表示される場合は非表示に設定
        - フレーム外では`HeavyWeight`の`JWindow`で`JToolTip`が表示されるため、再作成すると表示がチラついてしまう

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSliderのノブをドラッグ中にToolTipで値を表示](https://ateraimemo.com/Swing/SliderToolTips.html)

<!-- dummy comment line for breaking list -->

## コメント
