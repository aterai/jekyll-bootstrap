---
layout: post
title: OverlayLayoutの使用
category: swing
folder: OverlayLayout
tags: [OverlayLayout, LayoutManager, JButton]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-01-14

## OverlayLayoutの使用
`OverlayLayout`を使用し、`JButton`を重ねて配置します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQqzbG85I/AAAAAAAAAf8/GAYWzSVrHvg/s800/OverlayLayout.png)

### サンプルコード
<pre class="prettyprint"><code>JButton b1 = new JButton();
JButton b2 = new JButton();
b1.setLayout(new OverlayLayout(b1));
Insets i = b1.getBorder().getBorderInsets(b1);
b1.setBorder(BorderFactory.createEmptyBorder(i.top,i.left,i.bottom,4));
b1.setAction(new AbstractAction("OverlayLayoutButton") {
  @Override public void actionPerformed(ActionEvent e) {
    Toolkit.getDefaultToolkit().beep();
  }
});
b2.setAction(new AbstractAction("▼") {
  @Override public void actionPerformed(ActionEvent e) {
    System.out.println("sub");
  }
});
Dimension dim = new Dimension(64, 24);
b2.setMaximumSize(dim);
b2.setPreferredSize(dim);
b2.setMinimumSize(dim);
b2.setAlignmentX(1.0f);
b2.setAlignmentY(1.0f);
b1.add(b2);
</code></pre>

### 解説
上記のサンプルでは、`JButton`に`OverlayLayout`を使って、別の`JButton`を重ねて右下に配置しています。

### 参考リンク
- [Box Layout Features](http://docs.oracle.com/javase/tutorial/uiswing/layout/box.html#features)
- [JTextAreaをキャプションとして画像上にスライドイン](http://terai.xrea.jp/Swing/EaseInOut.html)

<!-- dummy comment line for breaking list -->

### コメント
- ボタンサイズの指定方法を変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-01-17 (木) 20:39:53
- スクリーンショットなどを更新。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-29 (水) 18:51:52

<!-- dummy comment line for breaking list -->

