---
layout: post
category: swing
folder: OverlayLayout
title: OverlayLayoutの使用
tags: [OverlayLayout, LayoutManager, JButton]
author: aterai
pubdate: 2008-01-14T17:09:44+09:00
description: OverlayLayoutを使用し、JButtonを重ねて配置します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQqzbG85I/AAAAAAAAAf8/GAYWzSVrHvg/s800/OverlayLayout.png
comments: true
---
## 概要
`OverlayLayout`を使用し、`JButton`を重ねて配置します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQqzbG85I/AAAAAAAAAf8/GAYWzSVrHvg/s800/OverlayLayout.png %}

## サンプルコード
<pre class="prettyprint"><code>JButton b1 = new JButton();
JButton b2 = new JButton();
b1.setLayout(new OverlayLayout(b1));
Insets i = b1.getInsets();
b1.setBorder(BorderFactory.createEmptyBorder(i.top, i.left, i.bottom, 4));
b1.setAction(new AbstractAction("OverlayLayoutButton") {
  @Override public void actionPerformed(ActionEvent e) {
    Toolkit.getDefaultToolkit().beep();
  }
});
JButton b2 = new JButton() {
  private final Dimension dim = new Dimension(120, 24);
  @Override public Dimension getPreferredSize() {
    return dim;
  }
  @Override public Dimension getMaximumSize() {
    return getPreferredSize();
  }
  @Override public Dimension getMinimumSize() {
    return getPreferredSize();
  }
};
b2.setAction(new AbstractAction("▼") {
  @Override public void actionPerformed(ActionEvent e) {
    System.out.println("sub");
  }
});
b2.setAlignmentX(Component.RIGHT_ALIGNMENT);
b2.setAlignmentY(Component.BOTTOM_ALIGNMENT);
b1.add(b2);
</code></pre>

## 解説
- 親`JButton`をコンテナとして別の子`JButton`を追加
- 親`JButton`のレイアウトとして`OverlayLayout`を設定し、`setAlignmentX(...)`などで子`JButton`が右下に配置されるよう設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [OverlayLayoutで複数のJButtonを重ねて複合ボタンを作成](https://ateraimemo.com/Swing/CompoundButton.html)
- [Box Layout Features](https://docs.oracle.com/javase/tutorial/uiswing/layout/box.html#features)
- [JTextAreaをキャプションとして画像上にスライドイン](https://ateraimemo.com/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

## コメント
- ボタンサイズの指定方法を変更しました。 -- *aterai* 2008-01-17 (木) 20:39:53
- スクリーンショットなどを更新。 -- *aterai* 2008-10-29 (水) 18:51:52

<!-- dummy comment line for breaking list -->
