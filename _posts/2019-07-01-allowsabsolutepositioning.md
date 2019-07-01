---
layout: post
category: swing
folder: AllowsAbsolutePositioning
title: JScrollBarのトラック内でクリックした位置につまみを移動する
tags: [JScrollBar, JScrollPane, MouseEvent]
author: aterai
pubdate: 2019-07-01T15:24:36+09:00
description: JScrollBarのトラック内でマウスをクリックしたときその位置につまみを移動するよう設定します。
image: https://drive.google.com/uc?id=1f0Csg0eVLTBJVFWHOsOlnz1dIv-7j6Hs
comments: true
---
## 概要
`JScrollBar`のトラック内でマウスをクリックしたときその位置につまみを移動するよう設定します。

{% download https://drive.google.com/uc?id=1f0Csg0eVLTBJVFWHOsOlnz1dIv-7j6Hs %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("ScrollBar.allowsAbsolutePositioning", Boolean.TRUE);
// ...
class AbsolutePositioningBasicScrollBarUI extends BasicScrollBarUI {
  @Override protected TrackListener createTrackListener() {
    return new TrackListener() {
      @Override public void mousePressed(MouseEvent e) {
        if (SwingUtilities.isLeftMouseButton(e)) {
          super.mousePressed(new MouseEvent(
              e.getComponent(), e.getID(), e.getWhen(),
              InputEvent.BUTTON2_DOWN_MASK ^ InputEvent.BUTTON2_MASK,
              e.getX(), e.getY(),
              e.getXOnScreen(), e.getYOnScreen(),
              e.getClickCount(),
              e.isPopupTrigger(),
              MouseEvent.BUTTON2));
        } else {
          super.mousePressed(e);
        }
      }
    };
  }
}
</code></pre>

## 解説
上記のサンプルでは、`UIManager.put("ScrollBar.allowsAbsolutePositioning", Boolean.TRUE);`を設定して、`JScrollBar`のトラック内でマウスを中クリックしたときにその位置につまみを移動し、続けてドラッグ可能になるよう設定しています。

- 左:
    - `UIManager.put("ScrollBar.allowsAbsolutePositioning", Boolean.TRUE);`を設定してマウスの中ボタンクリックの場合は、その位置まで`JScrollBar`のつまみ(`Thumb`)を移動
    - 左、右ボタンはこの設定に影響しない
- 右:
    - `UIManager.put("ScrollBar.allowsAbsolutePositioning", Boolean.TRUE);`を設定してマウスの中ボタンクリックの場合は、その位置まで`JScrollBar`のつまみ(`Thumb`)を移動
    - `TrackListener#super.mousePressed()`メソッドをオーバーライドした`ScrollBarUI`を`JScrollBar`に設定し、左ボタンクリックを中ボタンクリックに変換してつまみの絶対位置移動を可能にしている
        - 修飾子(`modifiers`)を`InputEvent.BUTTON2_DOWN_MASK ^ InputEvent.BUTTON2_MASK`、ボタン番号を`MouseEvent.BUTTON2`に変更した`MouseEvent`に差し替え

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JScrollBar - コンポーネント固有のプロパティ](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/synth/doc-files/componentProperties.html#JScrollBar)
- [JSliderでクリックした位置にノブをスライド](https://ateraimemo.com/Swing/JumpToClickedPositionSlider.html)
    - `JSlider`には同様のプロパティが用意されていないので、すこし複雑な処理が必要になる
- [JLabelとIconで作成した検索位置表示バーをマウスで操作する](https://ateraimemo.com/Swing/BoundedRangeModel.html)
    - `JLabel`と`Icon`で作成した`JScrollBar`風コンポーネントなので、デフォルトで絶対位置移動と続けてドラッグが可能

<!-- dummy comment line for breaking list -->

## コメント
